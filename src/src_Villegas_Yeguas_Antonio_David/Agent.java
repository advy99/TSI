package src_Villegas_Yeguas_Antonio_David;

import core.game.Observation;
import core.game.StateObservation;
import core.player.AbstractPlayer;
import ontology.Types;
import tools.ElapsedCpuTimer;
import tools.Vector2d;
import tools.com.google.gson.internal.bind.ArrayTypeAdapter;


import java.lang.reflect.Array;
import java.lang.reflect.Type;
import java.util.*;

public class Agent extends AbstractPlayer{

    static final int ID_GEMA = 6;
    Vector2d fescala;
    Vector2d portal;
    Stack<Types.ACTIONS> plan;
    int gemas_a_obtener;
    int gemas_obtenidas;
    ArrayList<Observation> gemas;
    Stack<Node> camino_gemas;

    boolean hay_riesgo;
    boolean siempre_hay_riesgo;
    boolean me_he_movido_riesgo;
    boolean podemos_acabar;

    Double[][] mapa_riesgo_base;
    Double[][] mapa_riesgo;


    public Agent (StateObservation stateObs, ElapsedCpuTimer elapsedCpuTimer){
        fescala = new Vector2d(stateObs.getWorldDimension().width / stateObs.getObservationGrid().length ,
                stateObs.getWorldDimension().height / stateObs.getObservationGrid()[0].length);


        gemas_obtenidas = 0;
        gemas_a_obtener = 10;
        plan = new Stack<>();
        hay_riesgo = false;
        me_he_movido_riesgo = true;
        podemos_acabar = false;
        gemas = new ArrayList<>();

        Vector2d tam_mundo = new Vector2d (stateObs.getWorldDimension().width, stateObs.getWorldDimension().height);

        tam_mundo = pixelToGrid(tam_mundo);

        mapa_riesgo_base = new Double[(int)tam_mundo.x][(int)tam_mundo.y];

        // inicializamos el riesgo, basicamente zonas de riesgo fijo (muros)
        inicializarRiesgo(stateObs);

        //Se crea una lista de observaciones de portales, ordenada por cercania al avatar
        ArrayList<Observation>[] posiciones = stateObs.getPortalsPositions(stateObs.getAvatarPosition());


        // si no hay portales
        if(posiciones == null ){
            portal = null;
        } else {
            //Seleccionamos el portal mas proximo
            portal = posiciones[0].get(0).position;
            portal = pixelToGrid(portal);

            // lista de diamantes, ordenada por cercania al avatar
            ArrayList<Observation>[] gemas_array = stateObs.getResourcesPositions(stateObs.getAvatarPosition());

            if (gemas_array != null && gemas_array[0].size() >= gemas_a_obtener){

                podemos_acabar = false;
                gemas = gemas_array[0];
                camino_gemas = new Stack<>();
                gemas_obtenidas = 0;
                siempre_hay_riesgo = false;

                // tenemos muchas gemas, el calculo es muy grande, así que nos
                // quedamos con las 11 más prometedoras
                if (gemas.size() > 11){
                    List<Observation> gemas_2 = gemas.subList(0, 11);
                    gemas = new ArrayList<>(gemas_2);
                }

                //System.out.println(elapsedCpuTimer.elapsedMillis());
                //System.out.println(elapsedCpuTimer.remainingTimeMillis());
                calcularCaminoGemas(stateObs, gemas_a_obtener);
                //System.out.println(elapsedCpuTimer.elapsedMillis());
                //System.out.println(elapsedCpuTimer.remainingTimeMillis());

            } else {
                if (gemas_a_obtener != 0){
                    siempre_hay_riesgo = true;
                }
            }
        }

    }



    public void init (StateObservation stateObs, ElapsedCpuTimer elapsedTimer){

    }

    private Vector2d pixelToGrid( Vector2d pos){
        return  new Vector2d(pos.x / fescala.x, pos.y / fescala.y);
    }



