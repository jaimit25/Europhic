package com.example.tutorial

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.Button
import android.widget.TextView
import android.widget.Toast
import com.example.tutorial.Pages.ReviewPage
import java.util.*
import kotlin.concurrent.schedule

class MainActivity : AppCompatActivity() {

    //initializing variable outside the oncreate method
    lateinit var toast : Toast
    lateinit var toast2 : Toast
    lateinit var textView : TextView
    lateinit var startbtn : Button
    lateinit var stopBtn : Button




    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        //initializing display view
        textView =  findViewById(R.id.title_page);
        startbtn=  findViewById(R.id.start);
        stopBtn = findViewById(R.id.stop);

        //initializing toast
        toast = Toast.makeText(this, "Welcome User", Toast.LENGTH_SHORT)
        toast2 = Toast.makeText(this, "Clicked Back button", Toast.LENGTH_SHORT)

        //initializing intent
        var intent : Intent = Intent(this, ReviewPage::class.java)


        //send data to other page using bundle since consturtor dosen't work
        var bun : Bundle = Bundle()
        bun.putString("name","hotmarty")
        intent.putExtras(bun)



        //using timer
        Timer().schedule(5000) {

            //displaying toast
            toast.show();

            //making visibility off
            textView.visibility = TextView.INVISIBLE;
        }

        //reacting to events
        startbtn.setOnClickListener(View.OnClickListener {
            //it will send data in bundle as well to different page
            startActivity(intent)
            finish()
        });




    }
    // overiding backbutton
    override fun onBackPressed() {
        super.onBackPressed()
        toast2.show()
    }


}
