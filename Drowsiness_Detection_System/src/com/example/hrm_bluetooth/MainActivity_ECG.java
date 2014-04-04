package com.example.hrm_bluetooth;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import android.app.Activity;
import android.app.AlertDialog;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.util.Log;
import android.view.Display;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.FrameLayout;

import com.example.FFT_transform.TodoDAO;
import com.example.FFT_transform.decimate_logic;
import com.example.FFT_transform.fft_practice;
import com.example.hrm2_driver.hrm2_driver;


public class MainActivity_ECG extends Activity {
	
	protected static final int MENU_SELECT_DEVICE = Menu.FIRST;
	protected static final int MENU_QUIT = Menu.FIRST+1;
	
	public static final String TAG = "ECG View";
	public BluetoothAdapter mBluetoothAdapter = null;
	public BluetoothDevice device=null;
	public DataInputStream dataInStream;
	public DataOutputStream dataOutStream;
	public BluetoothSocket btSocket = null;
	public String strSelDeviceName;
	
	public boolean BT_Thread_Flag=false;

	//public boolean flag = false;
	public boolean waitflag=false;
	public ArrayList<Integer> hrList = new ArrayList<Integer>();
	public int[] heart_rate_array = new int[10];
	private static final UUID MY_UUID =UUID.fromString("00001101-0000-1000-8000-00805F9B34FB");
	public BT_Controller BTc = null;
	
	public FrameLayout ty=null;
	public myView mv = null;
	public Handler hr = new Handler();
	Rect View_rect;
	public hrm2_driver Hrm2Driver = null;
	public fft_practice test = new fft_practice();
	public decimate_logic deci = new decimate_logic();
	public TodoDAO dao;
		