    @Override
    public Types.ACTIONS act (StateObservation stateObs, ElapsedCpuTimer elapsedTimer) {

        Types.ACTIONS accion = Types.ACTIONS.ACTION_NIL;


        hay_riesgo = calcularRiesgo(stateObs);

        if (hay_riesgo || siempre_hay_riesgo){
            // comportamiento reactivo
            Vector2d pos = new Vector2d(pixelToGrid(stateObs.getAvatarPosition()));
            //System.out.println("hay_riesgo: " + mapa_riesgo_base[(int)pos.x][(int)pos.y] + " " + mapa_riesgo[(int)pos.x][(int)pos.y]);
            me_he_movido_riesgo = true;

            accion = calcularAccionRiesgo(stateObs);

            if (accion != Types.ACTIONS.ACTION_NIL){
                plan = new Stack<>();
            }

        } else {
            // comportamiento deliberativo


            // intentamos salir por el portal
            if (portal != null){

                if (stateObs.getAvatarResources().get(ID_GEMA) != null){
                    gemas_obtenidas = stateObs.getAvatarResources().get(ID_GEMA);
                }
                //System.out.println(gemas_a_obtener + " " + gemas_obtenidas);
                if (gemas_obtenidas >= gemas_a_obtener){
                    podemos_acabar = true;
                }

                //aunque sea comprobar dos veces lo mismo, no perdemos el tick para
                //calcular y otro para ejecutar, calculamos y ejecutamos en el mismo
                if (podemos_acabar && plan.empty()){
                    calcularPlan(calcularPlanAStar(stateObs, pixelToGrid(stateObs.getAvatarPosition()),portal));
                    //System.out.println(elapsedTimer.elapsedMillis());

                    //System.out.println(elapsedTimer.remainingTimeMillis());

                } else if (plan.empty()){
                    if (!gemas.isEmpty() && !camino_gemas.isEmpty()){

                        if (me_he_movido_riesgo){
                            me_he_movido_riesgo = false;

                            // con menos de 10 gemas soy capaz de recalcular en menos de 40ms
                            if (gemas_a_obtener - gemas_obtenidas < 8) {
                                gemas = stateObs.getResourcesPositions(stateObs.getAvatarPosition())[0];
                                calcularCaminoGemas(stateObs, gemas_a_obtener - gemas_obtenidas);
                            }
                        } else {
                            camino_gemas.pop();
                            gemas.remove(0);
                            //me_vhe_movido_riesgo = true;
                        }
                        calcularPlan(calcularPlanAStar(stateObs, pixelToGrid(stateObs.getAvatarPosition()), pixelToGrid(camino_gemas.peek().position) ));
                        //camino_gemas.pop();



                    }

                }

                if (!plan.empty() && elapsedTimer.remainingTimeMillis() > 0){
                    accion = plan.peek();
                    plan.pop();

                }

            }

        }



        return accion;
    }


