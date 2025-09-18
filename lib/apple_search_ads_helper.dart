import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class AppleSearchAdsHelper {
  static const MethodChannel _channel = MethodChannel('apple_search_ads');

  /// Get Apple Search Ads attribution token
  static Future<String?> getAttributionToken() async {
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      print('Apple Search Ads attribution is only available on iOS');
      return null;
    }

    try {
      final String? token = await _channel.invokeMethod('getAttributionToken');
      return token;
    } on PlatformException catch (e) {
      print('Error getting Apple Search Ads attribution token: ${e.message}');
      return null;
    }
  }

  /// Request App Tracking Transparency authorization
  static Future<bool> requestTrackingAuthorization() async {
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      print('App Tracking Transparency is only available on iOS');
      return false;
    }

    try {
      final bool authorized = await _channel.invokeMethod('requestTrackingAuthorization');
      return authorized;
    } on PlatformException catch (e) {
      print('Error requesting tracking authorization: ${e.message}');
      return false;
    }
  }
}