	public Runnable timer=new Runnable()
	{
	    public void run() 
	    {
	    	mv.invalidate();
	    	hr.postDelayed(this, 100);
	    }
	};
	
	
	@Override
	public void onPause(){
		super.onPause();
		BTDevice_Stop();
		this.finish();
	}
	@Override
	public void onResume(){
		Log.e(TAG, "on Resume");
		super.onResume();
		if(BTc != null)
		{
			if(!BTc.isAlive()){
				BTc = new BT_Controller();
				BTc.start();
			}
		}
	}
	
		
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main_ecg);
 	    setTitle("EcgView : Select a device from Menu");
 	   dao = new TodoDAO(this);
 	    
        try
        {
        	Class.forName("com.example.hrm2_driver.hrm2_driver");
        	Hrm2Driver  = new hrm2_driver();
        }catch(ClassNotFoundException e)    {
			Log.e(TAG, String.format("ClassNotFoundException %x !",  e.getMessage()));
        }
      
        ty = (FrameLayout)findViewById(R.id.frameLayout1);
        mv = new myView(this);
        try{
        	ty.addView(mv,0);
        }catch(Exception ex){
        	Log.e(TAG, "add view caused error !! ");
        }
        
        getBTAdapter();
    }
    
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		super.onCreateOptionsMenu(menu);
	    menu.add(0, MENU_SELECT_DEVICE, 0, "Select Device");
	    menu.add(0, MENU_QUIT, 0, "Quit");
	    return true;
	}
	
	@Override
	public boolean onOptionsItemSelected(MenuItem item)
	{
	    super.onOptionsItemSelected(item);
	    switch(item.getItemId()){
	         case MENU_SELECT_DEVICE:
	        	 setTitle("EcgView :Select Device");
	        	 BTDevice_Start();
	             break;
	        case MENU_QUIT:
	        	 setTitle("EcgView : Quit");
	        	 BTDevice_Stop();
	             finish();
	            break;
	      }
	      return true;
	}	

	
    Handler handler = new Handler() 
    {
        public void handleMessage(Message msg) 
        
        {
        	int n= hrList.size();
        	for(int i=0 ;i<10;i++)
        	{
        		hrList.add(heart_rate_array[i]);
        		//Log.i ("hrList Values", hrList.toString ());
        		       		      	
        		
	        	//Log.i ("hrList size", new Integer(n).toString());
            	Display display = getWindowManager().getDefaultDisplay();
				int width = display.getWidth()-10;
				int height = display.getHeight()-80;
	        	if(hrList.size()>width)				//move sample data into list
	        		hrList.remove(0);
	        	
	        	if(n==310){
	        		
	        		deci.decimate_test(hrList);
	        	     		    		
	        	}
	        	
        		
//	        	if (((hrList.size() - 1) & hrList.size()) == 0)
//        			test.fft_test(hrList);
        	}
        	
        	
        	waitflag=false;
        	super.handleMessage(msg);
        }
    };
    
   
    public class myView extends View{
    	private Paint paint= new Paint();
    	
        myView(Context ctx) 
        {  
        	super(ctx);  
        }
        
	    @Override 
	    protected void onDraw(Canvas canvas) {
	    	int marginTop = 10;
	    	int marginLeft = 10;
	    	int marginRight = 10;
	    	int marginBottom = 100;
	    	View_rect = canvas.getClipBounds();
	    	
			try{
		    	paint.setColor(Color.BLACK);
				paint.setStrokeWidth(3);
				canvas.drawRect(0,0,View_rect.width(),View_rect.height(),  paint);
				
				int x=marginLeft ,y=marginTop, Offset;
				int width = View_rect.width()-(marginLeft+marginRight);
				int height = View_rect.height()-(marginTop+marginBottom);
				
				paint.setColor(Color.BLUE);
				paint.setStrokeWidth(3);
				//draw the frame
				canvas.drawLine(x,		y,			x,		y+height,	paint);
				canvas.drawLine(x,		y+height,	x+width,y+height,	paint);
				canvas.drawLine(x+width,y+height,	x+width,y,			paint);
				canvas.drawLine(x+width,y,			x,		y,			paint);
				
				//draw x 
				x=marginLeft; 	y=marginTop+height;
				for(int i=0; i<10; i++)
				{
					Offset = (width/10)*i;
					canvas.drawLine(x+Offset,y,	x+Offset,y-10,paint);
				}

				//draw y
				x=marginLeft;	y=marginTop;
				for(int i=0; i<10; i++)
				{
					Offset = (height/10)*i;
					canvas.drawLine(x,y+Offset,	x+10,y+Offset,paint);
				}
				
				//draw ECG
				paint.setColor(Color.GREEN);
				paint.setStrokeWidth(1);
				Offset = 15; 
				x=marginLeft;	y=marginTop;
				for(int i=Offset ; i<hrList.size()-Offset; i++)
				{
					int x1,y1, x2, y2;
					x1 = i;
					y1 = (Integer) (height * (1000-hrList.get(i-Offset))/1000);
					x2 = i+1;
					y2 = (Integer) (height * (1000-hrList.get(i-Offset+1))/1000);
					
					y1 =  y+y1;
					y2 =  y+y2;
					if(y1<y) y1=y;
					if(y2<y) y2=y;
		    		canvas.drawLine(x+x1, y1, x+x2, y2, paint);
				}
				
				paint.setColor(Color.WHITE);
				paint.setTextSize(28);
				canvas.drawText("time", x+width-70, y+height+30, paint);
				
				
			}catch(Exception ex){
				Log.e(TAG,ex.getMessage());
			}
		}
    }

	private void getBTAdapter()
	{
		// Checking bluetooth Adapter exists
		mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
		if (mBluetoothAdapter == null) {
			// Device does not support Bluetooth
			AlertDialog.Builder builder = new AlertDialog.Builder(this);
			builder.setMessage("Device does not support Bluetooth!")
			       .setTitle("Exit")
				   .setPositiveButton("OK", new DialogInterface.OnClickListener() {
		           public void onClick(DialogInterface dialog, int id) {
		        	   //do nothing
		           }
		       });
				   
			AlertDialog dialog = builder.create();
			dialog.show();
			return;
		}

		// check bluetooth enabled
		if (!mBluetoothAdapter.isEnabled()) {
			// Device does not support Bluetooth
			AlertDialog.Builder builder = new AlertDialog.Builder(this);
			builder.setMessage("Bluetooth is not enabled!")
			       .setTitle("Exit")
				   .setPositiveButton("OK", new DialogInterface.OnClickListener() {
		           public void onClick(DialogInterface dialog, int id) {
		        	   //do nothing
		           }
		       });
				   
			AlertDialog dialog = builder.create();
			dialog.show();
			return;
		}
	}

    
    private void BTDevice_Select()
    {
    	final List<String> listItems = new ArrayList<String>();
		Set<BluetoothDevice> pairedDevices = mBluetoothAdapter.getBondedDevices();
		// If there are paired devices
		if (pairedDevices.size() > 0) {
		    // Loop through paired devices
		    for (BluetoothDevice list_device : pairedDevices) {
		        // Add the name and address to an array adapter to show in a ListView
		    	if(Hrm2Driver.CheckName(list_device.getName())==1){
		    		listItems.add(list_device.getName());
		    	}
		    }
		}

		final CharSequence[] DeviceNames = listItems.toArray(new CharSequence[listItems.size()]);
		AlertDialog.Builder builder = new AlertDialog.Builder(this);
		builder.setTitle("Paired Device");
		builder.setItems(DeviceNames, new DialogInterface.OnClickListener() {

			public void onClick(DialogInterface dialog, int item) {

				if(Hrm2Driver.SetCheckKey(listItems.get(item)) == 0)
				{
					Log.e(TAG, String.format("%x check key error!", listItems.get(item)));
					return;
				}

	    		try {
					if(dataInStream!=null)
						dataInStream.close();
					if(dataOutStream!=null)
						dataOutStream.close();
					if(btSocket!=null)
						btSocket.close();
		    		btSocket=null;
		    		device=null;
			
		    		
		    		BT_Thread_Flag=false;
	 	    		hr.removeCallbacks(timer);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
	
		        // Do something with the selection
	    		setTitle("EcgView : "+listItems.get(item));
	    		strSelDeviceName = listItems.get(item);
	            hr.removeCallbacks(timer);
	            hr.postDelayed(timer, 500);
	
	            BTc=new BT_Controller();
	            BTc.start();
		    }
		});
		AlertDialog alert = builder.create();
		alert.show();
    }
    
	private void BTDevice_Start()
	{
		BTDevice_Select();
        hr.removeCallbacks(timer);
        hr.postDelayed(timer, 500);
        BTc=new BT_Controller();
        BTc.start();
	}    
	
	private void BTDevice_Stop()
	{
		BT_Thread_Flag=false;
		try {
			dataInStream.close();
			dataOutStream.close();
			btSocket.close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Log.e(TAG, "on Pause");
		hr.removeCallbacks(timer);
	}

    public class BT_Controller extends Thread{
    	public boolean LED_Flash=false;
    	public int battery_level=-1;
    	public Set<BluetoothDevice> BTDeviceSet;
    	// Bluetooth object
    	   public void run(){
    		   Looper.prepare();
    	   		try{
					if(ConnectBT()==true)
			        {
			        	BT_Thread_Flag=true;	
				        try {
							Thread.sleep(100);
							setup_raw_device();
					        Thread.sleep(100);
					        Close_Ack_Function();
				        } catch (Exception e) {
							// TODO Auto-generated catch block
							Log.e("EcgView","Error After connected!");
						}
				        hr.postDelayed(timer, 100);			        	
			        }
					try{
			    		while(BT_Thread_Flag){
			    			if(waitflag)
			            	{
			    				Thread.sleep(10);
			            	}
	            			else
	            			{
	            				int st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
	            				if(st==255)
	            				{
	            					st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
	            					if(st==255)
	            					{
	            						st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
	            						heart_rate_array[0]=st*256;
	            						st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
	            						heart_rate_array[0]+=st;
	            						
	            						st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
	            						heart_rate_array[1]=st*256;
	            						st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
	            						heart_rate_array[1]+=st;
	            						
	            						st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
	            						heart_rate_array[2]=st*256;
	            						st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
	            						heart_rate_array[2]+=st;
	            						
	            						st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
	            						heart_rate_array[3]=st*256;
	            						st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
	            						heart_rate_array[3]+=st;
	            						
	            						st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
	            						heart_rate_array[4]=st*256;
	            						st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
	            						heart_rate_array[4]+=st;
	            						
	            						st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
	            						heart_rate_array[5]=st*256;
	            						st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
	            						heart_rate_array[5]+=st;
	            						
	            						st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
	            						heart_rate_array[6]=st*256;
	            						st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
	            						heart_rate_array[6]+=st;
	            						
	            						st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
	            						heart_rate_array[7]=st*256;
	            						st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
	            						heart_rate_array[7]+=st;
	            						
	            						st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
	            						heart_rate_array[8]=st*256;
	            						st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
	            						heart_rate_array[8]+=st;
	            						
	            						st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
	            						heart_rate_array[9]=st*256;
	            						st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
	            						heart_rate_array[9]+=st;
	            						//================================
	            						//Log.e(TAG, "get a message");	        						
	            						waitflag=true;
	            						//Thread.sleep(10);

	            						// send message to main process
	                    				Message m = new Message();
	                    				m.what = 123;
	                    				handler.sendMessage(m);
	            					}
	            				}
	        				}
		    			}
		    		}catch (Exception e) {
						Log.e("BT reader error", e.getMessage());
					}
					
		    		Log.e("BT Thread", "BT Thread stop");
		    		dataInStream.close();
		    		dataOutStream.close();
		    		btSocket.close();
		    		btSocket=null;
		    		//mBluetoothAdapter=null;
		    		device=null;
		    		Log.e("BT Thread", "socket close");
		    		BT_Thread_Flag=false;
    	   		}catch(Exception ex){
    	   			Log.e("BT Thread err","321");
    	   		}
    	   }
    	   public void setup_hr_device(){
    	   	byte[] hr_mode = new byte[] {(byte)0xaa, (byte)0xaa, (byte)0x42, (byte)0x02, (byte)0x00, (byte)0x00, (byte) 0x00, (byte) 0x98};
    	   	try{
    	   		dataOutStream.write(hr_mode);
    	   	}catch(Exception ex){
    	   		Log.e("write command to SPP", ex.getMessage());
    	   	}
    	   }
    	   
    	   public void setup_raw_device(){
		    	byte[] hr_mode = new byte[] {(byte)0xaa, (byte)0xaa, (byte)0x42, (byte)0x01, (byte)0x00, (byte)0x00, (byte) 0x00, (byte) 0x97};
		    	try{
		    		dataOutStream.write(hr_mode);
		    	}catch(Exception ex){
		    		Log.e("write command to SPP", ex.getMessage());
		    	}
    	   }
    	   
    	   public void Close_Ack_Function(){
    	   	byte[] hr_mode = new byte[] {(byte)0xaa, (byte)0xaa, (byte)0x45, (byte)0x00, (byte)0x00, (byte)0x00, (byte) 0x00, (byte) 0x99};
    	   	try{
    	   		dataOutStream.write(hr_mode);
    	   	}catch(Exception ex){
    	   		Log.e("write command to SPP", ex.getMessage());
    	   	}
    	   }
    	   public void Heart_Rate_ACK(){
    	   	byte[] hr_mode = new byte[] {(byte)0xaa, (byte)0xaa, (byte)0x00, (byte)0x4f, (byte)0x4b, (byte)0x00, (byte) 0x00, (byte) 0xee};
    	   	try{
    	   		dataOutStream.write(hr_mode);
    	   	}catch(Exception ex){
    	   		Log.e("write command to SPP", ex.getMessage());
    	   	}
    	   }
    	   public boolean ConnectBT(){
/*    			try{
    			  mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
    			}catch(Exception ex){
    				Log.e("ConnectBT",ex.getMessage());
    				return false;
    			}
*/    			if (mBluetoothAdapter == null) 
    				return false;			
    			if (!mBluetoothAdapter.isEnabled()) 
    				return false;
    		    try{
    		    	Set<BluetoothDevice> BTDeviceSet=mBluetoothAdapter.getBondedDevices();
    		    	Log.e(TAG, "Success Get BT Adapter");
    		    	if(BTDeviceSet.size()>0){
    		 	    	for(BluetoothDevice list_device : BTDeviceSet){
    		 	    		if(list_device.getName().contains(strSelDeviceName))
    		 	    			device= mBluetoothAdapter.getRemoteDevice(list_device.getAddress());
    		 	    		Log.e(TAG, ">>>>>"+list_device.getName()+"<<<<<<");
    		 	    	}
    		    	}else{
    		    		Log.e(TAG, "No device");
    		    	}
    		    	Log.e(TAG, "After detect ");    		    	
    		    }catch(Exception e){
    		    	Log.e(TAG,"Try to get BluetoothDevice fail !! " + e.getMessage());
    		    }
    	      // We need two things before we can successfully connect
    	      // (authentication issues aside): a MAC address, which we
    	      // already have, and an RFCOMM channel.
    	      // Because RFCOMM channels (aka ports) are limited in
    	      // number, Android doesn't allow you to use them directly;
    	      // instead you request a RFCOMM mapping based on a service
    	      // ID. In our case, we will use the well-known SPP Service
    	      // ID. This ID is in UUID (GUID to you Microsofties)
    	      // format. Given the UUID, Android will handle the
    	      // mapping for you. Generally, this will return RFCOMM 1,
    	      // but not always; it depends what other BlueTooth services
    	      // are in use on your Android device.
    	      try {
					Log.e(TAG,device.getName());
					btSocket = device.createRfcommSocketToServiceRecord(MY_UUID);
					Log.e(TAG,"get socket");
					btSocket.connect();
					Log.e(TAG,"connect");
					mBluetoothAdapter.cancelDiscovery();
					dataInStream = new DataInputStream(btSocket.getInputStream());
					dataOutStream = new DataOutputStream(btSocket.getOutputStream());  
		            String command="D1";
		            dataOutStream.writeBytes(command);
		            Log.e(TAG, "Setup device");
					
					Log.e(TAG, "Setup device");
					return true;
    	      } catch (Exception e) {
					Log.e(TAG, "Socket creation failed."+ e.getMessage());
					return false;
    	      }
    	  }
       }
	
	
}
