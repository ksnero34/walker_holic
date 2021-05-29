package com.example.walkerholic

import io.flutter.embedding.android.FlutterActivity

import android.os.Build
import android.view.ViewTreeObserver
import android.view.WindowManager
class MainActivity: FlutterActivity() {
     override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                requestPermissions(arrayOf(Manifest.permission.ACCESS_FINE_LOCATION), 0);
            }
        }
    }
}