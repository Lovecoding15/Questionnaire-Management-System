package com.example.hrm_bluetooth;


import com.example.statnn.statnn;
import com.example.statnn.statnn_value;
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

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;
import android.os.Environment;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.util.Log;
import android.view.Display;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.FrameLayout;


public class MainActivity_HRV extends Activity {
	
	protected static final int MENU_SELECT_DEVICE = Menu.FIRST;
	protected static final int MENU_QUIT = Menu.FIRST+1;
	
	static final int MAX_MS = 3000;
		
	public static final String TAG = "HRV";
	
	public TextView textView_cal, textView_heart, textView_time;
	
	public BluetoothAdapter mBluetoothAdapter = null;
	public BluetoothDevice device=null;
	public DataInputStream dataInStream;
	public DataOutputStream dataOutStream;
	public BluetoothSocket btSocket = null;
	public String strSelDeviceName;
	
	public boolean BT_Thread_Flag=false;

	//public boolean flag = false;
	public boolean waitflag=false;
	public ArrayList<Integer> hrList = new ArrayList();
	public int[] RRI_array = new int[15];
	public int RRI_array_Idx =0;
	private static final UUID MY_UUID =UUID.fromString("00001101-0000-1000-8000-00805F9B34FB");
	public BT_Controller BTc = null;
	
	public FrameLayout ty=null;
	public myView mv = null;
	public Handler handle_hrv = new Handler();
	public Handler handle_hr = new Handler();
	
	Rect View_rect;
	
	public statnn_value nn_value = null;
	public statnn nn = null;
	public hrm2_driver Hrm2Driver = null;
	
	public double time_total, time_rr;
	public boolean bUpdata_statnnValue=false;
	
	public int heart_rate=0;
	public int[] HeartRateSeq = new int[100];
	public int iTestTime = 0;
	
	public Runnable timer_hrv=new Runnable()
	{
	    public void run() 
	    {
	    	if(bUpdata_statnnValue==true)
	    	{
				textView_cal.setText("");
				textView_cal.append(String.format(" SDNN  = %2.3f\n", nn_value.SDANN));
				textView_cal.append(String.format("SDANN  = %2.3f\n", nn_value.SDANN));
				textView_cal.append(String.format(" AVNN  = %2.3f\n", nn_value.AVNN));
				textView_cal.append(String.format("pNN50  = %2.3f\n", nn_value.pNN[0]));
				bUpdata_statnnValue=false;
	    	}	    	
	    	mv.invalidate();
	    	handle_hrv.postDelayed(this, 100);
	    }
	};
	
	
    public Runnable timer_hr = new Runnable(){
		@Override
		public void run() {
			// TODO Auto-generated method stub
			PushInStack(heart_rate);
			iTestTime++;

			int h,m,s;
			h = iTestTime/3600;
			m = (iTestTime%3600)/60;
			s = iTestTime%60;
			
			textView_time.setText(String.format("%02d:%02d:%02d", h, m, s));
			textView_heart.setText(valueFromat(getNearAVG()));

			handle_hr.postDelayed(this, 1000);    
		}
    };	
	
    
    public String valueFromat(int value){
    	String stringval = String.valueOf(value);
    	while(stringval.length()<3){
    		stringval="0"+stringval;
    	}
    	return stringval;
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
    
    public int getNearAVG(){
    	int temp=0;
    	for(int i= this.HeartRateSeq.length-10 ; i < this.HeartRateSeq.length ; i++ ){
    		temp += HeartRateSeq[i];
    	}
    	return (temp/10);
    }    
	
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
        setContentView(R.layout.activity_main_hrv);
 	    setTitle("HRV :Select a Device");
 	    
 	    textView_cal = (TextView)findViewById(R.id.textView_hrv); 	    
 	    textView_heart = (TextView)findViewById(R.id.textView_h); 	  
 	    textView_time = (TextView)findViewById(R.id.textView_t);
 	    
	    
 	    setDefault_textView();
 	    
        ty = (FrameLayout)findViewById(R.id.frameLayout1);
        mv = new myView(this);
        try{
        	ty.addView(mv,0);
        }catch(Exception ex){
        	Log.e(TAG, "add view caused error !! ");
        }
        
        getBTAdapter();
        try
        {
        	Class.forName("com.example.statnn.statnn");
        	Class.forName("com.example.statnn.statnn_value");
        	Class.forName("com.example.hrm2_driver.hrm2_driver");

        	nn = new statnn();
        	nn_value = new statnn_value();
        	nn.statnn_option("5:00","20 50",0,0);
        	Hrm2Driver  = new hrm2_driver();
        }catch(ClassNotFoundException e)    {
			Log.e(TAG, String.format("ClassNotFoundException %x !",  e.getMessage()));
        }
        time_total=0; time_rr=0;
        bUpdata_statnnValue=false;
        heart_rate = 0;
        iTestTime = 0;
    }
    
