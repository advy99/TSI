package src_Villegas_Yeguas_Antonio_David;

import core.game.Observation;
import core.game.StateObservation;
import core.player.AbstractPlayer;
import ontology.Types;
import tools.ElapsedCpuTimer;
import tools.Vector2d;


import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.PriorityQueue;
import java.util.Stack;

public class Agent extends AbstractPlayer{

    Vector2d fescala;
    Vector2d portal;
    Stack<Types.ACTIONS> plan;

    public Agent (StateObservation stateObs, ElapsedCpuTimer elapsedCpuTimer){
        fescala = new Vector2d(stateObs.getWorldDimension().width / stateObs.getObservationGrid().length ,
                stateObs.getWorldDimension().height / stateObs.getObservationGrid()[0].length);


        ArrayList<Types.ACTIONS> plan;

        //Se crea una lista de observaciones de portales, ordenada por cercania al avatar
        ArrayList<Observation>[] posiciones = stateObs.getPortalsPositions(stateObs.getAvatarPosition());

        // si no hay portales
        if(posiciones[0].isEmpty()){
            portal = null;
        } else {
            //Seleccionamos el portal mas proximo
            portal = posiciones[0].get(0).position;
            portal = pixelToGrid(portal);
            //portal.x = Math.floor(portal.x / fescala.x);
            //portal.y = Math.floor(portal.y / fescala.y);

            calcularPlanPosPuertaAStar(stateObs);
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
            if (plan.size() > 0){
                accion = plan.peek();
                plan.pop();
                System.out.println(accion.toString());
            }

        } else {
            // no hay portal, intentamos sobrevivir los 2000 ticks


        }


        return accion;
    }


    private void calcularPlanPosPuertaAStar(StateObservation stateObs){
        Node inicio = new Node(pixelToGrid(stateObs.getAvatarPosition()));

        Node fin = new Node(portal);

        PriorityQueue<Node> abiertos = new PriorityQueue<>();
        PriorityQueue<Node> cerrados = new PriorityQueue<>();

        // no nos cuesta nada llegar al inicio
        inicio.totalCost = 0;
        inicio.stateObs = stateObs;


        inicio.estimatedCost = heuristica(inicio, fin);

        abiertos.add(inicio);

        Node solucion = null;

        boolean es_solucion = false;

        // mientras abiertos no este vacio
        while (!abiertos.isEmpty() && !es_solucion){
            // Escogemos el mejor de abiertos (es una priority queue, ya
            // están ordenados)
            Node mejor_abiertos = abiertos.poll();
            cerrados.add(mejor_abiertos);

            es_solucion = mejor_abiertos.equals(fin);

            if (!es_solucion){
                ArrayList<Types.ACTIONS> actions = mejor_abiertos.stateObs.getAvailableActions();
                actions.remove(Types.ACTIONS.ACTION_USE);
                // expandimos el nodo aplicando las 4 acciones posibles
                for (Types.ACTIONS accion : actions){
                    Node hijo = new Node ( new Vector2d(mejor_abiertos.position.x,
                                                        mejor_abiertos.position.y ) );

                    hijo.stateObs = mejor_abiertos.stateObs.copy();
                    hijo.stateObs.advance(accion);


                    if (!mejor_abiertos.stateObs.getAvatarOrientation().equals(hijo.stateObs.getAvatarOrientation())) {
                        hijo.totalCost = hijo.totalCost + 1;
                    } else if (accion.equals(Types.ACTIONS.ACTION_LEFT) ){
                        hijo.position.x = hijo.position.x - 1;

                    } else if ( accion.equals(Types.ACTIONS.ACTION_RIGHT) ) {
                        hijo.position.x = hijo.position.x + 1;

                    } else if ( accion.equals(Types.ACTIONS.ACTION_UP) ) {
                        hijo.position.y = hijo.position.y + 1;

                    } else if ( accion.equals(Types.ACTIONS.ACTION_DOWN) ) {
                        hijo.position.y = hijo.position.y - 1;

                    }



                    if (!esObstaculo(hijo)){
                        hijo.estimatedCost = heuristica(hijo, fin);

                        hijo.parent = mejor_abiertos;


                        if (!abiertos.contains(hijo) && !cerrados.contains(hijo) ){
                            // sumamos el coste desde el padre, más el hijo (1 de por sí, + 1 si tenía otra direccion)
                            hijo.totalCost = mejor_abiertos.totalCost + hijo.totalCost;

                            abiertos.add(hijo);
                        } else if (mejor_abiertos.totalCost + hijo.totalCost < hijo.totalCost) {
                            if (abiertos.contains(hijo)){
                                abiertos.remove(hijo);
                            }

                            if (cerrados.contains(hijo)){
                                cerrados.remove(hijo);
                            }
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

        double distancia_manhattan =( Math.abs(inicio.position.x - fin.position.x) +
                                      Math.abs(inicio.position.y - fin.position.y) );


        return distancia_manhattan;
    }



    private void calcularPlan(Node n){
        plan = new Stack<>();

        while (n != null){

            if(n.parent != null) {


                if (n.getMov((n).parent).equals(Types.ACTIONS.ACTION_NIL)){
                    plan.push(plan.peek());
                } else{
                    plan.push(n.getMov(n.parent));
                }

            }

            n = n.parent;
        }

    }

    private boolean esObstaculo(Node nodo){
        ArrayList<Observation> grid[][] = nodo.stateObs.getObservationGrid();

        for(Observation obs : grid[(int)nodo.position.x][ (int)nodo.position.y]) {
            if(obs.itype == 0)
                return true;
        }


        return false;


    }

}