    private Node calcularPlanAStar(StateObservation stateObs, Vector2d ini ,Vector2d dest){
        Node inicio = new Node(ini);
        inicio.orientation = orientacion(stateObs.getAvatarOrientation());

        Node fin = new Node(dest);

        PriorityQueue<Node> abiertos = new PriorityQueue<>();
        PriorityQueue<Node> cerrados = new PriorityQueue<>();

        // no nos cuesta nada llegar al inicio
        inicio.totalCost = 0;

        inicio.estimatedCost = heuristica(inicio, fin);

        abiertos.add(inicio);

        Node solucion = null;
        Node mejor_abiertos = inicio;

        boolean es_solucion = false;

        ArrayList<Types.ACTIONS> actions = new ArrayList<>();
        actions.add(Types.ACTIONS.ACTION_RIGHT);
        actions.add(Types.ACTIONS.ACTION_LEFT);
        actions.add(Types.ACTIONS.ACTION_UP);
        actions.add(Types.ACTIONS.ACTION_DOWN);

        // mientras abiertos no este vacio
        while (!abiertos.isEmpty() && !es_solucion){
            // Escogemos el mejor de abiertos (es una priority queue, ya
            // están ordenados)
            mejor_abiertos = abiertos.poll();
            cerrados.add(mejor_abiertos);

            fin.orientation = mejor_abiertos.orientation;
            es_solucion = mejor_abiertos.equals(fin);

            if (!es_solucion){

                // expandimos el nodo aplicando las 4 acciones posibles
                for (Types.ACTIONS accion : actions){
                    Node hijo = new Node ( mejor_abiertos );

                    if (accion.equals(Types.ACTIONS.ACTION_LEFT) ){
                        hijo.position.x = hijo.position.x - 1;
                        hijo.orientation = 3;

                    } else if ( accion.equals(Types.ACTIONS.ACTION_RIGHT) ) {
                        hijo.position.x = hijo.position.x + 1;
                        hijo.orientation = 1;
                    } else if ( accion.equals(Types.ACTIONS.ACTION_UP) ) {
                        hijo.position.y = hijo.position.y - 1;
                        hijo.orientation = 0;

                    } else if ( accion.equals(Types.ACTIONS.ACTION_DOWN) ) {
                        hijo.position.y = hijo.position.y + 1;
                        hijo.orientation = 2;
                    }



                    if (!esObstaculo(stateObs, hijo)){

                        hijo.parent = mejor_abiertos;

                        hijo.totalCost = mejor_abiertos.totalCost + 1.0;

                        hijo.estimatedCost = heuristica(hijo, fin);

                        if (hijo.orientation != mejor_abiertos.orientation){
                            hijo.totalCost = hijo.totalCost + 1.0;
                        }


                        if (!abiertos.contains(hijo) && !cerrados.contains(hijo) ){
                            // sumamos el coste desde el padre, más el hijo (1 de por sí, + 1 si tenía otra direccion)
                            //hijo.totalCost = mejor_abiertos.totalCost + hijo.totalCost;
                            abiertos.add(hijo);
                        } else {

                            if (abiertos.contains(hijo)){
                                ArrayList<Node> abiertos_array= new ArrayList<Node>(Arrays.asList(abiertos.toArray(new Node[abiertos.size()])));
                                Node ya_esta = abiertos_array.get(abiertos_array.indexOf(hijo));
                                if (ya_esta.totalCost > hijo.totalCost){
                                    abiertos.remove(ya_esta);
                                    abiertos.add(hijo);
                                }
                            }

                            /* No va a pasar nunca, la heuristica es consistente (monotona) */
                            /*
                            if (cerrados.contains(hijo)){
                                ArrayList<Node> cerrados_array= new ArrayList<Node>(Arrays.asList(cerrados.toArray(new Node[cerrados.size()])));
                                Node ya_esta = cerrados_array.get(cerrados_array.indexOf(hijo));

                                if (ya_esta.totalCost + ya_esta.estimatedCost > hijo.totalCost + hijo.estimatedCost){
                                    cerrados.remove(ya_esta);
                                    abiertos.add(hijo);
                                    double p1 = ya_esta.totalCost + ya_esta.estimatedCost;
                                    double p2 = hijo.totalCost + hijo.estimatedCost;
                                    System.out.println("dsdfds:" + p1 + " " + p2);

                                }
                            }*/
                        }
                    }




                }


            } else {
                solucion = mejor_abiertos;
            }

        }
        if (solucion != null){
            return solucion;
        } else {
            Node mal = new Node(ini);
            mal.totalCost = -1.0;
            return mal;
        }




    }

    // heuristica: distancia manhattan -> es admisible para nuestro problema
    // (1 tick es un movimiento)
    private double heuristica(Node inicio, Node fin){

        return( Math.abs(inicio.position.x - fin.position.x) +
                Math.abs(inicio.position.y - fin.position.y) );
    }



    private void calcularPlan(Node n){
        plan = new Stack<>();

        while (n != null){

            if(n.parent != null) {

                plan.push(n.getMov(n.parent));

                if (n.orientation != n.parent.orientation){
                    plan.push(plan.peek());
                }

            }

            n = n.parent;
        }

    }

    private boolean esObstaculo(StateObservation stateObs, Node nodo){
        ArrayList<Observation>[][] grid = stateObs.getObservationGrid();

        for(Observation obs : grid[(int)nodo.position.x][ (int)nodo.position.y]) {
            if(obs.itype == 0)
                return true;
        }


        return false;


    }

