package src_Villegas_Yeguas_Antonio_David;

import core.game.Observation;
import core.game.StateObservation;
import core.player.AbstractPlayer;
import ontology.Types;
import tools.ElapsedCpuTimer;
import tools.Vector2d;
import tools.com.google.gson.internal.bind.ArrayTypeAdapter;


import java.lang.reflect.Array;
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
    boolean podemos_acabar;

    Double[][] mapa_riesgo;


    public Agent (StateObservation stateObs, ElapsedCpuTimer elapsedCpuTimer){
        fescala = new Vector2d(stateObs.getWorldDimension().width / stateObs.getObservationGrid().length ,
                stateObs.getWorldDimension().height / stateObs.getObservationGrid()[0].length);


        gemas_obtenidas = 0;
        plan = new Stack<>();
        hay_riesgo = false;
        podemos_acabar = true;

        Vector2d tam_mundo = new Vector2d (stateObs.getWorldDimension().width, stateObs.getWorldDimension().height);

        tam_mundo = pixelToGrid(tam_mundo);

        mapa_riesgo = new Double[(int)tam_mundo.x][(int)tam_mundo.y];

        // inicializamos el riesgo, basicamente zonas de riesgo fijo (muros)
        inicializarRiesgo(stateObs);

        // calculamos el riesgo en este momento de la partida
        calcularRiesgo(stateObs);

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

            if (gemas_array != null){
                gemas_a_obtener = 9;
                podemos_acabar = false;
                gemas = gemas_array[0];
                camino_gemas = new Stack<>();
                gemas_obtenidas = 0;

                calcularCaminoGemas(stateObs);


            }
        }

    }

    private Vector2d pixelToGrid( Vector2d pos){
        return  new Vector2d(pos.x / fescala.x, pos.y / fescala.y);
    }

    public void init (StateObservation stateObs, ElapsedCpuTimer elapsedTImer){

    }




    @Override
    public Types.ACTIONS act (StateObservation stateObs, ElapsedCpuTimer elapsedTimer) {

        Types.ACTIONS accion = Types.ACTIONS.ACTION_NIL;

        if (hay_riesgo){
            // comportamiento reactivo

        } else {
            // comportamiento deliberativo

            // intentamos salir por el portal
            if (portal != null){

                //System.out.println(gemas_a_obtener + " " + gemas_obtenidas);
                if (gemas_obtenidas >= gemas_a_obtener){
                    podemos_acabar = true;
                }

                //aunque sea comprobar dos veces lo mismo, no perdemos el tick para
                //calcular y otro para ejecutar, calculamos y ejecutamos en el mismo
                if (podemos_acabar && plan.empty()){
                    calcularPlanAStar(stateObs, pixelToGrid(stateObs.getAvatarPosition()),portal);
                } else if (plan.empty()){
                    if (!gemas.isEmpty()){
                        calcularPlanAStar(stateObs, pixelToGrid(stateObs.getAvatarPosition()), pixelToGrid(camino_gemas.peek().position) );
                        camino_gemas.pop();
                        gemas.remove(0);
                        if (stateObs.getAvatarResources().get(ID_GEMA) != null){
                            gemas_obtenidas = stateObs.getAvatarResources().get(ID_GEMA);
                            stateObs.getResourcesPositions(stateObs.getAvatarPosition());
                        }
                    }

                }

                if (!plan.empty()){
                    accion = plan.peek();
                    plan.pop();

                }

            } else {
                // no hay portal, intentamos sobrevivir los 2000 ticks


            }
        }



        return accion;
    }


    private double calcularPlanAStar(StateObservation stateObs, Vector2d ini ,Vector2d dest){
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
                                if (ya_esta.totalCost + ya_esta.estimatedCost > hijo.totalCost + hijo.estimatedCost){
                                    abiertos.remove(ya_esta);
                                    abiertos.add(hijo);
                                    double p1 = ya_esta.totalCost + ya_esta.estimatedCost;
                                    double p2 = hijo.totalCost + hijo.estimatedCost;
                                    //System.out.println("Asdaf:" + p1 + " " + p2);
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

        // si es el portal calculamos el plan
        calcularPlan(solucion);

        return solucion.totalCost;

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
        ArrayList<Observation> grid[][] = stateObs.getObservationGrid();

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

    private void calcularCaminoGemas(StateObservation stateObs){


        Double[][] distancias = new Double[gemas.size()][gemas.size()];

        for (int i = 0; i < gemas.size(); i++){
            for (int j = i; j < gemas.size(); j++){
                distancias[i][j] = calcularPlanAStar(stateObs, pixelToGrid(gemas.get(i).position), pixelToGrid(gemas.get(j).position) );
                distancias[j][i] = distancias[i][j];
            }
            distancias[i][i] = 0.0;

        }

        PriorityQueue<Pair<ArrayList<Integer>, Double>> caminos = new PriorityQueue<>();
        //ArrayList<Double> peso_caminos = new ArrayList<>();

        for (int i = 0; i < gemas.size(); i++){
            ArrayList<Integer> ini = new ArrayList<>();
            ini.add(i);
            caminos.add(new Pair(ini, 0.0));
            //caminos.get(i).first.add(i);
            //peso_caminos.add();
        }


        Boolean he_encontrado_mejor = false;
        Pair<ArrayList<Integer>, Double> mejor ;

        do {

            mejor = caminos.poll();

            if (mejor.first.size() == 10){
                he_encontrado_mejor = true;
            } else {
                for (int i = 0; i < gemas.size(); i++){
                    if (!mejor.first.contains(i)){
                        ArrayList<Integer> n_camino = new ArrayList<>(mejor.first);
                        n_camino.add(i);
                        caminos.add(new Pair(n_camino, mejor.second + distancias[i][n_camino.get(n_camino.size() - 2)]));
                    }
                }
            }

        } while(!he_encontrado_mejor);

        camino_gemas = new Stack<>();
        for (int i = 0; i < mejor.first.size(); i++){
            Node nuevo = new Node( gemas.get(mejor.first.get(i)).position );
            camino_gemas.add(nuevo);
        }


    }


    private void calcularRiesgo(StateObservation stateObs){
        ArrayList<Observation>[] NPC = stateObs.getNPCPositions();

        // inicializamos valores básicos, en general riesgo 0, muros riesgo infinito
        for (int i = 0; i < mapa_riesgo.length; i++){
            for (int j = 0; j < mapa_riesgo[i].length; j++){
                if (!esObstaculo(stateObs, new Node( new Vector2d(i,j) ) ) ){
                    mapa_riesgo[i][j] = 0.0;
                }
            }
        }


        //añadimos riesgo a los muros

        if (NPC != null){
            ArrayList<Observation> enemigos = NPC[0];

            for (Observation enemigo : enemigos){

            }
        }
    }


    private void inicializarRiesgo(StateObservation stateObs){

        // ponemos el mapa vacio
        for (int i = 0; i < mapa_riesgo.length; i++) {
            for (int j = 0; j < mapa_riesgo[i].length; j++) {
                mapa_riesgo[i][j] = 0.0;
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
                        if (0 <= x && x < mapa_riesgo.length && 0 <= y && y < mapa_riesgo[x].length){
                            if ( !esObstaculo(stateObs, new Node( new Vector2d(x,y) ) ) ){
                                //int suma = Math.abs(k) + Math.abs(l);
                                if ( Math.abs(l) < 2 && Math.abs(k) < 2){
                                    mapa_riesgo[x][y] += 2.0;
                                } else {
                                    mapa_riesgo[x][y] += 1.0;
                                }

                            }

                        }

                    }
                }

                mapa_riesgo[(int)posicion.x][(int)posicion.y] = 11.0;

            }

        }


        for (int i = 0; i < mapa_riesgo.length; i++) {
            for (int j = 0; j < mapa_riesgo[i].length; j++) {
                System.out.print(mapa_riesgo[i][j] + " ");
            }
            System.out.println("");
        }


    }
}


