package Model;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;

import Utils.Pair;
import View.ObserverSend;
import gnu.io.CommPort;
import gnu.io.CommPortIdentifier;
import gnu.io.SerialPort;
public class TwoWaySerialComm implements ObserverSend, SubjectReceive{
    private SerialWriter sw;
    private SerialReader sr;
    private static final int baudRate = 1200;//9600 / 4;
	private static int portIndex = -1;
    private static ArrayList<String> puertosLinux;
    private static ArrayList<String> puertosWin;
    private HashMap<String, ArrayList<String>> puertos;
    private static String OS;
    
    public TwoWaySerialComm() {  
        OS = System.getProperty("os.name").toLowerCase();
        OS = OS.substring(0, OS.indexOf(' ') > 0 ? OS.indexOf(' ') : OS.length());
        System.out.println("Sistema: " + OS);       
        puertos = new HashMap<String,ArrayList<String>>();    
        puertosLinux = new ArrayList<String>();
        puertosWin = new ArrayList<String>();
        for(int i = 10; i < 25; i++){
        	String iStr = Integer.toString(i);
        	puertosLinux.add("/dev/ttyUSB" + iStr);
            puertosLinux.add("/dev/ttyACM" + iStr);
        	puertosWin.add("COM" + iStr);
        }
        puertos.put("linux", puertosLinux);
        puertos.put("windows", puertosWin);
    }
    
    private String getNextPort(){
    	portIndex++;
    	try{
    		System.out.println("puerto entregado: " + puertos.get(OS).get(portIndex));
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
        			serialPort.setSerialPortParams(baudRate, SerialPort.DATABITS_8, SerialPort.STOPBITS_1, SerialPort.PARITY_NONE);          
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
			System.exit(1);
		} catch (Exception e) {
			e.printStackTrace();
		}
    }

    public void sendMessage(char command){
    	sw.sendMessage(command);
    }
    
    class SerialReader implements Runnable, SubjectReceive{
        InputStream in;
        private int indexDataReceived, subIndexDataReceived;
        private ArrayList<ObserverReceive> observers = new ArrayList<ObserverReceive>();
        private BufferedReader buffer;
        
        // contiene el nombre de los campos a recibir y la cantidad de bytes que espera
        private ArrayList<Pair<String,Integer>> dataToReceive;
        
        // contiene el nombre de los campos a recibir y el último dato recibido
        private ArrayList<Pair<String,Integer>> dataReceived;

