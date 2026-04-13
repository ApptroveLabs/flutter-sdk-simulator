
package com.apptrove.vistmarket

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel



class MainActivity : FlutterActivity() {
    private val CHANNEL = "deep_link_channel"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleIncomingIntent(intent)
    }

    // Correctly override the onNewIntent method
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent) // Call the superclass method
        handleIncomingIntent(intent) // Handle the new intent
    }

    private fun handleIncomingIntent(intent: Intent?) {
        if (intent?.action == Intent.ACTION_VIEW) {
            val uri: Uri? = intent.data
            uri?.let {
                flutterEngine?.dartExecutor?.binaryMessenger?.let { it1 ->
                    MethodChannel(it1, CHANNEL)
                        .invokeMethod("deep_link_channel", it.toString())
                }
            }
        }
    }
}