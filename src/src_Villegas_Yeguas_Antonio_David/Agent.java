package src_Villegas_Yeguas_Antonio_David;

import core.game.Observation;
import core.game.StateObservation;
import core.player.AbstractPlayer;
import ontology.Types;
import tools.ElapsedCpuTimer;
import tools.Vector2d;


import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.PriorityQueue;
import java.util.Stack;

public class Agent extends AbstractPlayer{

    Vector2d fescala;
    Vector2d portal;
    Stack<Types.ACTIONS> plan;
    int gemas_obtenidas;


    public Agent (StateObservation stateObs, ElapsedCpuTimer elapsedCpuTimer){
        fescala = new Vector2d(stateObs.getWorldDimension().width / stateObs.getObservationGrid().length ,
                stateObs.getWorldDimension().height / stateObs.getObservationGrid()[0].length);


        gemas_obtenidas = 0;
        plan = new Stack<>();


        //Se crea una lista de observaciones de portales, ordenada por cercania al avatar
        ArrayList<Observation>[] posiciones = stateObs.getPortalsPositions(stateObs.getAvatarPosition());

        // si no hay portales
        if(posiciones[0].isEmpty()){
            portal = null;
        } else {
            //Seleccionamos el portal mas proximo
            portal = posiciones[0].get(0).position;
            portal = pixelToGrid(portal);

            // lista de diamantes, ordenada por cercania al avatar
            // ArrayList<Observation>[] diamantes = stateObs.getResourcesPositions(stateObs.getAvatarPosition());

            // calculamos la ruta al portal
            //calcularPlanPosPuertaAStar(stateObs, portal);
        }

    }

    public void init (StateObservation stateObs, ElapsedCpuTimer elapsedTImer){


    }


    private Vector2d pixelToGrid( Vector2d pos){
        return  new Vector2d(pos.x / fescala.x, pos.y / fescala.y);
    }

    @Override
    public Types.ACTIONS act (StateObservation stateObs, ElapsedCpuTimer elapsedTimer) {

        Types.ACTIONS accion = Types.ACTIONS.ACTION_NIL;

        // intentamos salir por el portal
        if (portal != null){
            calcularPlanPosPuertaAStar(stateObs, portal);
            if (plan.size() > 0){
                accion = plan.peek();
                plan.pop();
                System.out.println(accion.toString() + " " + stateObs.getAvatarOrientation().x + " " + stateObs.getAvatarOrientation().y);
                System.out.println(pixelToGrid(stateObs.getAvatarPosition()));

            }

        } else {
            // no hay portal, intentamos sobrevivir los 2000 ticks


        }


        return accion;
    }


    private void calcularPlanPosPuertaAStar(StateObservation stateObs, Vector2d dest){
        Node inicio = new Node(pixelToGrid(stateObs.getAvatarPosition()));
        inicio.orientation = orientacion(stateObs.getAvatarOrientation());

        Node fin = new Node(dest);

        PriorityQueue<Node> abiertos = new PriorityQueue<>();
        PriorityQueue<Node> cerrados = new PriorityQueue<>();

        // no nos cuesta nada llegar al inicio
        inicio.totalCost = 0;

        inicio.estimatedCost = heuristica(inicio, fin);

        abiertos.add(inicio);

        Node solucion = null;
        Node mejor_abiertos = null;

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
                                    System.out.println("Asdaf:" + p1 + " " + p2);
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

        calcularPlan(solucion);


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

}