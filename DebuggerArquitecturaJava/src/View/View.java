package View;
import java.awt.Color;
import java.awt.Font;
import java.awt.FontFormatException;
import java.awt.GraphicsEnvironment;
import java.awt.event.ActionListener;
import java.io.IOException;
import java.net.URL;
import java.util.ArrayList;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JFrame;
import javax.swing.JLabel;
import Model.Model;
import Model.ObserverReceive;


public class View implements SubjectSend, ObserverReceive {
	private ArrayList<ObserverSend> observers = new ArrayList<ObserverSend>();
	
	private JComboBox<Integer> fromBox, toBox;
	private JLabel fromText,toText;
	private JFrame frame;
	private URL uncImgURL= getClass().getResource("/resources/images/LAC.png");
	private Model model;
	private JButton sendButton;
	
	private final int leftBorder = 70;
	private final int upBorder = 100;
	RobotArmComponent brazoImg;
	JLabel UNC;
	Font font;
	public View(Model model){
		this.model=model;
		frame = new JFrame("Robot Arm Piece Picker");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setSize(1280,720);
        frame.setResizable(false);
        frame.setVisible(true);  
        
        try {
			font = Font.createFont(Font.TRUETYPE_FONT, getClass().getResource("/resources/fonts/OpenSans-Regular.ttf").openStream());
	        GraphicsEnvironment genv = GraphicsEnvironment.getLocalGraphicsEnvironment();
	        genv.registerFont(font);
	        // makesure to derive the size
	        font = font.deriveFont(16f);
		} catch (FontFormatException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}   

        initView();
        
        frame.repaint();
	}
	
	private void initView(){		
        

		frame.getContentPane().setBackground(new Color(156,206,180));
		fromText= new JLabel("From point:");
		toText= new JLabel("To point:");
		fromBox = new JComboBox<Integer>();
		toBox = new JComboBox<Integer>();
		fromBox.setBackground(new Color(255,238,173));
		toBox.setBackground(new Color(255,238,173));
		fromText.setLocation(leftBorder, upBorder);
		fromText.setSize(100, 20);
		fromText.setFont(font);
		fromText.setForeground(new Color(255,238,173));
		fromBox.setLocation(leftBorder+100, upBorder);
		fromBox.setSize(50, 20);
		toText.setLocation(leftBorder, upBorder+50);
		toText.setSize(100, 20);
		toText.setFont(font);
		toText.setForeground(new Color(255,238,173));
		toBox.setLocation(leftBorder+100, upBorder+50);
		toBox.setSize(50, 20);
		sendButton= new JButton("Send Command");
		sendButton.setSize(150,20);
		sendButton.setLocation(leftBorder,upBorder+100);
		sendButton.setBackground(new Color(255,111,105));
		
		sendButton.setFont(font.deriveFont(0, 14f));
		for (int i=1; i<5; i++){
			fromBox.addItem(i);
			toBox.addItem(i);
		}
		
        UNC =  new JLabel();
        UNC.setIcon(new ImageIcon(uncImgURL));
        UNC.setLocation(70,400);
        UNC.setSize(300,200);
        brazoImg = new RobotArmComponent();
        brazoImg.setSize(frame.getSize());
        frame.getContentPane().add(UNC);
        frame.getContentPane().add(fromText);
        frame.getContentPane().add(toText);
        frame.getContentPane().add(fromBox);
        frame.getContentPane().add(toBox);    
        frame.getContentPane().add(sendButton);   
		frame.getContentPane().add(brazoImg);	
		
        frame.repaint();
	}

	public void addSendCommandButtonListener(ActionListener sendCommandButtonListener) {
		sendButton.addActionListener(sendCommandButtonListener);
	}

	public void onSendButtonPressed() {
		if (!model.isBusy()){
			notifySend();
		}
	}

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
			//o.updateSend((Integer)fromBox.getSelectedItem(),(Integer)toBox.getSelectedItem());
		}
		
	}

	@Override
	public void updateReceive(String rcv) {
		if (rcv.toLowerCase().contains("closepliers")){
			brazoImg.closePliers();
		} 
		else if (rcv.toLowerCase().contains("openpliers")){
			brazoImg.openPliers();
		} 
		else {
			try{
				int ang= Integer.parseInt(rcv);
				double radAng= -(ang-90) * (3.1415/180);
				brazoImg.rotate(radAng);
			}
			catch(NumberFormatException e){
	
			}
		}		
		frame.repaint();
	}

}
