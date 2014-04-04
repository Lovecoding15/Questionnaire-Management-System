package com.example.FFT_transform;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

public class TodoSQLiteHelper  extends SQLiteOpenHelper {

	public TodoSQLiteHelper(Context context) {
		super(context, "hb_ratio", null, 1);
		// TODO Auto-generated constructor stub
	}

	/**
	 * Create simple table
	 * hb_ratio
	 * 		_id 		- key
	 * 		ratio		- decimal
	 * 		Time		- Timestamp
	 */
	@Override
	public void onCreate(SQLiteDatabase db) {
		// TODO Auto-generated method stub
		db.execSQL("CREATE TABLE hb_ratio (_id INTEGER PRIMARY KEY AUTOINCREMENT, ratio DECIMAL(1,4));");
	}

	/**
	 * Recreates table
	 */
	
	@Override
	public void onUpgrade(SQLiteDatabase db, int oldVer, int newVer) {
		// TODO Auto-generated method stub
		// DROP table
				db.execSQL("DROP TABLE IF EXISTS hb_ratio");
				// Recreate table
				onCreate(db);
	}
	

}
