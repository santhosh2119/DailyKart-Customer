package com.mspiron.shopinngo
import android.content.Context
import androidx.annotation.NonNull
import androidx.multidex.MultiDex
import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;

import androidx.core.content.ContextCompat.getSystemService

class App : FlutterApplication()  ,PluginRegistrantCallback {
    override fun attachBaseContext(base: Context) {
        super.attachBaseContext(base)
        MultiDex.install(this)
    }
    override fun onCreate() {
        super.onCreate()
       // FlutterFirebaseMessagingService.setPluginRegistrant(this)
    }

    override fun registerWith(registry: PluginRegistry) {
       // FirebaseCloudMessagingPluginRegistrant.registerWith(registry);
        //FirebaseMessagingPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
        //registry.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin");

    }
}

