package com.example.FFT_transform;

import java.util.ArrayList;
import java.util.List;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.util.Log;

public class TodoDAO {
	private static SQLiteDatabase db;
	private TodoSQLiteHelper dbHelper;
	static int k =0;
	
	public TodoDAO(Context context) {
		dbHelper = new TodoSQLiteHelper(context);
		db = dbHelper.getWritableDatabase();
	}
	
			
	// Close the db
	public void onDestroy() {
		db.close();
	}
	
	
	/**
	 * Create new TODO object
	 * @param todoText
	 */
	public static void createTodo(double todoText) {
		ContentValues contentValues = new ContentValues();
		contentValues.put("ratio", todoText);
	   // Insert into DB
		db.insert("hb_ratio", null, contentValues);
		Log.i("Inserted into Database" ,String.valueOf(contentValues));
	}
	
	
	
	
	public List<Todo> getTodos() {
		List<Todo> todoList = new ArrayList<Todo>();
		
		// Name of the columns we want to select
		String[] tableColumns = new String[] {"_id","ratio"};
		
		// Query the database
		Cursor cursor = db.query("hb_ratio", tableColumns, null, null, null, null, null);
		cursor.moveToFirst();
		
		// Iterate the results
	    while (!cursor.isAfterLast()) {
	    	Todo todo = new Todo();
	    	// Take values from the DB
	    	todo.setId(cursor.getInt(0));
	    	todo.setText(cursor.getString(1));
	    	
	    	// Add to the DB
	    	todoList.add(todo);
	    	
	    	// Move to the next result
	    	cursor.moveToNext();
	    }
		
		return todoList;
	}
	
	
		public static void calculate(double[] result) {
		// TODO Auto-generated method stub
		double addlf =0;
		double addhf =0;
		double[] ratio = new double[1000] ;
		double finalvalue =0;
		
		//Log.i("Size of double result" ,String.valueOf(result.length));
		
		for(int i=6;i<96;i++)
		{
		 addlf+=result[i];
		//Log.i("Inside calculate method" ,String.valueOf(result[i]));
		}
		
		//Log.i("Lf value" ,String.valueOf(addlf));
		
		
		for(int j=97;j<250;j++)
			addhf+= result[j];
		
		//Log.i("Hf value" ,String.valueOf(addhf));
		
		ratio[k] =addlf/addhf;
		k++;
	
		
		if(k == 135)
		{
			finalvalue = (Math.round(ratio[134]*10000)/10000.0);		
			
			TodoDAO.createTodo(finalvalue);
		
		k=0;
		}
				
	}


		public static void DropTable() {
			// TODO Auto-generated method stub
			db.execSQL("DELETE FROM hb_ratio ");
			
//			ContentValues contentValues = new ContentValues();
//			contentValues.put("ratio","");
//			db.update("hb_ratio", contentValues, null, null);
		}


}
