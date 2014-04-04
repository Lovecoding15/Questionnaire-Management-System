package com.example.FFT_transform;

import java.util.ArrayList;

public class decimate_logic {
	
	
	
	int decimationFactor = 100;
	
	ArrayList<Integer> dataIn= new ArrayList<Integer>();
	ArrayList<Integer> dataOut= new ArrayList<Integer>();
	Integer option;
	
	
	 int n,i,k;	
	public void decimate_test(ArrayList<Integer> test){
		
		
		
		
		//Log.i ("hrList Values", test.toString ());
		
		for (i=1;i<test.size();i+= decimationFactor)
		{
			
			option = test.get(i);
			dataOut.add(option);
			if(dataOut.size()==512)
			{
				//Log.i ("Size of data out is 512", dataOut.toString ());
				fft_practice.fft_test(dataOut);
				dataOut.clear();
			}
			
			
		}
		
//		n= dataOut.size();
//		Log.i ("Inside for loop", dataOut.toString ());
//		Log.i ("Size of dataout", new Integer(n).toString());
//		
		 
		

	}
}
	        
	        
		
	

