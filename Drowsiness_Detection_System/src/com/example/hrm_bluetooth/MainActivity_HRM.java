package com.example.hrm_bluetooth;

import com.example.hrm2_driver.hrm2_driver;
import android.os.Bundle;
import android.app.Activity;
import android.app.AlertDialog;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.WindowManager.LayoutParams;
import android.widget.ImageView;
import android.widget.TextView;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.graphics.drawable.BitmapDrawable;
import android.util.Log;
//used by BT
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.content.DialogInterface;



import android.widget.Button;
import android.widget.ImageView.ScaleType;

public class MainActivity_HRM extends Activity implements OnTouchListener  {

	protected static final int MENU_SELECT_DEVICE = Menu.FIRST;
	protected static final int MENU_QUIT = Menu.FIRST+1;

	private static final int GUI_NOTIFY_DATA_IN = 0x101;

	private static final int NOTIFY_YES 	= 1;
	private static final int NOTIFY_NO 		= 2;
	
	/* bluetooth and device varity */ 
	public BluetoothAdapter mBluetoothAdapter = null;
	public BluetoothSocket btSocket = null;
	public BluetoothDevice device=null;
	public DataInputStream dataInStream;
	public DataOutputStream dataOutStream;
	public String strSelDeviceName;
	
    /** Called when the activity is first created. */
	public ImageView iView_LightStatus, iView_DataIn;
	public TextView textView_heart, textView_avg, textView_max, textView_car, textView_hrv;
	public TextView textView_DeviceName;
	public int MaxHeartRate;
	public int[] HeartRateSeq = new int[100];
	public Handler hr = new Handler();

	private static final String TAG = "Zoe Cloude";
	public Button Bc;
	public boolean BT_Thread_Flag=false;
	public int heart_rate=0;
	// parameter for BT
	private static final boolean D = true;
	private static final UUID MY_UUID =UUID.fromString("00001101-0000-1000-8000-00805F9B34FB");
	public BT_Controller BTc = null;
	public hrm2_driver Hrm2Driver = null;
	
	private Handler handler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			super.handleMessage(msg);
			
			switch(msg.what) {
			case GUI_NOTIFY_DATA_IN:
				if(iView_DataIn!=null) {
					int iNotify = (Integer) msg.obj;
					if(iNotify == NOTIFY_YES)
						iView_DataIn.setImageResource(R.drawable.green_48);
					else if(iNotify == NOTIFY_NO)
						iView_DataIn.setImageResource(R.drawable.gray_48);
				}				
				break;
			};
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
//		this.running_flag=true;
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
        Log.e(TAG, "On Create");
        setContentView(R.layout.activity_main_hrm);     

        // connect the layout object
        this.iView_LightStatus = (ImageView) findViewById(R.id.imageView_lightstatus);
        this.iView_DataIn = (ImageView) findViewById(R.id.imageView_datain);
        this.textView_heart = (TextView)findViewById(R.id.textView_HeartRate);
        this.textView_avg = (TextView) findViewById(R.id.textView_avg);
       // this.textView_car = (TextView) findViewById(R.id.TextView_car);
        this.textView_max = (TextView) findViewById(R.id.TextView_max);
        this.textView_hrv = (TextView) findViewById(R.id.TextView_hrv);
        this.textView_DeviceName = (TextView) findViewById(R.id.textView_DeviceName);
        this.textView_DeviceName.setOnTouchListener(this);
        // assign picture to view object
        this.iView_LightStatus.setImageResource(R.drawable.red_48);
       
        
        try
        {
        	Class.forName("com.example.hrm2_driver.hrm2_driver");
        	Hrm2Driver  = new hrm2_driver();
        }catch(ClassNotFoundException e)    {
			Log.e(TAG, String.format("ClassNotFoundException %x !",  e.getMessage()));
        }        

        getWindow().addFlags(LayoutParams.FLAG_KEEP_SCREEN_ON);
        textView_DeviceName.setText("Select A Device from menu");
        getBTAdapter();
    }
    

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		super.onCreateOptionsMenu(menu);
	    menu.add(0, MENU_SELECT_DEVICE, 0, "Select a device");
	    menu.add(0, MENU_QUIT, 0, "Quit");
	    return true;
	}
	
	
	@Override
	public boolean onOptionsItemSelected(MenuItem item)
	{
	    super.onOptionsItemSelected(item);
	    switch(item.getItemId()){
	         case MENU_SELECT_DEVICE:
	        	 BTDevice_Start();
	             break;
	        case MENU_QUIT:
	        	 BTDevice_Stop();
	             finish();
	            break;
	      }
	      return true;
	}	
	
	
	@Override
	public boolean onTouch(View arg0, MotionEvent arg1) {
		// TODO Auto-generated method stub
		BTDevice_Start();
		return false;
	};		
	
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
			builder.setMessage("Enable Bluetooth!")
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
	    		textView_DeviceName.setText(listItems.get(item));
	    		strSelDeviceName = listItems.get(item);
	
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

	
	public void notifyGetData() {
		Message message;
		message = handler.obtainMessage(GUI_NOTIFY_DATA_IN, NOTIFY_YES);
		handler.sendMessage(message);
		
		Message message2;
		message2 = handler.obtainMessage(GUI_NOTIFY_DATA_IN, NOTIFY_NO);
		handler.sendMessageDelayed(message2, 1000);
	}
	
    public Runnable timer = new Runnable(){
		@Override
		public void run() {
			// TODO Auto-generated method stub
			//Log.e(TAG,android.text.format.DateFormat.format("yyyy/MM/dd+hh:mm:ss", new java.util.Date()).toString());
			refreshMax(heart_rate);
			PushInStack(heart_rate);
			textView_max.setText(valueFromat(MaxHeartRate));
			textView_avg.setText(valueFromat(getHeartRateAVG()));
			textView_hrv.setText(getBattery());
		//	textView_car.setText(valueFromat(getCalorie()));
			textView_heart.setText(valueFromat(getNearAVG()));
			// BT connect Indicator
			if(BT_Thread_Flag)
				iView_LightStatus.setImageResource(R.drawable.green_48);
			else
				iView_LightStatus.setImageResource(R.drawable.red_48);
			
			if(!BTc.isAlive()){
				BTc = new BT_Controller();
				BTc.start();
			}
			hr.postDelayed(this, 1000);    
		}
    };
    public String getBattery(){
    	if(BTc.battery_level==0){
    		return "LOW";
    	}else if(BTc.battery_level==1){
    		return "1/5";
    	}else if(BTc.battery_level==2){
    		return "2/5";
    	}else if(BTc.battery_level==3){
    		return "3/5";
    	}else if(BTc.battery_level==4){
    		return "4/5";
    	}else if(BTc.battery_level==5){
    		return "FULL";
    	}
    	return "no";
    }
    public int getNearAVG(){
    	int temp=0;
    	for(int i= this.HeartRateSeq.length-10 ; i < this.HeartRateSeq.length ; i++ ){
    		temp += HeartRateSeq[i];
    	}
    	return (temp/10);
    }
