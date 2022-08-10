package com.example.tutorial.Pages

import android.os.Bundle
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.example.tutorial.R

class ReviewPage : AppCompatActivity() {

    lateinit var textView: TextView;

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_review_page)

        //initializing the views
        textView = findViewById(R.id.name)

        //initialing bundle variable and get the extra(data) from the bundle which was passed into intent
        val b = intent.extras
        if (b != null) {
            setData(b)
        }
    }

    //function for getting data from extra in intent and displaying in the TextView if its not NULL
    fun setData(b : Bundle){
        var value :String = "Name"
        if (b != null) value = b.getString("name").toString()
        if(b != null)
            textView.setText(value)
        else
            textView.setText("name is null")
    }




}