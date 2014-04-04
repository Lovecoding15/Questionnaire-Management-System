package com.example.hrm_bluetooth;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;
import android.widget.Toast;

public class experiment2 extends Activity {
	 /** Called when the activity is first created. */
   @Override
   public void onCreate(Bundle savedInstanceState) {
       super.onCreate(savedInstanceState);
       setContentView(R.layout.exp1);

       //Find the view by its id
       TextView tv = (TextView)findViewById(R.id.textView1);

            
       
       //Get the text file
       File file = new File("//sdcard//jaya2.txt");
       // i have kept text.txt in the sd-card
       
       if (!file.exists()) 
	    {
       	tv.setText("Sorry jaya.txt doesn't exist!!");
	    	
	    } 

       if(file.exists())   // check if file exist
       {
       	  //Read text from file
           StringBuilder text = new StringBuilder();

           try {
               BufferedReader br = new BufferedReader(new FileReader(file));
               String line;

               while ((line = br.readLine()) != null) {
                   text.append(line);
                   text.append('\n');
               }
           }
           catch (IOException e) {
               //You'll need to add proper error handling here
           	e.printStackTrace();
           }
           //Set the text
           tv.setText(text);
           
           Toast.makeText(getApplicationContext(), "Person is not drowsy", Toast.LENGTH_LONG).show();                      
       }
       else
       {
       	tv.setText("Sorry file doesn't exist!!");
       }
    }

	
}