//    public int getCalorie(){
//    	//This function is used to calculate calorie 
//    	int calorie=0;
//    	int body_weight = 60;
//    	int hr=getNearAVG();
//    	if (hr<70){
//    		calorie=(int)(3.5 * body_weight * 5 / 1000);
//    	}else{
//    		calorie=(int)(((hr-70) * 0.28+3.5) * body_weight / 1000 * 54 * 5);
//    	}
//    	return calorie;
//    }
    public String valueFromat(int value){
    	String stringval = String.valueOf(value);
    	while(stringval.length()<3){
    		stringval="0"+stringval;
    	}
    	return stringval;
    }
    public void refreshMax(int heartrate){
    	if(heartrate>this.MaxHeartRate){
    		this.MaxHeartRate=heartrate;
    	}
    }
    public void PushInStack(int value){
    	String debugMessage = "";
    	int temp = 0;
    	for(int i = 0;i<this.HeartRateSeq.length-1;i++){
    		temp = this.HeartRateSeq[i+1];
    		this.HeartRateSeq[i] = temp;
    		debugMessage += String.valueOf(temp) + " ; ";  
    	}
    	this.HeartRateSeq[HeartRateSeq.length-1] = value;
    }
    public int getHeartRateAVG(){
    	int temp=0;
    	for(int i=0 ; i < this.HeartRateSeq.length ; i++ ){
    		temp += HeartRateSeq[i];
    	}
    	return (temp/HeartRateSeq.length);
    }
    public int getHRV(){
    	return Math.abs(HeartRateSeq[9]-HeartRateSeq[8]);
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
			        	setup_hr_device();
			        	Thread.sleep(100);
			        	Close_Ack_Function();
			        	hr.removeCallbacks(timer);
			        	hr.postDelayed(timer, 500);
			        }
					try {
			    		while(BT_Thread_Flag){
			    			try{
			    				//Thread.sleep(1000);
			    				//Log.e(TAG,"BT Thread");
				    			Thread.sleep(10);
				    			int st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
				    			if(st==170){
				    				st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
				    				if(st==170){
				    					st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
					    				if(st==68){
											hr.post(new Runnable() {
												@Override
												public void run() {
													notifyGetData();
												}
											});					    					
					    					
					    					st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
					    					heart_rate=st;
					    					Log.e(TAG,"Get a hear rate data = "+ heart_rate);
					    					int battery_h = Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
					    					int battery_l = Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
					    					int battery_adc=(battery_h * 256 + battery_l);
					    					if(battery_adc>635){	    
					    						battery_level=5;
					    					}else if(battery_adc>610){	
					    						battery_level=4;
					    					}else if(battery_adc>585){	
					    						battery_level=3;
					    					}else if(battery_adc>560){	
					    						battery_level=2;
					    					}else if(battery_adc>535){	
					    						battery_level=1;
					    					}else
					    						battery_level=0;
					    					

/*					    					if(battery_adc>669){	//3.925V / 2/ 3V * 1024
					    						battery_level=3;
					    					}else if(battery_adc>645){	//	3.785V
					    						battery_level=2;
					    					}else if(battery_adc>633){	//	3.714V
					    						battery_level=1;
					    					}else if(battery_adc>563){	//	3.300V
					    						battery_level=0;
					    					}
*/					    				}else if(st==0){
					    					Log.e(TAG, "Get a ack message!!");
					    					st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
					    					st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
					    					st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
					    					st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
					    					st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
					    				}
				    				}
				    			}	
			    			}catch(Exception ex){
			    				Log.e(TAG,"thread error" + ex.getMessage());
			    				break;
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
					Log.e(TAG, "Setup device");
					return true;
    	      } catch (Exception e) {
					Log.e(TAG, "Socket creation failed."+ e.getMessage());
					return false;
    	      }
    	  }
       }

}