    // pasamos de direcciones del avatar a las nuestras propias
    private int orientacion(Vector2d o){
        // si miramos hacia arriba o hacia abajo
        if (o.x == 0){
            // si miramos hacia arriba en nuestro sistema es 0
            if (o.y == -1) {
                return 0;
            } else{
                // hacia abajo es dos
                return 2;
            }
        } else {
            // si estamos mirando hacia los lados
            if (o.x == -1){
                //en nuestro sistema mirar a la izquierda es 3
                return 3;
            } else {
                // mirar a la derecha es 1
                return 1;
            }
        }
    }

    private void calcularCaminoGemas(StateObservation stateObs, int num_gem){


        Double[][] distancias = new Double[gemas.size() + 2][gemas.size() + 2];

        for (int i = 0; i < gemas.size(); i++){
            for (int j = i; j < gemas.size(); j++){
                distancias[i][j] = calcularPlanAStar(stateObs, pixelToGrid(gemas.get(i).position), pixelToGrid(gemas.get(j).position) ).totalCost;
                distancias[j][i] = distancias[i][j];
            }
            distancias[i][i] = 0.0;

        }


        for (int i = 0; i < gemas.size(); i++){

            distancias[gemas.size()][i] = calcularPlanAStar(stateObs, pixelToGrid(gemas.get(i).position), portal ).totalCost;
            distancias[i][gemas.size()] = distancias[gemas.size()][i];


            distancias[gemas.size()+1][i] = calcularPlanAStar(stateObs, pixelToGrid(stateObs.getAvatarPosition()), pixelToGrid(gemas.get(i).position) ).totalCost;
            distancias[i][gemas.size()+1] = distancias[gemas.size()+1][i];
        }

        // no hace falta calcular de la posicion inicial al portal, esa nunca la voy a usar

        distancias[gemas.size()][gemas.size()] = 0.0;
        distancias[gemas.size()+1][gemas.size()+1] = 0.0;

        PriorityQueue<Pair<ArrayList<Integer>, Double>> caminos = new PriorityQueue<>();
        //ArrayList<Double> peso_caminos = new ArrayList<>();

        for (int i = 0; i < gemas.size(); i++){
            ArrayList<Integer> ini = new ArrayList<>();
            ini.add(i);
            caminos.add(new Pair<>(ini, distancias[gemas.size()+1][i]));
        }


        boolean he_encontrado_mejor = false;
        Pair<ArrayList<Integer>, Double> mejor = caminos.peek() ;
        //Pair<ArrayList<Integer>, Double> mejor_con_mas_gemas = mejor ;


        do {

            mejor = caminos.poll();

            if (mejor == null){
                System.out.println("Esto nunca debería pasar, el mapa está mal");
                System.out.println("Deberia tener al menos 10 gemas accesibles");
                he_encontrado_mejor = true;
            } else if (mejor.first.size() >= num_gem){
                //he_encontrado_mejor = true;
                // si tenemos 11, ya esta el portal
                if (mejor.first.size() >= num_gem + 1){
                    he_encontrado_mejor = true;
                } else {
                    ArrayList<Integer> n_camino = new ArrayList<>(mejor.first);
                    n_camino.add(gemas.size());
                    caminos.add(new Pair<>(n_camino, mejor.second + distancias[gemas.size()][n_camino.get(n_camino.size() - 2)]));
                }
            } else {
                for (int i = 0; i < gemas.size(); i++){
                    if (!mejor.first.contains(i) && distancias[i][mejor.first.get(mejor.first.size()-1)] != -1){
                        ArrayList<Integer> n_camino = new ArrayList<>(mejor.first);
                        n_camino.add(i);
                        caminos.add(new Pair<>(n_camino, mejor.second + distancias[i][n_camino.get(n_camino.size() - 2)] ));
                    }
                }
            }

        } while(!he_encontrado_mejor);

        //System.out.println(mejor.second);
        //System.out.println(distancias[gemas.size()][mejor.first.get(0)]);

        camino_gemas = new Stack<>();
        if (mejor != null) {
            mejor.first.remove(mejor.first.size() - 1);
            for (int i = mejor.first.size() - 1; i >= 0; i--) {
                Node nuevo = new Node(gemas.get(mejor.first.get(i)).position);
                camino_gemas.add(nuevo);
            }
        }

    }


