package Model;

import java.util.ArrayList;

import View.ObserverSend;
import View.SubjectSend;

public class TestConsole implements SubjectSend{
	private ArrayList<ObserverSend> observers = new ArrayList<ObserverSend>();
	char command;
	@Override
	public void registerSend(ObserverSend o) {
		observers.add(o);
		
	}

	@Override
	public void unregisterSend(ObserverSend o) {
		observers.remove(o);
		
	}

	@Override
	public void notifySend() {
		for(ObserverSend o : observers){
			o.updateSend(command);
		}	
	}
	
	public void sendCommand(char c){
		System.out.println("enviando el commando:" + c);
		command = c;
		notifySend();
	}
}
