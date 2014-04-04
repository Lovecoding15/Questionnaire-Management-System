package com.example.hrm_bluetooth;


import android.app.ListActivity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.Toast;

public class Listview extends ListActivity {
	

	//String classes[]={"MainActivity_BL","MainActivity_ECG","MainActivity_HRM","MainActivity_HRV","Show_Database"};
	
	String classes[]={"Bluetooth Connection","Heart Rate Measurement","Heart Rate Variability" , "ECG for Drowsiness Detection","Database" , "Demo1-Awake", "Demo2-Asleep"};
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		setListAdapter(new ArrayAdapter<String>(Listview.this, android.R.layout.simple_list_item_1, classes));
	}

	@Override
	protected void onListItemClick(ListView l, View v, int position, long id) {
		// TODO Auto-generated method stub
		
	   super.onListItemClick(l, v, position, id);
	   
		String selected = classes[position];
		//Toast.makeText(getApplicationContext(), selected, Toast.LENGTH_LONG).show();
		
		if("Bluetooth Connection".equals(selected))
		{
			try{
			Class ourClass= Class.forName("com.example.hrm_bluetooth.MainActivity_BL" );
			Intent ourIntent = new Intent(Listview.this,ourClass);
			startActivity(ourIntent);
		}
			catch(ClassNotFoundException e)
			{
				e.printStackTrace();
			}
		}
		
		if("ECG for Drowsiness Detection".equals(selected))
		{
			try{
			Class ourClass= Class.forName("com.example.hrm_bluetooth.MainActivity_ECG" );
			Intent ourIntent = new Intent(Listview.this,ourClass);
			startActivity(ourIntent);
		}
			catch(ClassNotFoundException e)
			{
				e.printStackTrace();
			}
		}
		
		if("Heart Rate Measurement".equals(selected))
		{
			try{
			Class ourClass= Class.forName("com.example.hrm_bluetooth.MainActivity_HRM" );
			Intent ourIntent = new Intent(Listview.this,ourClass);
			startActivity(ourIntent);
		}
			catch(ClassNotFoundException e)
			{
				e.printStackTrace();
			}
		}
		
		if("Heart Rate Variability".equals(selected))
		{
			try{
			Class ourClass= Class.forName("com.example.hrm_bluetooth.MainActivity_HRV" );
			Intent ourIntent = new Intent(Listview.this,ourClass);
			startActivity(ourIntent);
		}
			catch(ClassNotFoundException e)
			{
				e.printStackTrace();
			}
		}
		
		if("Database".equals(selected))
		{
			try{
			Class ourClass= Class.forName("com.example.hrm_bluetooth.Show_Database" );
			Intent ourIntent = new Intent(Listview.this,ourClass);
			startActivity(ourIntent);
		}
			catch(ClassNotFoundException e)
			{
				e.printStackTrace();
			}
		}
		
		if("Demo1-Awake".equals(selected))
		{
			try{
			Class ourClass= Class.forName("com.example.hrm_bluetooth.Demo1" );
			Intent ourIntent = new Intent(Listview.this,ourClass);
			startActivity(ourIntent);
		}
			catch(ClassNotFoundException e)
			{
				e.printStackTrace();
			}
		}
		
		if("Demo2-Asleep".equals(selected))
		{
			try{
			Class ourClass= Class.forName("com.example.hrm_bluetooth.Demo2" );
			Intent ourIntent = new Intent(Listview.this,ourClass);
			startActivity(ourIntent);
		}
			catch(ClassNotFoundException e)
			{
				e.printStackTrace();
			}
		}
		
		
//		try{
//		Class ourClass= Class.forName("com.example.hrm_bluetooth." +selected);
//		Intent ourIntent = new Intent(Listview.this,ourClass);
//		startActivity(ourIntent);
//		}
//		
//		catch(ClassNotFoundException e)
//		{
//			e.printStackTrace();
//		}
//		
	}

	
	}

