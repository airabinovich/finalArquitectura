package Model;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;

import javax.swing.JTextField;

import Utils.Pair;
import View.ObserverSend;

public class Model implements ObserverSend, ObserverReceive{

	private ArrayList<Integer> generalPurposeRegisters;
	private ArrayList<Integer> memoryRegisters;
	private final String[] datapathRegisters = {"FE","IF/ID","ID/EX","EX/MEM","MEM/WB"};
	private final String[] FEFields = {"pcOut"};
	private final String[] IFIDFields = {"instructionOut", "pcNextOut"};
	private final String[] IDEXFields = {"aluOperationOut", "sigExtOut", "readData1Out", "readData2Out", "aluSrcOut", "aluShiftImmOut", "memWriteOut", "memToRegOut",
										 "memReadWidthOut", "rsOut", "rtOut", "rdOut", "saOut", "regDstOut", "loadImmOut", "regWriteOut", "eopOut"};
	private final String[] EXMEMFields = {"writeRegisterOut", "writeDataOut", "aluOutOut", "regWriteOut", "memToRegOut", "memWriteOut", "memReadWidthOut", "eopOut"};
	private final String[] MEMWBFields = {"writeRegisterOut", "aluOutOut", "memoryOutOut", "regWriteOut", "memToRegOut", "eopOut"};
	private HashMap<String,ArrayList<Pair<String,Integer>>> registerFields;
	private static Model model;
	
	private Model(){
		generalPurposeRegisters = new ArrayList<Integer>(5);
		memoryRegisters = new ArrayList<Integer>(5);
		registerFields = new HashMap<String,ArrayList<Pair<String,Integer>>>();
		
		ArrayList<Pair<String,Integer>> FEdata = new ArrayList<Pair<String,Integer>>();
        ArrayList<Pair<String,Integer>> IFIDdata = new ArrayList<Pair<String,Integer>>();
        ArrayList<Pair<String,Integer>> IDEXdata = new ArrayList<Pair<String,Integer>>();
        ArrayList<Pair<String,Integer>> EXMEMdata = new ArrayList<Pair<String,Integer>>();
        ArrayList<Pair<String,Integer>> MEMWBdata = new ArrayList<Pair<String,Integer>>();
        
        for( String s : FEFields){
        	FEdata.add(new Pair<String,Integer>(s,null));
        }
		for( String s : IFIDFields){
		    IFIDdata.add(new Pair<String,Integer>(s,null));
        }
		for( String s : IDEXFields){
			IDEXdata.add(new Pair<String,Integer>(s,null));
		}
		for( String s : EXMEMFields){
			EXMEMdata.add(new Pair<String,Integer>(s,null));
		}
		for( String s : MEMWBFields){
			MEMWBdata.add(new Pair<String,Integer>(s,null));
		}
		
        registerFields.put("FE", FEdata);
        registerFields.put("IF/ID",IFIDdata);
        registerFields.put("ID/EX",IDEXdata);
        registerFields.put("EX/MEM",EXMEMdata);
        registerFields.put("MEM/WB",MEMWBdata);
	}
	
	public static Model getInstance(){
		try{
			model.equals(model);
			return model;
		}catch(NullPointerException e){
			return new Model();
		}
	}
	
	@Override
	public void updateSend(char command) {

	}

	@Override
	public void updateReceive(Pair<String,Integer> data) {

	}

}
