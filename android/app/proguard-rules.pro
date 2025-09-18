# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

# Trackier SDK ProGuard Rules
-keep class com.trackier.sdk.** { *; }

# Google Play Services ProGuard Rules
-keep class com.google.android.gms.common.ConnectionResult {
    int SUCCESS;
}

# Google Ads Identifier ProGuard Rules
-keep class com.google.android.gms.ads.identifier.AdvertisingIdClient {
    com.google.android.gms.ads.identifier.AdvertisingIdClient$Info getAdvertisingIdInfo(android.content.Context);
}

-keep class com.google.android.gms.ads.identifier.AdvertisingIdClient$Info {
    java.lang.String getId();
    boolean isLimitAdTrackingEnabled();
}

# Android Install Referrer ProGuard Rules
-keep public class com.android.installreferrer.** { *; }

# Kotlin ProGuard Rules
-keep class kotlin.Metadata { *; }
-keep class kotlin.reflect.jvm.internal.** { *; }
-keep class kotlin.** { *; }
-dontwarn kotlin.**

# Flutter ProGuard Rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Firebase ProGuard Rules
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Facebook SDK ProGuard Rules (if using Facebook SDK)
-keep class com.facebook.** { *; }
-dontwarn com.facebook.**

# CleverTap ProGuard Rules (if using CleverTap)
-keep class com.clevertap.** { *; }
-dontwarn com.clevertap.**

# WebEngage ProGuard Rules (if using WebEngage)
-keep class com.webengage.** { *; }
-dontwarn com.webengage.**
