package com.example.hrm_bluetooth;

import com.example.hrm2_driver.hrm2_driver;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import android.os.Bundle;
import android.app.Activity;
import android.app.AlertDialog;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.content.DialogInterface;
import android.util.Log;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;


public class MainActivity_BL extends Activity implements OnClickListener {

	public static final String TAG = "MT_BlueLink";
	private BluetoothAdapter mBluetoothAdapter;
	public BluetoothDevice bt_device=null;
	public BluetoothSocket btSocket = null;
	public DataInputStream dataInStream;
	public DataOutputStream dataOutStream;
	private Button BtnSelect;
	private TextView textView_info;
	public hrm2_driver Hrm2Driver = null;
	
	private static final UUID MY_UUID =UUID.fromString("00001101-0000-1000-8000-00805F9B34FB");

	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main_bl);
		
		BtnSelect = (Button) findViewById(R.id.btn_select);
		BtnSelect.setOnClickListener(this);
		
		textView_info = (TextView) findViewById(R.id.textView1);
		textView_info.setText("");
		textView_info.append("\n\n");
		textView_info.append("Device : ");
		textView_info.append("\n\n Status : ");
		
        try
        {
        	Class.forName("com.example.hrm2_driver.hrm2_driver");
        	Hrm2Driver  = new hrm2_driver();
        }catch(ClassNotFoundException e)    {
			Log.e(TAG, String.format("ClassNotFoundException %s !",  e.getMessage()));
        }
		
	
		load_BT();
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.activity_main, menu);
		return true;
	}
	
	private void load_BT()
	{
		// Checking bluetooth Adapter exists
		mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
		if (mBluetoothAdapter == null) {
			// Device does not support Bluetooth
			AlertDialog.Builder builder = new AlertDialog.Builder(this);
			builder.setMessage("Device does not support Bluetooth---1!")
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
	
	@Override
	public void onClick(View v) {
		
		
		try {
			if(dataInStream!=null)
				dataInStream.close();
			if(dataOutStream!=null)
				dataOutStream.close();
			if(btSocket!=null)
				btSocket.close();
			btSocket=null;
			bt_device=null;
			
			textView_info.setText("");
			textView_info.append("\n\n");
			textView_info.append("Device: ");
			textView_info.append("\n\nStatus: ");
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}


		
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
		         // Do something with the selection
	    		textView_info.setText("");
	    		textView_info.append("\n\n");
	    		textView_info.append("Device Name : ");
	    		textView_info.append(listItems.get(item));
		    	if(connect_BT(listItems.get(item))==true)
		    	{
		    		textView_info.append("\n\n Status: Device connected");
		    	}
		    	else
		    	{
		    		textView_info.append("\n\n Status: Device not connected");
		    	}
		    }
		});
		AlertDialog alert = builder.create();
		alert.show();
    }
	
	private boolean connect_BT(String DeviceName)
	{
		Set<BluetoothDevice> pairedDevices = mBluetoothAdapter.getBondedDevices();
		// If there are paired devices
		if (pairedDevices.size() > 0) {
		    // Loop through paired devices
		    for (BluetoothDevice list_device : pairedDevices) {
		        // Add the name and address to an array adapter to show in a ListView
		    	if(list_device.getName().compareTo(DeviceName)==0) {
		    		
		    	      try {
				    		bt_device= mBluetoothAdapter.getRemoteDevice(list_device.getAddress());
							btSocket = bt_device.createRfcommSocketToServiceRecord(MY_UUID);
							btSocket.connect();
							mBluetoothAdapter.cancelDiscovery();
							dataInStream = new DataInputStream(btSocket.getInputStream());
							dataOutStream = new DataOutputStream(btSocket.getOutputStream());        
							return true;
		    	      } catch (Exception e) {

							return false;
		    	      }
		    	}
		    }
		}			
		return false;
	}

}
