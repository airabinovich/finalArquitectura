package Main;

import Model.Model;
import Model.TestConsole;
import Model.TwoWaySerialComm;
import View.View;

public class Main {
	
	public static void main(String[] args) {
		Model m = Model.getInstance();
		TwoWaySerialComm Com = new TwoWaySerialComm();
		Com.connect();
		
		TestConsole a = new TestConsole();
		a.registerSend(Com);
		
		
		//a.sendCommand('c');
		
		View view = new View(m);
		
		Com.registerReceive(m);
		Com.registerReceive(view);
		
		view.registerSend(Com);
//		a.sendCommand('s');
//		try {
//			Thread.sleep(1000);
//		} catch (InterruptedException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//		a.sendCommand('n');
//		try {
//			Thread.sleep(1000);
//		} catch (InterruptedException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//		a.sendCommand('n');
//		try {
//			Thread.sleep(1000);
//		} catch (InterruptedException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//		a.sendCommand('n');
		
		
		
	//	@SuppressWarnings("unused")
	//	Controller c = new Controller(m,Com);
	//	Com.registerReceive(m);
	}
	
}
