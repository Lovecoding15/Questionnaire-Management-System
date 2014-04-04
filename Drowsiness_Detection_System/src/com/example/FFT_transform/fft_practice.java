package com.example.FFT_transform;

import java.util.ArrayList;


public class fft_practice
{
	public static void fft_test(ArrayList<Integer> test)
	
	{
		
		final float TWO_PI = (float) (2 * Math.PI);
		 double[] finalinput = new double[test.size()];
		 double[] Hamminginput = new double[test.size()];
		 double[] w = new double[test.size()];
		int N = test.size();		
	    Complex[] x = new Complex[N];
	    
	    //Hamming window techique:
	    
	   
	    for (int n = 0; n < test.size(); n++){
            w[n] =(0.54f - 0.46f * Math.cos(TWO_PI * n / (test.size()-1)));
           Hamminginput[n]= (Math.round(w[n]*10000)/10000.0);
           finalinput[n]=Double.valueOf(test.get(n))*Hamminginput[n];
           // Log.i("Generated Hamming Window" , String.valueOf(finalinput[n]));
	    }
	    
     
	    // original data
	    for (int i = 0; i < N; i++) {
	        x[i] = new Complex(i, 0);
	        x[i] = new Complex(finalinput[i], 0);
	    }
	    
	   // FFT.show(x, "x");
	
	    // FFT of original data
	    Complex[] y = FFT.fft(x);
	   // FFT.show(y, "y = fft(x)");
	    
	    double [] result = new double[y.length];
	    for(int i=0;i<y.length;i++)
	    {
	    	result[i] = Math.round(y[i].abs()*1000)/1000.0;
	    	//Log.i("fft(x)" , String.valueOf(result[i]));
	    }
	    
	    TodoDAO.calculate(result);
	}
}
