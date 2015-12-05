package Model;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;

import View.ObserverSend;
import gnu.io.CommPort;
import gnu.io.CommPortIdentifier;
import gnu.io.SerialPort;
public class TwoWaySerialComm implements ObserverSend, SubjectReceive{
    private SerialWriter sw;
    private SerialReader sr;
	private static int portIndex = -1;
    private static ArrayList<String> puertosLinux;
    private static ArrayList<String> puertosWin;
    private HashMap<String, ArrayList<String>> puertos;
    private static String OS;
    
    public TwoWaySerialComm() {  
        OS = System.getProperty("os.name").toLowerCase();
        OS = OS.substring(0, OS.indexOf(' ') > 0 ? OS.indexOf(' ') : OS.length());
        System.out.println("Sistema:"+OS);       
        puertos = new HashMap<String,ArrayList<String>>();    
        puertosLinux = new ArrayList<String>();
        puertosLinux.add("/dev/ttyUSB0");
        puertosLinux.add("/dev/ttyACM0");
        puertos.put("linux", puertosLinux); 
        puertosWin = new ArrayList<String>();
        for(int i = 0; i < 25; i++){
        	puertosWin.add("COM"+Integer.toString(i));
        }        
        puertos.put("windows", puertosWin);
    }
    
    private String getNextPort(){
    	portIndex++;
    	try{
    		System.out.println("puerto entregado: "+puertos.get(OS).get(portIndex));
    		return puertos.get(OS).get(portIndex);
    	}catch(IndexOutOfBoundsException ex){
    		return null;
    	}
	}
    
    private CommPortIdentifier tryConnection(String port) throws Exception{
    	CommPortIdentifier portIdentifier;
    	try{
    		portIdentifier = CommPortIdentifier.getPortIdentifier(port);
        	try{
        		CommPort commPort = portIdentifier.open(this.getClass().getName(),2000);
        		if ( commPort instanceof SerialPort ){
        			SerialPort serialPort = (SerialPort) commPort;
        			serialPort.setSerialPortParams(9600,SerialPort.DATABITS_8,SerialPort.STOPBITS_1,SerialPort.PARITY_NONE);          
        			InputStream in = serialPort.getInputStream();
        			OutputStream out = serialPort.getOutputStream();
        			sr = new SerialReader(in);
        			(new Thread(sr)).start();
        			 sw = new SerialWriter(out);
        		}
        	}catch(gnu.io.PortInUseException e){
        		System.out.println("Puerto Ocupado!!");
        		return null;
        	}
    	}catch(gnu.io.NoSuchPortException e){
    		System.out.println("Puerto no conectado!!");
    		return null;
    	}
    	return portIdentifier;
   }
    

	public void connect(){
    	String nextPort;
    	CommPortIdentifier portIdentifier = null;
		try {
			while(portIdentifier == null){
				nextPort = getNextPort();
				nextPort.equals(nextPort);
				portIdentifier = tryConnection(nextPort);
			}
		} catch (NullPointerException e){
			System.out.println("Nos quedamos sin puertos");
		} catch (Exception e) {
			e.printStackTrace();
		}
    }

    public void sendMessage(char command){
    	sw.sendMessage(command);
    }
    
    class SerialReader implements Runnable, SubjectReceive{
        InputStream in;       
        private ArrayList<ObserverReceive> observers = new ArrayList<ObserverReceive>(); 
        public SerialReader (InputStream in){
        	this.in = in;
        }
        
        public void readData(){

        	BufferedReader buffer= new BufferedReader(new InputStreamReader(in));
            try {
            	while (buffer.ready()){
            		//String aux = buffer.readLine();
            		int aux =buffer.read();
            		if(aux<=122 && aux>=65){
            			char auxc=(char)aux;
            			System.out.println(auxc);
            		}else{
            			System.out.println(aux);
            		}
            		try{
                		//notifyReceive(aux);
            		} catch(NumberFormatException e){
            			e.printStackTrace();
            		}
            	}
            }catch (IOException e){}            
        }
		public void run() {
			while(true){
				readData();
			}
		}

		@Override
		public void registerReceive(ObserverReceive o) {
			observers.add(o);
			
		}

		@Override
		public void unregisterReceive(ObserverReceive o) {
			observers.remove(o);
			
		}

		@Override
		public void notifyReceive(String rcv) {
			for(ObserverReceive o : observers){
				o.updateReceive(rcv);
			}
			
		}
 	}
    
    public SerialWriter getSerialWriter() {
		return sw;
	}
    public SerialReader getSerialReader() {
		return sr;
	}

    
    class SerialWriter implements ObserverSend{
        OutputStream out;
        //double auxiliar;
        int anguloAEnviar=0;
        public SerialWriter (OutputStream out){
            this.out = out;
        }
        
        private void sendData(char data){
        	try {
				this.out.write((byte)(data));
			} catch (IOException e) {
				e.printStackTrace();
			}        			   			  	
        }
        
        public void sendMessage(char command){
        		sendData(command);
        }

		@Override
		public void updateSend(char command) {
			sendMessage(command);		
		}
    }

	@Override
	public void registerReceive(ObserverReceive o) {
		sr.registerReceive(o);
		
	}

	@Override
	public void unregisterReceive(ObserverReceive o) {
		sr.unregisterReceive(o);
		
	}

	@Override
	public void notifyReceive(String rcv) {
		sr.notifyReceive(rcv);
		
	}

	@Override
	public void updateSend(char command) {
		sw.updateSend(command);
	}
}