    private boolean calcularRiesgo(StateObservation stateObs){
        ArrayList<Observation>[] NPC = stateObs.getNPCPositions();

        // inicializamos valores básicos, en general riesgo 0, muros riesgo infinito
        Vector2d tam_mundo = new Vector2d (stateObs.getWorldDimension().width, stateObs.getWorldDimension().height);

        tam_mundo = pixelToGrid(tam_mundo);

        mapa_riesgo = new Double[(int)tam_mundo.x][(int)tam_mundo.y];
        for (int i = 0; i < mapa_riesgo_base.length; i++){
            for (int j = 0; j < mapa_riesgo_base[i].length; j++){
                mapa_riesgo[i][j] = mapa_riesgo_base[i][j];
            }
        }
        //añadimos riesgo a los muros

        if (NPC != null){
            ArrayList<Observation> enemigos = NPC[0];

            for (Observation enemigo : enemigos){
                Vector2d posicion = new Vector2d(pixelToGrid(new Vector2d(enemigo.position)));

                for (int k = 5; k >= -5; k--){
                    for (int l = 5; l >= -5; l--){
                        int x = (int)posicion.x + k;
                        int y = (int)posicion.y + l;
                        if (0 <= x && x < mapa_riesgo.length && 0 <= y && y < mapa_riesgo[x].length){
                            if ( !mapa_riesgo[x][y].equals(Double.MAX_VALUE) && !esObstaculo(stateObs, new Node( new Vector2d(x,y) ) ) ){
                                //int suma = Math.abs(k) + Math.abs(l);
                                if (mapa_riesgo[x][y] >= mapa_riesgo_base[x][y]){
                                    if ( Math.abs(l) < 2 && Math.abs(k) < 2){
                                        mapa_riesgo[x][y] += 35.0;
                                    } else if ( Math.abs(l) < 3 && Math.abs(k) < 3){
                                        mapa_riesgo[x][y] += 30.0;
                                    } else if (Math.abs(l) < 4 && Math.abs(k) < 4) {
                                        mapa_riesgo[x][y] += 25.0;
                                    } if (Math.abs(l) < 5 && Math.abs(k) < 5) {
                                        mapa_riesgo[x][y] += 20.0;
                                    } else {
                                        mapa_riesgo[x][y] += 17.0;
                                    }
                                } // else : ya estamos contabilizando un enemigo


                            }

                        }

                    }
                }

                mapa_riesgo[(int)posicion.x][(int)posicion.y] = Double.MAX_VALUE;


            }
        }


        // intentamos ir a por las gemas, quitando riesgo al rededor de estas
        ArrayList<Observation>[] GEM = stateObs.getResourcesPositions();
        if (GEM != null){
            ArrayList<Observation> gemas_por_recoger = GEM[0];

            for (Observation gema : gemas_por_recoger){
                Vector2d posicion = new Vector2d(pixelToGrid(new Vector2d(gema.position)));

                for (int k = 3; k >= -3; k--){
                    for (int l = 3; l >= -3; l--){
                        int x = (int)posicion.x + k;
                        int y = (int)posicion.y + l;
                        if (0 <= x && x < mapa_riesgo.length && 0 <= y && y < mapa_riesgo[x].length){
                            if ( !mapa_riesgo[x][y].equals(Double.MAX_VALUE) && !esObstaculo(stateObs, new Node( new Vector2d(x,y) ) ) ){
                                //int suma = Math.abs(k) + Math.abs(l);
                                if ( Math.abs(l) < 2 && Math.abs(k) < 2){
                                    mapa_riesgo[x][y] -= 7.0;
                                } else if ( Math.abs(l) < 3 && Math.abs(k) < 3){
                                    mapa_riesgo[x][y] -= 6.0;
                                } else {
                                    mapa_riesgo[x][y] -= 5.0;
                                }

                            }

                        }

                    }
                }



            }
        }

        /*for (int i = 0; i < mapa_riesgo.length; i++) {
            for (int j = 0; j < mapa_riesgo[i].length; j++) {
                System.out.print(mapa_riesgo[i][j] + " ");
            }
            System.out.println("");
        }*/

        Vector2d pos_personaje = new Vector2d(pixelToGrid(stateObs.getAvatarPosition()) ) ;

        // 16.0 es el mayor riesgo que pueden generar los muros.
        return mapa_riesgo[(int)pos_personaje.x][(int)pos_personaje.y] > 16.0;

    }


