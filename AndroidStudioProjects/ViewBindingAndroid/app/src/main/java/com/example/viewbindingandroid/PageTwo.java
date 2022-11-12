package com.example.viewbindingandroid;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;

import com.example.viewbindingandroid.databinding.ActivityPageTwoBinding;

public class PageTwo extends AppCompatActivity {

    ActivityPageTwoBinding pageTwoXML;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_page_two);

        pageTwoXML = ActivityPageTwoBinding.inflate(getLayoutInflater());
        setContentView(pageTwoXML.getRoot());

        pageTwoXML.txt1.setText("This is page two : ");

        for(int i = 0 ; i < 5 ; i++){
            Integer y = new Integer(i);
            pageTwoXML.txt1.setText( pageTwoXML.txt1.getText()+" " + y.toString());
        }
    }
}