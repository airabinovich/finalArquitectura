package View;
import java.awt.Color;
import java.awt.Container;
import java.awt.Font;
import java.awt.FontFormatException;
import java.awt.GraphicsEnvironment;
import java.awt.event.ActionListener;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JTextField;

import Model.Model;
import Model.ObserverReceive;
import Utils.Pair;


public class View implements SubjectSend, ObserverReceive {
	private ArrayList<ObserverSend> observers = new ArrayList<ObserverSend>();
	
//	private JLabel fromText,toText;
	private JFrame frame;
//	private URL uncImgURL= getClass().getResource("/resources/images/LAC.png");
	private Model model;
	private JButton continueModeButton, stepModeButton, nextStepButton;
	private HashMap<String,ArrayList<Pair<String,JTextField>>> pipelineRegistersData;
	
	private final int leftBorder = 70;
	private final int upBorder = 100;
	private JLabel UNC;
	private Font font;
	
	private final int 	windowWidth = 1280,
						windowHeight = 720;
	
	private final String[] datapathRegisters = {"FE","IF/ID","ID/EX","EX/MEM","MEM/WB"};
	
	public View(Model model){
		this.model=model;
		frame = new JFrame("MIPS Pipeline Debugger");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setSize(windowWidth,windowHeight);
        frame.setResizable(false);
        frame.setVisible(true);  
        
//        try {
//			font = Font.createFont(Font.TRUETYPE_FONT, getClass().getResource("/resources/fonts/OpenSans-Regular.ttf").openStream());
//	        GraphicsEnvironment genv = GraphicsEnvironment.getLocalGraphicsEnvironment();
//	        genv.registerFont(font);
//	        // make sure to derive the size
//	        font = font.deriveFont(16f);
//		} catch (FontFormatException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		} catch (IOException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
        
        ArrayList<Pair<String,JTextField>> FEdata = new ArrayList<Pair<String,JTextField>>();
        ArrayList<Pair<String,JTextField>> IFIDdata = new ArrayList<Pair<String,JTextField>>();
        ArrayList<Pair<String,JTextField>> IDEXdata = new ArrayList<Pair<String,JTextField>>();
        ArrayList<Pair<String,JTextField>> EXMEMdata = new ArrayList<Pair<String,JTextField>>();
        ArrayList<Pair<String,JTextField>> MEMWBdata = new ArrayList<Pair<String,JTextField>>();
        
        FEdata.add(new Pair<String,JTextField>("pcOut", new JTextField()));
        
        IFIDdata.add(new Pair<String,JTextField>("instructionOut", new JTextField()));
        IFIDdata.add(new Pair<String,JTextField>("pcNextOut", new JTextField()));
        
        IDEXdata.add(new Pair<String,JTextField>("aluOperationOut", new JTextField()));
        IDEXdata.add(new Pair<String,JTextField>("sigExtOut", new JTextField()));
        IDEXdata.add(new Pair<String,JTextField>("readData1Out", new JTextField()));
        IDEXdata.add(new Pair<String,JTextField>("readData2Out", new JTextField()));
        IDEXdata.add(new Pair<String,JTextField>("aluSrcOut", new JTextField()));
        IDEXdata.add(new Pair<String,JTextField>("aluShiftImmOut", new JTextField()));
        IDEXdata.add(new Pair<String,JTextField>("memWriteOut", new JTextField()));
        IDEXdata.add(new Pair<String,JTextField>("memToRegOut", new JTextField()));
        IDEXdata.add(new Pair<String,JTextField>("memReadWidthOut", new JTextField()));
        IDEXdata.add(new Pair<String,JTextField>("rsOut", new JTextField()));
        IDEXdata.add(new Pair<String,JTextField>("rtOut", new JTextField()));
        IDEXdata.add(new Pair<String,JTextField>("rdOut", new JTextField()));
        IDEXdata.add(new Pair<String,JTextField>("saOut", new JTextField()));
        IDEXdata.add(new Pair<String,JTextField>("regDstOut", new JTextField()));
        IDEXdata.add(new Pair<String,JTextField>("loadImmOut", new JTextField()));
        IDEXdata.add(new Pair<String,JTextField>("regWriteOut", new JTextField()));
        IDEXdata.add(new Pair<String,JTextField>("eopOut", new JTextField()));
        
        EXMEMdata.add(new Pair<String,JTextField>("writeRegisterOut", new JTextField()));
        EXMEMdata.add(new Pair<String,JTextField>("writeDataOut", new JTextField()));
        EXMEMdata.add(new Pair<String,JTextField>("aluOutOut", new JTextField()));
        EXMEMdata.add(new Pair<String,JTextField>("regWriteOut", new JTextField()));
        EXMEMdata.add(new Pair<String,JTextField>("memToRegOut", new JTextField()));
        EXMEMdata.add(new Pair<String,JTextField>("memWriteOut", new JTextField()));
        EXMEMdata.add(new Pair<String,JTextField>("memReadWidthOut", new JTextField()));
        EXMEMdata.add(new Pair<String,JTextField>("eopOut", new JTextField()));
        
        MEMWBdata.add(new Pair<String,JTextField>("writeRegisterOut", new JTextField()));
        MEMWBdata.add(new Pair<String,JTextField>("aluOutOut", new JTextField()));
        MEMWBdata.add(new Pair<String,JTextField>("memoryOutOut", new JTextField()));
        MEMWBdata.add(new Pair<String,JTextField>("regWriteOut", new JTextField()));
        MEMWBdata.add(new Pair<String,JTextField>("memToRegOut", new JTextField()));
        MEMWBdata.add(new Pair<String,JTextField>("eopOut", new JTextField()));
        
        pipelineRegistersData = new HashMap<String,ArrayList<Pair<String,JTextField>>>();
        pipelineRegistersData.put("FE", FEdata);
        pipelineRegistersData.put("IF/ID",IFIDdata);
        pipelineRegistersData.put("ID/EX",IDEXdata);
        pipelineRegistersData.put("EX/MEM",EXMEMdata);
        pipelineRegistersData.put("MEM/WB",MEMWBdata);

        initView();
        
//        frame.repaint();
	}
	
	private void initView(){		
        
		int x = 20, y = 20;
		Container contentPane = frame.getContentPane();
		contentPane.setBackground(new Color(133,191,250));
		
        UNC =  new JLabel();
//        UNC.setIcon(new ImageIcon(uncImgURL));
        UNC.setLocation(70,400);
        UNC.setSize(300,200);
        
        for(String reg : datapathRegisters){
        	for(Pair<String,JTextField> p : pipelineRegistersData.get(reg)){
        		y += windowHeight/30;
        		JLabel l = new JLabel(p.getFst());
        		JTextField tf = p.getSnd();
        		l.setBounds(x, y, 100, 20);
        		tf.setBounds(x+l.getWidth()+10, y, 100, 20);
        		tf.setEditable(false);
        		l.setVisible(true);
        		tf.setVisible(true);
        		contentPane.add(l);
        		contentPane.add(tf);
        	}
        	y = 20;
        	x += windowWidth/5;
        }
        
        contentPane.add(UNC);

        frame.repaint();
	}

	public void addStepModeCommandButtonListener(ActionListener sendCommandButtonListener) {
		stepModeButton.addActionListener(sendCommandButtonListener);
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
		frame.repaint();
	}

}
