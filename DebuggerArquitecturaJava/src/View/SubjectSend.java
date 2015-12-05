package View;

public interface SubjectSend {
	public void registerSend(ObserverSend o);
	public void unregisterSend(ObserverSend  o);
	public void notifySend();
}
