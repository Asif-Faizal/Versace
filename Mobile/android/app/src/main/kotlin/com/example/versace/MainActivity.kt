package com.example.versace

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.provider.Settings
import android.os.Build
import org.json.JSONObject

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.versace/device"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getDeviceInfo") {
                val deviceInfo = JSONObject().apply {
                    put("deviceId", Settings.Secure.getString(contentResolver, Settings.Secure.ANDROID_ID))
                    put("model", Build.MODEL)
                    put("manufacturer", Build.MANUFACTURER)
                    put("os", "Android")
                    put("osVersion", Build.VERSION.RELEASE)
                }.toString()
                result.success(deviceInfo)
            } else {
                result.notImplemented()
            }
        }
    }
}
