package Model;

import Utils.Pair;

public interface SubjectReceive {
	public void registerReceive(ObserverReceive o);
	public void unregisterReceive(ObserverReceive  o);
	public void notifyReceive(Pair<String,Integer> data);
}
