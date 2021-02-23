package io.flutter.plugins;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry;

/**
 * Generated file. Do not edit.
 * This file is generated by the Flutter tool based on the
 * plugins that support the Android platform.
 */
@Keep
public final class GeneratedPluginRegistrant {
  public static void registerWith(@NonNull FlutterEngine flutterEngine) {
    ShimPluginRegistry shimPluginRegistry = new ShimPluginRegistry(flutterEngine);
      io.flutter.plugins.firebase.cloudfirestore.CloudFirestorePlugin.registerWith(shimPluginRegistry.registrarFor("io.flutter.plugins.firebase.cloudfirestore.CloudFirestorePlugin"));
      io.flutter.plugins.firebaseauth.FirebaseAuthPlugin.registerWith(shimPluginRegistry.registrarFor("io.flutter.plugins.firebaseauth.FirebaseAuthPlugin"));
      io.flutter.plugins.firebase.core.FirebaseCorePlugin.registerWith(shimPluginRegistry.registrarFor("io.flutter.plugins.firebase.core.FirebaseCorePlugin"));
      xyz.altercode.fluttersearchpanel.FlutterSearchPanelPlugin.registerWith(shimPluginRegistry.registrarFor("xyz.altercode.fluttersearchpanel.FlutterSearchPanelPlugin"));
      io.flutter.plugins.googlesignin.GoogleSignInPlugin.registerWith(shimPluginRegistry.registrarFor("io.flutter.plugins.googlesignin.GoogleSignInPlugin"));
      com.lyokone.location.LocationPlugin.registerWith(shimPluginRegistry.registrarFor("com.lyokone.location.LocationPlugin"));
      com.ethras.simplepermissions.SimplePermissionsPlugin.registerWith(shimPluginRegistry.registrarFor("com.ethras.simplepermissions.SimplePermissionsPlugin"));
      bz.rxla.flutter.speechrecognition.SpeechRecognitionPlugin.registerWith(shimPluginRegistry.registrarFor("bz.rxla.flutter.speechrecognition.SpeechRecognitionPlugin"));
      com.blounty.tts.TtsPlugin.registerWith(shimPluginRegistry.registrarFor("com.blounty.tts.TtsPlugin"));
  }
}
