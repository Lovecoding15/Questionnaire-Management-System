package com.example.hrm_bluetooth;

import android.app.ListActivity;
import android.os.Bundle;

import com.example.FFT_transform.TodoDAO;



public class Show_values extends ListActivity{
	
	public TodoDAO dao;
	
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

				
		dao = new TodoDAO(this);
		
		setListAdapter(new ListAdapter(this, dao.getTodos()));
}

}