package View;
import java.awt.Color;
import java.awt.Container;
import java.awt.Font;
import java.awt.FontFormatException;
import java.awt.GraphicsEnvironment;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.IOException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;

import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;

import Model.Model;
import Model.ObserverReceive;
import Utils.Pair;


public class View implements SubjectSend, ObserverReceive {
	private ArrayList<ObserverSend> observers = new ArrayList<ObserverSend>();
	
//	private JLabel fromText,toText;
	private JFrame frame;
	private Model model;
	private JButton continueModeButton, stepModeButton, nextStepButton;
	private HashMap<String,ArrayList<Pair<String,JTextField>>> pipelineRegistersData;
	private ArrayList<Pair<Integer,JTextField>> generalPurposeRegisters;
	private ArrayList<Pair<Integer,JTextField>> memoryRegisters;
	
	private final int 	windowWidth = 1280,
						windowHeight = 720;
	
	private final String[] datapathRegisters = {"FE","IF/ID","ID/EX","EX/MEM","MEM/WB"};
	
	public View(Model model){
		this.model=model;
		frame = new JFrame("MIPS Pipeline Debugger");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setSize(windowWidth,windowHeight);
        frame.setResizable(true);
        frame.setVisible(true);  
        
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

        continueModeButton = new JButton("Continue");
        stepModeButton = new JButton("Step");
        nextStepButton = new JButton("Next");

        generalPurposeRegisters = new ArrayList<Pair<Integer,JTextField>>();
        memoryRegisters = new ArrayList<Pair<Integer,JTextField>>();
        
        for(int i = 1; i <= 5; i++){
        	generalPurposeRegisters.add(new Pair<Integer,JTextField>(i,new JTextField()));
        	memoryRegisters.add(new Pair<Integer,JTextField>(i,new JTextField()));
        }
        
        initView();
        
//        frame.repaint();
	}
	
	private void initView(){		
        
		JPanel fondo = new JPanel();
		fondo.setBackground(new Color(133,191,250));
		int xBase = 20, yBase = 20;
		int x = xBase, y = yBase;
		Container contentPane = frame.getContentPane();
		contentPane.setBackground(new Color(133,191,250));
		
        
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
        
        x = xBase;
        y = yBase + windowHeight / 4;
        
        for(Pair<Integer,JTextField> p : generalPurposeRegisters){
        	y += windowHeight / 30;
        	JLabel l = new JLabel("Reg " + p.getFst().toString());
        	JTextField tf = p.getSnd();
        	l.setBounds(x, y, 100, 20);
        	tf.setBounds(x + l.getWidth() + 10, y, 100, 20);
        	tf.setEditable(false);
        	l.setVisible(true);
        	tf.setVisible(true);
        	contentPane.add(l);
        	contentPane.add(tf);
        }
        
        x += windowWidth / 5;
        y = yBase + windowHeight / 4;
        
        for(Pair<Integer,JTextField> p : memoryRegisters){
        	y += windowHeight / 30;
        	JLabel l = new JLabel("Mem " + p.getFst().toString());
        	JTextField tf = p.getSnd();
        	l.setBounds(x, y, 100, 20);
        	tf.setBounds(x + l.getWidth() + 10, y, 100, 20);
        	tf.setEditable(false);
        	l.setVisible(true);
        	tf.setVisible(true);
        	contentPane.add(l);
        	contentPane.add(tf);
        }
        
        continueModeButton.setVisible(true);
        continueModeButton.setEnabled(true);
        continueModeButton.setBounds(xBase, yBase + windowHeight / 2, 100, 20);
        continueModeButton.addActionListener(new ActionListener(){
			@Override
			public void actionPerformed(ActionEvent arg0) {
				continueModeButton.setEnabled(false);
				stepModeButton.setEnabled(false);
				nextStepButton.setEnabled(false);
			}
        });
        
        stepModeButton.setVisible(true);
        stepModeButton.setEnabled(true);
        stepModeButton.setBounds(xBase + 150, yBase + windowHeight / 2, 100, 20);
        stepModeButton.addActionListener(new ActionListener(){
			@Override
			public void actionPerformed(ActionEvent e) {
				continueModeButton.setEnabled(false);
				stepModeButton.setEnabled(false);
				nextStepButton.setEnabled(true);
			}
        	
        });
        
        nextStepButton.setVisible(true);
        nextStepButton.setEnabled(false);
        nextStepButton.setBounds(xBase + 300, yBase + windowHeight / 2, 100, 20);
        nextStepButton.addActionListener(new ActionListener(){
			@Override
			public void actionPerformed(ActionEvent e) {
				System.out.println(e.toString());
			}
        });
        
        contentPane.add(nextStepButton);
        contentPane.add(stepModeButton);
        contentPane.add(continueModeButton);
        contentPane.add(fondo);

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
