package Main;

import Model.Model;
import Model.TestConsole;
import Model.TwoWaySerialComm;
import View.View;

public class Main {
	
	public static void main(String[] args) {
		Model m = new Model();
		TwoWaySerialComm Com = new TwoWaySerialComm();
		Com.connect();
		
		TestConsole a = new TestConsole();
		a.registerSend(Com);
		
		
		a.sendCommand('c');
		
		View view = new View(m);
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
