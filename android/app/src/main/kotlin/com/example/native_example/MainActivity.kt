package com.example.native_example // 패키지 이름 수정 (오타 수정)

import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.flutter.dev/info"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getDeviceInfo") {
                    val deviceInfo = getDeviceInfo()
                    if (deviceInfo.isNotEmpty()) {
                        result.success(deviceInfo)
                    } else {
                        result.error("EMPTY_DATA", "No device info available", null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun getDeviceInfo(): String {
        val sb = StringBuffer()
        sb.append("Device: ${Build.DEVICE ?: "Unknown"}\n")
        sb.append("Brand: ${Build.BRAND ?: "Unknown"}\n")
        sb.append("Model: ${Build.MODEL ?: "Unknown"}\n")
        return sb.toString()
    }
}