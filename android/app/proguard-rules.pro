-dontwarn me.pushy.**
-keep class me.pushy.** { *; }
-keep class androidx.core.app.** { *; }
-keep class android.support.v4.app.** { *; }
-keep class org.jivesoftware.** { *; }
-keep class org.xmlpull.** { *; }
-keep class org.bouncycastle.jcajce.provider.** { *; }
-keep class org.videolan.libvlc.** { *; }
-keep class ai.onnxruntime.** { *; }

## Flutter WebRTC
-keep class com.cloudwebrtc.webrtc.** { *; }
-keep class org.webrtc.** { *; }

## Method Channel and Audio Manager
-keep class com.irveni.admin.MainActivity { *; }
-keep class android.media.AudioManager { *; }
-keep class io.flutter.plugin.common.MethodChannel { *; }
-keep class io.flutter.embedding.engine.FlutterEngine { *; }