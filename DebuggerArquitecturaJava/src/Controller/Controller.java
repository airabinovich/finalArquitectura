package Controller;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import Model.Model;
import Model.TwoWaySerialComm;
import View.View;

public class Controller {
	private View view;
	
	public Controller(Model model, TwoWaySerialComm com){		
		this.view = new View(model);
		new SendCommandButtonListener();
		view.registerSend(model);
		view.registerSend(com);
		com.registerReceive(view);
	}
	class SendCommandButtonListener implements ActionListener{
		
		public SendCommandButtonListener(){
			view.addStepModeCommandButtonListener(this);
		}
		@Override
		public void actionPerformed(ActionEvent e) {
			try{
				view.onSendButtonPressed();
			}catch(NumberFormatException ex){
				ex.printStackTrace();
			}
			
		}
		
	}

}
