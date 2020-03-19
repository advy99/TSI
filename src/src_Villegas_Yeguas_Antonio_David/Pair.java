package src_Villegas_Yeguas_Antonio_David;

import java.util.Map;

/**
 * Created with IntelliJ IDEA.
 * User: Diego
 * Date: 20/10/13
 * Time: 17:07
 * This is a Java port from Tom Schaul's VGDL - https://github.com/schaul/py-vgdl
 */
public class Pair<T,U> implements Map.Entry<T, U>, Comparable{

    public T first;
    public U second;

    public Pair(T first, U second)
    {
        this.first = first;
        this.second = second;
    }

    @Override
    public T getKey() {
        return first;
    }

    @Override
    public U getValue() {
        return second;
    }

    @Override
    public U setValue(U value) {
        second = value;
        return second;
    }

    @Override
    public int compareTo(Object obj) {

        Pair o = (Pair) obj;
        if ( (Double) o.second > (Double) this.second){
            return -1;
        } else if ((Double) o.second < (Double) this.second){
            return 1;
        } else {
            return 0;
        }
    }

    @Override
    public boolean equals(Object obj) {

        return ( ((Pair) obj).first.equals(this.first) &&
                ((Pair) obj).second.equals(this.second));
    }

    @SuppressWarnings("unchecked")
    public Pair copy()  { return new Pair(first, second); }
}