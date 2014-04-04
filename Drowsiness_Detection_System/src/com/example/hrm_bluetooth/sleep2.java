package com.example.hrm_bluetooth;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

import android.app.Activity;
import android.media.MediaPlayer;
import android.media.MediaPlayer.OnCompletionListener;
import android.os.Bundle;
import android.util.Log;
import android.widget.TextView;
import android.widget.Toast;


public class sleep2 extends Activity {
	 /** Called when the activity is first created. */
	
	  private MediaPlayer mMediaPlayer;
	  
   @Override
   public void onCreate(Bundle savedInstanceState) {
       super.onCreate(savedInstanceState);
       setContentView(R.layout.exp1);

       //Find the view by its id
       TextView tv = (TextView)findViewById(R.id.textView1);

            
       
       //Get the text file
       File file = new File("//sdcard//sleep2.txt");
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
           
           Toast.makeText(getApplicationContext(), "Person is drowsy", Toast.LENGTH_LONG).show(); 
           playAudio();
       }
       else
       {
       	tv.setText("Sorry file doesn't exist!!");
       }
    }
   
   private void playAudio () {
       try {
               // http://www.soundjay.com/beep-sounds-1.html lots of free beeps here
           mMediaPlayer = MediaPlayer.create(this,R.raw.beep);
           mMediaPlayer.setLooping(false);
           Log.e("beep","started0");
           mMediaPlayer.start();
//           Log.e("beep","started1");
           mMediaPlayer.setOnCompletionListener(new OnCompletionListener() {
                       public void onCompletion(MediaPlayer arg0) {
                     // finish();
               }
       });
       } catch (Exception e) {
           Log.e("beep", "error: " + e.getMessage(), e);
       }
   }

   @Override
   protected void onDestroy() {
       super.onDestroy();
       if (mMediaPlayer != null) {
           mMediaPlayer.release();
           mMediaPlayer = null;
       }
   }

	
}
