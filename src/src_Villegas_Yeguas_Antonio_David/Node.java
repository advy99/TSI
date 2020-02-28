package src_Villegas_Yeguas_Antonio_David;

import core.game.StateObservation;
import ontology.Types;
import tools.Direction;
import tools.Vector2d;

import java.lang.reflect.Type;


/**
 * Created by dperez on 13/01/16.
 *
 * Modified by Antonio David Villegas Yeguas
 */
public class Node implements Comparable<Node> {

    public double totalCost;
    public double estimatedCost;
    public Node parent;
    public Vector2d position;
    public int id;

    public StateObservation stateObs;

    public Node(Vector2d pos)
    {
        estimatedCost = 0.0f;
        totalCost = 1.0f;
        parent = null;
        position = pos;
        id = ((int)(position.x) * 100 + (int)(position.y));
    }

    @Override
    public int compareTo(Node n) {
        if(this.estimatedCost + this.totalCost < n.estimatedCost + n.totalCost)
            return -1;
        if(this.estimatedCost + this.totalCost > n.estimatedCost + n.totalCost)
            return 1;
        return 0;
    }

    @Override
    public boolean equals(Object o)
    {
        boolean equals = this.position.equals(((Node)o).position);

        if (this.stateObs != null && ((Node)o).stateObs != null ){
            equals = equals && this.stateObs.getAvatarOrientation().x == ((Node)o).stateObs.getAvatarOrientation().x &&
                               this.stateObs.getAvatarOrientation().y == ((Node)o).stateObs.getAvatarOrientation().y;
        }

        return equals;
    }


    public Types.ACTIONS getMov(Node pre) {

        //TODO: New types of actions imply a change in this method.
        Types.ACTIONS action = Types.ACTIONS.ACTION_NIL;

        if(pre.position.x < this.position.x)
            action = Types.ACTIONS.ACTION_RIGHT;
        if(pre.position.x > this.position.x)
            action = Types.ACTIONS.ACTION_LEFT;

        if(pre.position.y < this.position.y)
            action = Types.ACTIONS.ACTION_DOWN;
        if(pre.position.y > this.position.y)
            action = Types.ACTIONS.ACTION_UP;

        return action;
    }
}
