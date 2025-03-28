package com.example.birthday_countdown

import android.os.Bundle
import com.getcapacitor.BridgeActivity
import com.getcapacitor.plugin.LocalNotifications
import com.getcapacitor.plugin.Share
import io.flutter.plugin.common.MethodChannel

class MainActivity : BridgeActivity() {
    private val CHANNEL = "com.example.birthdaycountdown/channel"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "scheduleNotification" -> {
                    val title = call.argument<String>("title") ?: "Thông báo"
                    val body = call.argument<String>("body") ?: "Nội dung thông báo"

                    val localNotifications = bridge?.getPlugin(LocalNotifications::class.java)
                    if (localNotifications != null) {
                        val notificationData = JSObject().apply {
                            put("title", title)
                            put("body", body)
                            put("id", 1)
                            put("schedule", JSObject().apply {
                                put("at", System.currentTimeMillis() + 5000) // 5 giây
                            })
                        }

                        localNotifications.call("schedule", notificationData)
                        result.success("Thông báo đã được lên lịch")
                    } else {
                        result.error("ERROR", "LocalNotifications plugin chưa được khởi tạo", null)
                    }
                }

                "shareCountdown" -> {
                    val text = call.argument<String>("text") ?: "Chia sẻ đếm ngược"

                    val sharePlugin = bridge?.getPlugin(Share::class.java)
                    if (sharePlugin != null) {
                        val shareData = JSObject().apply {
                            put("text", text)
                        }
                        sharePlugin.call("share", shareData)
                        result.success("Chia sẻ thành công")
                    } else {
                        result.error("ERROR", "Share plugin chưa được khởi tạo", null)
                    }
                }

                else -> result.notImplemented()
            }
        }
    }
}
