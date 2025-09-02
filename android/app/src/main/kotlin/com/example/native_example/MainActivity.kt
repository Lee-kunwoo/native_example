package com.example.native_example // 패키지 이름 수정 (오타 수정)

import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import android.util.Base64

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.flutter.dev/info"
    private val CHANNEL2 = "com.flutter.dev/encryto"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getDeviceInfo") {
                    val deviceInfo = getDeviceInfo()
                    result.success(deviceInfo)
                } else {
                    result.notImplemented()
                }
            }

        // Encoding/decoding channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL2)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getEncryto" -> {
                        val text = call.arguments as String
                        val encodedText = Base64.encodeToString(text.toByteArray(), Base64.DEFAULT)
                        result.success(encodedText)
                    }
                    "getDecode" -> {
                        val encodedText = call.arguments as String
                        try {
                            val decodedBytes = Base64.decode(encodedText, Base64.DEFAULT)
                            val decodedText = String(decodedBytes)
                            result.success(decodedText)
                        } catch (e: IllegalArgumentException) {
                            result.error("DECODE_ERROR", "Invalid Base64 data", e.message)
                        }
                    }
                    else -> result.notImplemented()
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