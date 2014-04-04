package com.example.hrm_bluetooth;

import android.app.Activity;
import android.content.DialogInterface;
import android.content.DialogInterface.OnClickListener;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

public class Demo1 extends Activity implements OnClickListener {
	 /** Called when the activity is first created. */
	
	private Button exp1, exp2;
	
	
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.demo1);
        
        exp1 = (Button)findViewById(R.id.data1);
        exp2 = (Button)findViewById(R.id.data2);
       
        exp1.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				 Intent myIntent = new Intent(v.getContext(), experiment1.class);
	                startActivityForResult(myIntent, 0);
				
			}
		});
           
        exp2.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				 Intent myIntent = new Intent(v.getContext(), experiment2.class);
	                startActivityForResult(myIntent, 0);
				
			}
		});
    }


	@Override
	public void onClick(DialogInterface dialog, int which) {
		// TODO Auto-generated method stub
		
	}
 
}