    private void inicializarRiesgo(StateObservation stateObs){

        // ponemos el mapa vacio
        for (int i = 0; i < mapa_riesgo_base.length; i++) {
            for (int j = 0; j < mapa_riesgo_base[i].length; j++) {
                mapa_riesgo_base[i][j] = 0.0;
            }
        }

        ArrayList<Observation>[] w = stateObs.getImmovablePositions();

        if (w != null){
            ArrayList<Observation> muros = w[0];

            // para todos los muros
            for (Observation muro : muros){
                Vector2d posicion = new Vector2d(pixelToGrid(new Vector2d(muro.position)));

                for (int k = 2; k >= -2; k--){
                    for (int l = 2; l >= -2; l--){
                        int x = (int)posicion.x + k;
                        int y = (int)posicion.y + l;
                        if (0 <= x && x < mapa_riesgo_base.length && 0 <= y && y < mapa_riesgo_base[x].length){
                            if ( !esObstaculo(stateObs, new Node( new Vector2d(x,y) ) ) ){
                                //int suma = Math.abs(k) + Math.abs(l);
                                if ( Math.abs(l) < 2 && Math.abs(k) < 2){
                                    mapa_riesgo_base[x][y] += 1.0;
                                } else {
                                    mapa_riesgo_base[x][y] += 0.5;
                                }

                            }

                        }

                    }
                }

                mapa_riesgo_base[(int)posicion.x][(int)posicion.y] = Double.MAX_VALUE;

            }

        }

        /*
        for (int i = 0; i < mapa_riesgo_base.length; i++) {
            for (int j = 0; j < mapa_riesgo_base[i].length; j++) {
                System.out.print(mapa_riesgo_base[i][j] + " ");
            }
            System.out.println("");
        }*/


    }



    private Types.ACTIONS calcularAccionRiesgo(StateObservation stateObs) {

        Types.ACTIONS accion = Types.ACTIONS.ACTION_NIL;

        Node pos = new Node(pixelToGrid(stateObs.getAvatarPosition()));
        pos.orientation = orientacion(stateObs.getAvatarOrientation());

        Double riesgo_actual = mapa_riesgo[(int)pos.position.x][(int)pos.position.y];

        if (mapa_riesgo[(int)pos.position.x + 1][(int)pos.position.y] <= riesgo_actual){
            accion = Types.ACTIONS.ACTION_RIGHT;
            riesgo_actual = mapa_riesgo[(int)pos.position.x + 1][(int)pos.position.y];
        }

        if (mapa_riesgo[(int)pos.position.x - 1][(int)pos.position.y] <= riesgo_actual){
            accion = Types.ACTIONS.ACTION_LEFT;
            riesgo_actual = mapa_riesgo[(int)pos.position.x - 1][(int)pos.position.y];
        }

        if (mapa_riesgo[(int)pos.position.x][(int)pos.position.y - 1] <= riesgo_actual){
            accion = Types.ACTIONS.ACTION_UP;
            riesgo_actual = mapa_riesgo[(int)pos.position.x][(int)pos.position.y - 1];

        }

        if (mapa_riesgo[(int)pos.position.x][(int)pos.position.y + 1] <= riesgo_actual){
            accion = Types.ACTIONS.ACTION_DOWN;
        }

        return accion;

    }

}


