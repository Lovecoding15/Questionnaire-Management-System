package com.example.hrm_bluetooth;



import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.Toast;

import com.example.FFT_transform.TodoDAO;

public class Show_Database extends Activity implements OnClickListener {
	
	private Button show, delete, export;
	
	
	@ Override	
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.database);
		
		
		 show= (Button)findViewById(R.id.btn_database);
		 delete= (Button)findViewById(R.id.btn_delete);
		 export= (Button)findViewById(R.id.btn_export);
		 
		 show.setOnClickListener(this);
		 delete.setOnClickListener(this);
		 export.setOnClickListener(this);
}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		if(show.isPressed())
		{
			Intent intent = new Intent(this, Show_values.class);
			// Start activity
			startActivity(intent);
			// Finish this activity
			this.finish();
			
		}
		else if(delete.isPressed())
		{
			Toast.makeText(getApplicationContext(), "Database is deleted!", Toast.LENGTH_LONG).show();
			TodoDAO.DropTable();
		}
		else if(export.isPressed())
		{
			
			 InputStream myInput;
			 
				try {
		 
					myInput = new FileInputStream("/data/data/com.example.hrm_bluetooth/databases/hb_ratio");//this is
		// the path for all apps
		
		 
				
				    // Set the output folder on the SDcard
				    File directory = new File("//sdcard//Database");
				    // Create the folder if it doesn't exist:
				    if (!directory.exists()) 
				    {
				    	
				    	directory.mkdirs();
				    } 
				    // Set the output file stream up:
		 
				    OutputStream myOutput = new FileOutputStream(directory.getPath()+
		 "/database_name.backup");
		 
		 
		 
				    // Transfer bytes from the input file to the output file
				    byte[] buffer = new byte[1024];
				    int length;
				    while ((length = myInput.read(buffer))>0)
				    {
				        myOutput.write(buffer, 0, length);
				    }
				    // Close and clear the streams
		 		  
				    myOutput.flush();
		 
				    myOutput.close();
		 
				    myInput.close();
		 
				} catch (FileNotFoundException e) {
			Toast.makeText(this, "Backup Unsuccesfull!", Toast.LENGTH_LONG).show();
		 
		 
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IOException e) {
			Toast.makeText(this, "Backup Unsuccesfull!", Toast.LENGTH_LONG).show();
		 
		 
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		Toast.makeText(this, "Backup Done Succesfully!", Toast.LENGTH_LONG).show();
		}
	}

	
}