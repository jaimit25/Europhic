package com.example.viewbindingandroid;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;

import androidx.appcompat.app.AppCompatActivity;
import com.example.viewbindingandroid.databinding.ActivityMainBinding;
public class MainActivity extends AppCompatActivity {

    ActivityMainBinding mainXml;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // No need of R.layout.xml_file_name
        //setContentView(R.layout.activity_main);

        mainXml = ActivityMainBinding.inflate(getLayoutInflater());
        setContentView(mainXml.getRoot());

        //directly access views without creating variable
        mainXml.text1.setText("Hello World !");
        mainXml.nextPage.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
//                Intent i = new Intent(MainActivity.this,PageTwo.class);
//                startActivity(i);
                startActivity(new Intent(getApplicationContext(),PageTwo.class));
            }
        });

    }


}





// View Binding
// 1) Normally we change something in java textview then same changes will reflect in XML code
// 2) Before we change a textView value in java code we need to reference it using findviwebyid(R.id...)
// 3) If we have many TextView then referencing would be difficult so we use ViewBinding #problem1 resolved
// 4) when we have multiples XML files then some component id would be same ie for some button xml1 has same id as xml2

//every activity will have its own binding class
//            activity_main.XML <-> mainActivityBindingClass(Java) <-> ActivityMain.java
//
//
//    #to enable View binding
//    #build.gradle(app):

//                  android {
//                           ...
//                          viewBinding{
//                              enabled = true
//                                     }
//                            ...
//                            }