	public void setDefault_textView()
	{
		textView_cal.setText("");
		textView_cal.append(" SDNN = \n");
		textView_cal.append("SDANN = \n");
		textView_cal.append(" AVNN = \n");
		textView_cal.append("pNN50 = \n");
		textView_heart.setText("000");
		textView_time.setText("00:00:00");
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
	        	 setTitle("HRV : Device Selected");
	        	 time_total=0; time_rr=0;
	        	 bUpdata_statnnValue=false;
	             heart_rate = 0;
	             iTestTime = 0;
	             setDefault_textView();
	        	 BTDevice_Start();
	             break;
	        case MENU_QUIT:
	        	 setTitle("HRV : Quit");
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
        	for(int i=0 ;i<12;i++)
        	{
        		hrList.add(RRI_array[i]);
				int width = View_rect.width()-10;
				int height = View_rect.height()-80;
				
				if(hrList.size()>width)				//move sample data into list
	        		hrList.remove(0);
        	}
        	RRI_array_Idx = 0;
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
	    	int marginLeft = 70;
	    	int marginRight = 10;
	    	int marginBottom = 40;
			View_rect = canvas.getClipBounds();

			try{
				int x = View_rect.left+marginLeft;
				int y = View_rect.top+marginTop;
				int Offset;
				int width = View_rect.width()-(marginLeft+marginRight);
				int height = View_rect.height()-(marginTop+marginBottom);
				
		    	paint.setColor(getResources().getColor(R.color.view_bk));
				paint.setStrokeWidth(3);
				canvas.drawRect(0,0,View_rect.width(),View_rect.width(),  paint);

				paint.setColor(getResources().getColor(R.color.view_line));
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
				String strOut="";
				for(int i=0; i<13; i++)
				{
					Offset = (height/12)*i;
					if(i<12)
					{
						paint.setColor(getResources().getColor(R.color.view_line));
						canvas.drawLine(x,y+Offset,	x+10,y+Offset,paint);
					}
					strOut = "";
					switch(i)
					{
					case 0:
						strOut= "(ms)";
						break;
					case 2:
						strOut= "2500";
						break;
					case 4:
						strOut= "2000";
						break;
					case 6:
						strOut= "1500";
						break;
					case 8:
						strOut= "1000";
						break;
					case 10:
						strOut= "0500";
						break;
					case 12:
						strOut= "0000";
						break;
					}
					
					if(strOut.length()>0)
					{
						paint.setTextSize(20);
						paint.setColor(getResources().getColor(R.color.view_label));
						canvas.drawText(strOut, 10, y+Offset+10, paint);
					}
				}
				
				//draw ECG
				paint.setColor(getResources().getColor(R.color.view_value));
				paint.setStrokeWidth(1);
				Offset = 3; 
				x=marginLeft;	y=marginTop;
				for(int i=Offset ; i<hrList.size()-Offset; i++)
				{
					int x1,y1, x2, y2;
					x1 = i;
					y1 = (Integer) (height * (MAX_MS-hrList.get(i-Offset))/MAX_MS);
					x2 = i+1;
					y2 = (Integer) (height * (MAX_MS-hrList.get(i-Offset+1))/MAX_MS);
		    		canvas.drawLine(x+x1, y+y1, x+x2, y+y2, paint);
				}
				
				paint.setColor(getResources().getColor(R.color.view_label));
				paint.setTextSize(22);
				canvas.drawText("time", x+width-45, y+height+25, paint);
				
				
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
		    		handle_hrv.removeCallbacks(timer_hrv);
		    		handle_hr.removeCallbacks(timer_hr);
	 	    		
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
	
		        // Do something with the selection
	    		setTitle("MT_HRV : "+listItems.get(item));
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
		handle_hrv.removeCallbacks(timer_hrv);
		handle_hr.removeCallbacks(timer_hr);
	}

    public class BT_Controller extends Thread{
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
							setup_hr_device();
					        Thread.sleep(100);
					        Close_Ack_Function();
				        } catch (Exception e) {
							// TODO Auto-generated catch block
							Log.e("MT_HRV","Error After connected!");
						}
				        //hr.postDelayed(timer, 100);	
				        handle_hrv.removeCallbacks(timer_hrv);
			    		handle_hrv.postDelayed(timer_hrv, 500);

			    		handle_hr.removeCallbacks(timer_hr);
			    		handle_hr.postDelayed(timer_hr, 1000);
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
	            				
	            				if(st==170)
	            				{
	            					st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
	            					if(st==170)
	            					{
				    					st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
			            				Log.e(TAG, String.format("%x", st));
					    				if(st==78){
					    					int st1,st2, iDataNo;
					    					// get point 1--------------------------------
					    					st1= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
		            						st2= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
		    	            				Log.e(TAG, String.format("%x  %x", st1, st2));
		    	            				iDataNo = st1/16;
		            						set_view_and_statnn_point(st1, st2);
		            						
		            						// get point 2--------------------------------
		            						st1= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
		            						st2= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
		    	            				Log.e(TAG, String.format("%x  %x", st1, st2));
		            						set_view_and_statnn_point(st1, st2);

		            						//if(RRI_array_Idx >= 14 && iDataNo==12)
		            						if(RRI_array_Idx >= 14)
		            						{
			            						waitflag=true;
			            						// send message to main process
			                    				Message m = new Message();
			                    				m.what = 123;
			                    				handler.sendMessage(m);		            							
		            						}
					    				}
					    				if(st==68){
					    					st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
					    					heart_rate=st;
					    					Log.e(TAG,"Get a hear rate data = "+ heart_rate);
					    					
					    					int battery_h = Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
					    					int battery_l = Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
					    					int battery_adc=(battery_h * 256 + battery_l);
					    				}
					    				else if(st==0){
					    					Log.e(TAG, "Get a ack message!!");
					    					st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
					    					st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
					    					st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
					    					st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
					    					st= Hrm2Driver.CheckData(dataInStream.readUnsignedByte());
					    				}					    				
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
    	   
    	   public void set_view_and_statnn_point(int st1, int st2)
    	   {
    		   int i=0;
    		   int temp;
    		   temp = st1 & 0x1f; temp<<=8;  temp+=st2;
				if((st1 & 0x10)!=0)
					temp = temp - 5535;
				RRI_array[RRI_array_Idx] = temp;
    		   
				time_rr= RRI_array[RRI_array_Idx];
				nn.statnn_push(String.format("%f %f N", time_total/1000, time_rr/1000));
				if(nn.statnn_calc(nn_value)==1)
				{
					bUpdata_statnnValue = true;
				}
				time_total+=time_rr;
				RRI_array_Idx++;
    		   
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