        private ArrayList<Pair<String,Integer>> fillDataToRecieve(){
        	ArrayList<Pair<String,Integer>> ret = new ArrayList<Pair<String,Integer>>(40);
        	ret.add(new Pair<String,Integer>("FE_pcOut", 1));
        	ret.add(new Pair<String,Integer>("IF/ID_instructionOut", 4));
        	ret.add(new Pair<String,Integer>("IF/ID_pcNextOut", 1));
			ret.add(new Pair<String,Integer>("ID/EX_aluOperationOut", 1));
			ret.add(new Pair<String,Integer>("ID/EX_sigExtOut", 4));
			ret.add(new Pair<String,Integer>("ID/EX_readData1Out", 4));
			ret.add(new Pair<String,Integer>("ID/EX_readData2Out", 4));
			ret.add(new Pair<String,Integer>("ID/EX_aluSrcOut", 1));
			ret.add(new Pair<String,Integer>("ID/EX_aluShiftImmOut", 1));
			ret.add(new Pair<String,Integer>("ID/EX_memWriteOut", 1));
			ret.add(new Pair<String,Integer>("ID/EX_memToRegOut", 1));
			ret.add(new Pair<String,Integer>("ID/EX_memReadWidthOut", 1));
			ret.add(new Pair<String,Integer>("ID/EX_rsOut", 1));
			ret.add(new Pair<String,Integer>("ID/EX_rtOut", 1));
			ret.add(new Pair<String,Integer>("ID/EX_rdOut", 1));
			ret.add(new Pair<String,Integer>("ID/EX_saOut", 1));
			ret.add(new Pair<String,Integer>("ID/EX_regDstOut", 1));
			ret.add(new Pair<String,Integer>("ID/EX_loadImmOut", 1));
			ret.add(new Pair<String,Integer>("ID/EX_regWriteOut", 1));
//			ret.add(new Pair<String,Integer>("ID/EX_eopOut", 1)); //no está en la unidad de debug
			ret.add(new Pair<String,Integer>("EX/MEM_writeRegisterOut", 1));
			ret.add(new Pair<String,Integer>("EX/MEM_writeDataOut", 4));
			ret.add(new Pair<String,Integer>("EX/MEM_aluOutOut", 4));
			ret.add(new Pair<String,Integer>("EX/MEM_regWriteOut", 1));
//			ret.add(new Pair<String,Integer>("EX/MEM_memToRegOut", 1)); //no está en la unidad de debug
			ret.add(new Pair<String,Integer>("dataToUartOutFifo", 1));
			ret.add(new Pair<String,Integer>("EX/MEM_memWriteOut", 1));
			ret.add(new Pair<String,Integer>("EX/MEM_memReadWidthOut", 1));
//			ret.add(new Pair<String,Integer>("EX/MEM_eopOut", 1)); //no está en la unidad de debug
			ret.add(new Pair<String,Integer>("MEM/WB_writeRegisterOut", 1));
			ret.add(new Pair<String,Integer>("MEM/WB_aluOutOut", 4));
			ret.add(new Pair<String,Integer>("MEM/WB_memoryOutOut", 4));
			ret.add(new Pair<String,Integer>("MEM/WB_regWriteOut", 1));
			ret.add(new Pair<String,Integer>("MEM/WB_memToRegOut", 1));
//			ret.add(new Pair<String,Integer>("MEM/WB_eopOut", 1)); //no está en la unidad de debug
			ret.add(new Pair<String,Integer>("REG_1", 4));
			ret.add(new Pair<String,Integer>("REG_2", 4));
			ret.add(new Pair<String,Integer>("REG_3", 4));
			ret.add(new Pair<String,Integer>("REG_4", 4));
			ret.add(new Pair<String,Integer>("REG_5", 4));
			ret.add(new Pair<String,Integer>("MEM_1", 4));
			ret.add(new Pair<String,Integer>("MEM_2", 4));
			ret.add(new Pair<String,Integer>("MEM_3", 4));
			ret.add(new Pair<String,Integer>("MEM_4", 4));
			ret.add(new Pair<String,Integer>("MEM_5", 4));
			//ret.add(new Pair<String,Integer>("EndOfTransmission", 4));
        	return ret;
        }
        public SerialReader (InputStream in){
        	this.in = in;
        	indexDataReceived = 0;
        	subIndexDataReceived = 0;
    		dataToReceive = fillDataToRecieve();
    		dataReceived = new ArrayList<Pair<String,Integer>>(44);
    		buffer = new BufferedReader(new InputStreamReader(this.in));
    		try {
				buffer.mark(0);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
    		
    		for(Pair<String,Integer> p : dataToReceive){
    			dataReceived.add(new Pair<String,Integer>(p.getFst(), null));
    		}
        }
        
        public void readData(){
        	boolean timeout=false;
        	long startTime= System.currentTimeMillis();
        	boolean alreadyReseted = false;
        	
        	//BufferedReader buffer= new BufferedReader(new InputStreamReader(in));
        	try {
				while(!(in.available()>0)){
					Thread.sleep(200);
					
            		long currentTime= System.currentTimeMillis();
            		timeout= Math.abs(currentTime-startTime)>2000;
            		if(timeout && !alreadyReseted){
            			alreadyReseted = true;
            			System.out.println("--------------------------------");
        				indexDataReceived = 0;
        				subIndexDataReceived = 0;
        			}
				}
//				buffer.reset();
			} catch (IOException e2) {
				// TODO Auto-generated catch block
				e2.printStackTrace();
			} catch(InterruptedException e){
				e.printStackTrace();
			}
            try {
            	while (in.available()>0){
            		try {
						Thread.sleep(50);
					} catch (InterruptedException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
            		alreadyReseted = false;
            		int readValue = in.read();
            		System.out.println("Dato recibido: " + Integer.toHexString(readValue).toUpperCase()); 
        			if(indexDataReceived >= dataToReceive.size()){
        				System.out.println("--------------------------------");
        				indexDataReceived = 0;
        				subIndexDataReceived = 0;
        			}
        			Pair<String,Integer> dato = dataReceived.get(indexDataReceived);
        			if(subIndexDataReceived == 0){
        				dato.setSnd(readValue);
        				dataReceived.set(indexDataReceived, dato);
        				if(dataToReceive.get(indexDataReceived).getSnd() > 1){
        					//si entra acá es un dato de múltiples partes y leyó la primera
        					subIndexDataReceived++;
        				}else{
        					//si entra acá es un dato de una sola parte
        					indexDataReceived++;
        					notifyReceive(dato);
        				}
        			}else{
    					//si entra acá es porque es un dato de múltiples partes
    					dato.setSnd((dato.getSnd() << 8) | readValue ); //desplaza 8 bits el dato anterior y le pega el nuevo
        				dataReceived.set(indexDataReceived, dato);
        				subIndexDataReceived++;
        				if(subIndexDataReceived == dataToReceive.get(indexDataReceived).getSnd()){
            				//si entra acá ya completó el dato
            				subIndexDataReceived = 0;
            				indexDataReceived++;
            				notifyReceive(dato);
            			}
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
		public void notifyReceive(Pair<String,Integer> data) {
			for(ObserverReceive o : observers){
				o.updateReceive(data);
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
        int datoAEnviar = 0;
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
	public void notifyReceive(Pair<String,Integer> data) {
		sr.notifyReceive(data);
	}

	@Override
	public void updateSend(char command) {
		sw.updateSend(command);
	}
}

