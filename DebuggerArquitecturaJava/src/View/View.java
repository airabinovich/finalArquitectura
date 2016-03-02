package View;
import java.awt.Color;
import java.awt.Container;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;
import java.util.HashMap;

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
	
	private JFrame frame;
	private Model model;
	private JButton continueModeButton, stepModeButton, nextStepButton, resetButton;
	private HashMap<String,ArrayList<Pair<String,JTextField>>> pipelineRegistersData;
	private ArrayList<Pair<Integer,JTextField>> generalPurposeRegisters;
	private ArrayList<Pair<Integer,JTextField>> memoryRegisters;
	
	private char command;
	
	private final int 	windowWidth = 1280,
						windowHeight = 720;
	
	private final String[] datapathRegisters = {"FE","IF/ID","ID/EX","EX/MEM","MEM/WB"};
	private final String[] FEFields = {"pcOut"};
	private final String[] IFIDFields = {"instructionOut", "pcNextOut"};
	private final String[] IDEXFields = {"aluOperationOut", "sigExtOut", "readData1Out", "readData2Out", "aluSrcOut", "aluShiftImmOut", "memWriteOut", "memToRegOut",
										 "memReadWidthOut", "rsOut", "rtOut", "rdOut", "saOut", "regDstOut", "loadImmOut", "regWriteOut", "eopOut"};
	private final String[] EXMEMFields = {"writeRegisterOut", "writeDataOut", "aluOutOut", "regWriteOut", "memToRegOut", "memWriteOut", "memReadWidthOut", "eopOut"};
	private final String[] MEMWBFields = {"writeRegisterOut", "aluOutOut", "memoryOutOut", "regWriteOut", "memToRegOut", "eopOut"};
	
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
        
        for( String s : FEFields){
        	FEdata.add(new Pair<String,JTextField>(s,new JTextField()));
        }
		for( String s : IFIDFields){
		    IFIDdata.add(new Pair<String,JTextField>(s,new JTextField()));
        }
		for( String s : IDEXFields){
			IDEXdata.add(new Pair<String,JTextField>(s,new JTextField()));
		}
		for( String s : EXMEMFields){
			EXMEMdata.add(new Pair<String,JTextField>(s,new JTextField()));
		}
		for( String s : MEMWBFields){
			MEMWBdata.add(new Pair<String,JTextField>(s,new JTextField()));
		}
        
        pipelineRegistersData = new HashMap<String,ArrayList<Pair<String,JTextField>>>();
        pipelineRegistersData.put("FE", FEdata);
        pipelineRegistersData.put("IF/ID",IFIDdata);
        pipelineRegistersData.put("ID/EX",IDEXdata);
        pipelineRegistersData.put("EX/MEM",EXMEMdata);
        pipelineRegistersData.put("MEM/WB",MEMWBdata);

        continueModeButton = new JButton("Continue");
        stepModeButton = new JButton("Step");
        nextStepButton = new JButton("Next");
        resetButton = new JButton("Reset");

        generalPurposeRegisters = new ArrayList<Pair<Integer,JTextField>>();
        memoryRegisters = new ArrayList<Pair<Integer,JTextField>>();
        
        for(int i = 0; i < 5; i++){
        	generalPurposeRegisters.add(new Pair<Integer,JTextField>(i,new JTextField()));
        	memoryRegisters.add(new Pair<Integer,JTextField>(i,new JTextField()));
        }
        
        initView();
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
        continueModeButton.setBounds(xBase, yBase + windowHeight / 2, 80, 20);
        continueModeButton.addActionListener(new ActionListener(){
			@Override
			public void actionPerformed(ActionEvent arg0) {
				continueModeButton.setEnabled(false);
				stepModeButton.setEnabled(false);
				nextStepButton.setEnabled(false);
				command = 'c';
				notifySend();
			}
        });
        
        stepModeButton.setVisible(true);
        stepModeButton.setEnabled(true);
        stepModeButton.setBounds(xBase + 120, yBase + windowHeight / 2, 80, 20);
        stepModeButton.addActionListener(new ActionListener(){
			@Override
			public void actionPerformed(ActionEvent e) {
				continueModeButton.setEnabled(false);
				stepModeButton.setEnabled(false);
				nextStepButton.setEnabled(true);
				command = 's';
				notifySend();
			}
        	
        });
        
        nextStepButton.setVisible(true);
        nextStepButton.setEnabled(false);
        nextStepButton.setBounds(xBase + 240, yBase + windowHeight / 2, 80, 20);
        nextStepButton.addActionListener(new ActionListener(){
			@Override
			public void actionPerformed(ActionEvent e) {
				command = 'n';
				notifySend();
			}
        });
        
        resetButton.setVisible(true);
        resetButton.setEnabled(true);
        resetButton.setBounds(xBase + 360, yBase + windowHeight / 2, 80, 20);
        resetButton.addActionListener(new ActionListener(){
			@Override
			public void actionPerformed(ActionEvent e) {
				continueModeButton.setEnabled(true);
				stepModeButton.setEnabled(true);
				nextStepButton.setEnabled(false);
				
				for(String reg : datapathRegisters){
		        	for(Pair<String,JTextField> p : pipelineRegistersData.get(reg)){
		        		p.getSnd().setText("");
		        	}
		        }
				
				for(Pair<Integer,JTextField> p : generalPurposeRegisters){
					p.getSnd().setText("");
				}
				
				for(Pair<Integer,JTextField> p : memoryRegisters){
					p.getSnd().setText("");
				}
				
				frame.repaint();
			}
        });
        
        contentPane.add(nextStepButton);
        contentPane.add(stepModeButton);
        contentPane.add(continueModeButton);
        contentPane.add(resetButton);
        contentPane.add(fondo);

        frame.repaint();
	}

	public void addStepModeCommandButtonListener(ActionListener sendCommandButtonListener) {
		stepModeButton.addActionListener(sendCommandButtonListener);
	}

	public void onSendButtonPressed() {
		notifySend();
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
			o.updateSend(command);
		}
		
	}

	@Override
	public void updateReceive(Pair<String,Integer> data) {
		try{
			if(!updateProcessorRegisters(data)){
				if(!updateGeneralPurposeRegisters(data)){
					updateMemoryRegisters(data);
				}
			}
			frame.repaint();
  		}catch(NullPointerException e){
			System.out.println("LLegó un argumento null a updateReceive");
			e.printStackTrace();
		}
	}
	
	private boolean updateProcessorRegisters(Pair<String,Integer> data){
		try{
			int divider = data.getFst().indexOf("_");
			if(divider >= data.getFst().length()){
				System.out.println("_  no se encuenta en " + data.getFst());
				return false;
			}
			String stage = data.getFst().substring(0, divider);
			String field = data.getFst().substring(divider + 1);
			int index = -1;
			ArrayList<Pair<String,JTextField>> lista = pipelineRegistersData.get(stage);
			for(int i = 0; i < lista.size(); i++){
				if(lista.get(i).getFst().equals(field)){
					index = i;
					break;
				}
			}
			if(index < 0){
				System.out.println( field + " no pertenece a la etapa " + stage);
				return false;
			}
			if(data.getFst().contains("instructionOut")){
				pipelineRegistersData.get(stage).get(index).getSnd().setText("0x"+Integer.toHexString(data.getSnd()).toUpperCase());
			}else{
				// setea el valor recibido en el JTextField que corresponde al nombre del campo, dentro del registro que corresponde
				pipelineRegistersData.get(stage).get(index).getSnd().setText(Integer.toUnsignedString(data.getSnd()));
			}
		}catch(IndexOutOfBoundsException e){
			return false;
		}catch(NullPointerException e){
			return false;
		}
		return true;
	}
	
	private boolean updateGeneralPurposeRegisters(Pair<String,Integer> data){
		try{
			if(!data.getFst().startsWith("REG")){
				return false;
			}
			int divider = data.getFst().indexOf("_") + 1;
			int index = Integer.parseInt(data.getFst().substring(divider)) - 1;
			generalPurposeRegisters.get(index).getSnd().setText(data.getSnd().toString());
			return true;
		}catch(NumberFormatException e){
			return false;
		}
	}
	
	private boolean updateMemoryRegisters(Pair<String,Integer> data){
		try{
			if(!data.getFst().startsWith("MEM")){
				return false;
			}
			int divider = data.getFst().indexOf("_") + 1;
			int index = Integer.parseInt(data.getFst().substring(divider)) - 1;
			memoryRegisters.get(index).getSnd().setText(data.getSnd().toString());
			return true;
		}catch(NumberFormatException e){
			return false;
		}
	}

}
