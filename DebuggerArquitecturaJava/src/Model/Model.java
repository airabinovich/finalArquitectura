package Model;

import View.ObserverSend;

public class Model implements ObserverSend, ObserverReceive{
	private enum Status {BUSY, AVAILABLE};
	
	private Status status = Status.AVAILABLE;
	
	private int actFrom;
	private int actTo;
	private int angAct;
	
	@Override
	public void updateSend(char command) {
		status= Status.BUSY;
	}

	@Override
	public void updateReceive(String rcv) {
		if (rcv.toLowerCase().contains("available")){
			status=Status.AVAILABLE;
		} 
		else {
			try{
				int a= Integer.parseInt(rcv);
				angAct= a;
			}
			catch(NumberFormatException e){
	
			}
		}
	}

	public boolean isBusy() {
		return status==Status.BUSY;
	}
	
	public Status getStatus() {
		return status;
	}

	public int getActFrom() {
		return actFrom;
	}

	public int getActTo() {
		return actTo;
	}

	public int getAngAct() {
		return angAct;
	}

}
