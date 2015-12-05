package Model;

public interface SubjectReceive {
	public void registerReceive(ObserverReceive o);
	public void unregisterReceive(ObserverReceive  o);
	public void notifyReceive(String ang);
}
