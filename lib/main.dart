import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_simulator/Screens/HomeScreen.dart';
import 'package:flutter_simulator/Screens/SplashScreen.dart';
import 'package:trackier_sdk_flutter/trackierconfig.dart';
import 'package:trackier_sdk_flutter/trackierfluttersdk.dart';
import 'package:trackier_sdk_flutter/trackierevent.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'apple_search_ads_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

import 'package:app_links/app_links.dart';
import 'Screens/BuildinEventScreen.dart';
import 'Screens/CustomEventsScreen.dart';
import 'Screens/DeepLinkScreen.dart';
import 'Screens/ProductPageScreen.dart';
import 'Screens/AddToCartScreen.dart';
import 'Screens/CakeScreen.dart';
import 'Screens/DynamicLinkScreen.dart';
import 'Screens/CampaignDataScreen.dart';

// Global navigator key for navigation from deferred deep link callback
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Flag to prevent multiple navigation attempts
bool _hasNavigatedFromDeepLink = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Load the environment variables from the .env file
  await dotenv.load();

  runApp(MyApp());
  
  // Initialize SDKs after the app is running
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _initializeSDKs();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      home: SplashScreen(),
      routes: {
        '/builtInEvents': (context) => BuiltInEventsScreen(),
        '/customsEvents': (context) => CustomsEventsScreen(),
        '/deepLinking': (context) => DeepLinkingScreen(),
        '/productPage': (context) => ProductPageScreen(),
        '/addtocart': (context) => AddToCartScreen(),
        '/cakeActivity': (context) => CakeScreen(),
        '/dynamicLink': (context) => DynamicLinkScreen(),
        '/campaignData': (context) => CampaignDataScreen(),
      },
    );
  }
}

// Function to handle navigation from deferred deep link callback
void _navigateFromDeferredDeepLink(String uri) {
  print('Navigating from deferred deep link: $uri');
  
  if (uri.isNotEmpty) {
    try {
      final Uri resolvedUri = Uri.parse(uri);
      final String? dlv = resolvedUri.queryParameters['dlv'];
      final String? cakename = resolvedUri.queryParameters['cakename'];
      final String? price = resolvedUri.queryParameters['price'];
      final String? clickedApptroveLink = resolvedUri.queryParameters['clicked_apptrove_link'];
      
      print('Navigating with parameters:');
      print('  dlv: $dlv');
      print('  cakename: $cakename');
      print('  price: $price');
      print('  clicked_apptrove_link: $clickedApptroveLink');
      
      // Check if navigator is ready
      if (navigatorKey.currentState == null) {
        print('Navigator not ready yet, retrying in 500ms...');
        Future.delayed(Duration(milliseconds: 500), () {
          _navigateFromDeferredDeepLink(uri);
        });
        return;
      }
      
      // Navigate to appropriate screen based on dlv
      if (dlv != null) {
        switch (dlv) {
          case 'blueberrycupcake':
            navigatorKey.currentState?.pushReplacement(
              MaterialPageRoute(
                builder: (context) => CakeScreen(
                  productId: cakename ?? 'blueberry',
                  quantity: '1',
                  actionData: null,
                  dlv: dlv,
                  price: price,
                ),
              ),
            );
            break;
          case 'chocochipcupcake':
            navigatorKey.currentState?.pushReplacement(
              MaterialPageRoute(
                builder: (context) => CakeScreen(
                  productId: cakename ?? 'chocochip',
                  quantity: '1',
                  actionData: null,
                  dlv: dlv,
                  price: price,
                ),
              ),
            );
            break;
          case 'vanillaccupake':
            navigatorKey.currentState?.pushReplacement(
              MaterialPageRoute(
                builder: (context) => CakeScreen(
                  productId: cakename ?? 'vanilla',
                  quantity: '1',
                  actionData: null,
                  dlv: dlv,
                  price: price,
                ),
              ),
            );
            break;
          default:
            // Default to CakeScreen with available parameters
            navigatorKey.currentState?.pushReplacement(
              MaterialPageRoute(
                builder: (context) => CakeScreen(
                  productId: cakename ?? 'default',
                  quantity: '1',
                  actionData: null,
                  dlv: dlv,
                  price: price,
                ),
              ),
            );
            break;
        }
      } else {
        // If no dlv, navigate to home screen instead of deep link screen
        print('No dlv parameter, navigating to home screen');
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (context) => EventsTrackingScreen()),
        );
      }
    } catch (e) {
      print('Error navigating from deferred deep link: $e');
      // Fallback to home screen
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (context) => EventsTrackingScreen()),
      );
    }
  }
}

void _initializeSDKs() async {
  try {
    // Get the environment variables directly from dotenv
    final trDevKey = dotenv.env['TR_DEV_KEY'] ?? "default_value";
    final secretId = dotenv.env['SECRET_ID'] ?? "default_value";
    final secretKey = dotenv.env['SECRET_KEY'] ?? "default_value";

    final trackerSDKConfig = TrackerSDKConfig(trDevKey, "development");

    trackerSDKConfig.setFacebookAppId("234234"); // Only for android Users Read docs for details

    // Use this for secure Install and event Body

    // trackerSDKConfig.setAppId("MYcJ6a79MQ"); // Get from Panel
    // trackerSDKConfig.setEncryptionKey("sBxN9FYzeBmYBxk/kBUZsihP3WAG7WvM0QG2KLesJoU="); // Get from Panel
    // trackerSDKConfig.setEncryptionType(TrackierEncryptionType.AES_GCM);

    // Set user details
    Trackierfluttersdk.setUserId("009013452535353");
    Trackierfluttersdk.setUserEmail("sanu@gmail.com");
    Trackierfluttersdk.setUserName("SanuTest");
    Trackierfluttersdk.setUserPhone("8130300721");

    // Set app secrets
    trackerSDKConfig.setAppSecret(secretId,secretKey);



    // Deferred Deep Link Callback - Must be set BEFORE SDK initialization
    trackerSDKConfig.deferredDeeplinkCallback = (uri) {
      print('The value of deeplinkUrl is: $uri');
      
      // Prevent multiple navigation attempts
      if (_hasNavigatedFromDeepLink) {
        print('Already navigated from deep link, ignoring subsequent callbacks');
        return;
      }



      // Parse the resolved deep link and extract parameters
      if (uri != null && uri.isNotEmpty) {
        try {
          final Uri resolvedUri = Uri.parse(uri);
          final String? dlv = resolvedUri.queryParameters['dlv'];
          final String? cakename = resolvedUri.queryParameters['cakename'];
          final String? price = resolvedUri.queryParameters['price'];
          final String? clickedApptroveLink = resolvedUri.queryParameters['clicked_apptrove_link'];
          
          print('Resolved deep link parameters:');
          print('  dlv: $dlv');
          print('  cakename: $cakename');
          print('  price: $price');
          print('  clicked_apptrove_link: $clickedApptroveLink');
          
          // Only navigate if we have a valid dlv parameter (not just referrer data)
          if (dlv != null && dlv.isNotEmpty) {
            _hasNavigatedFromDeepLink = true;
            // Navigate to appropriate screen based on deep link parameters
            // Add a small delay to ensure the app is fully loaded
            Future.delayed(Duration(milliseconds: 1000), () {
              _navigateFromDeferredDeepLink(uri);
            });
          } else {
            print('No valid dlv parameter found, skipping navigation');
          }
        } catch (e) {
          print('Error parsing resolved deep link: $e');
        }
      }
    };



    // Apple Ads Attribution Token - Must be called BEFORE SDK initialization
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      try {
        // First, request App Tracking Transparency permission
        print("Requesting App Tracking Transparency permission...");
        final bool authorized = await AppleSearchAdsHelper.requestTrackingAuthorization();
        if (authorized) {
          print("ATT permission granted, proceeding with Apple Ads token retrieval...");
          
          // Get Apple Ads Attribution Token
          print("Attempting to get Apple Ads Attribution Token...");
          final token = await AppleSearchAdsHelper.getAttributionToken();
          if (token != null && token.isNotEmpty) {
            print('Apple Ads Token received: $token');
            Trackierfluttersdk.updateAppleAdsToken(token);
            print("Apple Ads Token updated successfully.");
          } else {
            print('Apple Ads Token is empty or null');
          }
        } else {
          print("ATT permission denied, skipping Apple Ads token retrieval");
        }
      } catch (error) {
        print('Error with Apple Ads attribution: $error');
        // Continue with SDK initialization even if Apple Ads token fails
      }
    } else {
      print("Not iOS platform, skipping Apple Ads token retrieval");
    }

    // Initialize Trackier SDK
    Trackierfluttersdk.initializeSDK(trackerSDKConfig);
    print("Trackier SDK initialized successfully.");

    // Initialize deep link listener after SDK is initialized
    _initDeepLinkListener();

    _initializeFCM();

    // Set Trackier ID as Firebase user property for uninstall tracking
    await _setTrackierUserProperty();

    // Trigger app open event after SDK initialization this is completed event parameter for demo
    _trackAppOpen();
  } catch (e) {
    print("Error initializing Trackier SDK: $e");
  }
}

// Initialize deep link listener after SDK is initialized
// Listen for incoming URLs and send to Trackier SDK
void _initDeepLinkListener() {
  final appLinks = AppLinks();
  
  // Listen for incoming links and send to Trackier SDK
  appLinks.uriLinkStream.listen((Uri? uri) {
    if (uri != null) {
      print('Applink incoming url: ${uri.toString()}');
      Trackierfluttersdk.parseDeeplink(uri.toString());
    }else{
      // Subscribe to attribution link for deferred deep links (iOS only)
      if (Platform.isIOS) {
        Trackierfluttersdk.subscribeAttributionlink();
      }
    }
  }, onError: (err) {
    print('Error listening to deep links: $err');
  });


  // For Testing purpose Send direcly
  // Parse deep link before SDK initialization for test send the test url or get the link from app launch and send to parsedeeplink function
  // const String testDeepLink = 'https://trackier58.u9ilnk.me/d/iOhRy6hQMG';
  // print('Parsing deep link after SDK initialization: $testDeepLink');
  // Trackierfluttersdk.parseDeeplink(testDeepLink);
}


/// Track app open event with complete registration example
void _trackAppOpen() {
  try {

    // Create event with COMPLETE_REGISTRATION ID (String) or Custom Event ID
    TrackierEvent event = TrackierEvent(TrackierEvent.COMPLETE_REGISTRATION);
    // Alternatively: TrackierEvent event = TrackierEvent("w43424"); // Pass your Custom Event ID

    // Built-in fields for event tracking
    event.orderId = "REG_001";         // String: Unique registration ID
    event.couponCode = "";             // String: No coupon used (empty for free plan)
    event.discount = 0.0;              // double: No discount applied
    event.revenue = 0.0;               // double: No revenue (free signup)
    event.currency = "USD";            // String: Currency code
    event.productId = "23434234";      // string : Add product id

    // Custom parameters for structured data
    // Data type: String - You can add any string value here
    event.param1 = "Test1";     // String: Dummy value
    event.param2 = "Test2";     // String: Dummy value
    event.param3 = "Test3";     // String: Dummy value
    event.param4 = "Test4";     // String: Dummy value
    event.param5 = "Test5";     // String: Dummy value
    event.param6 = "Test6";     // String: Dummy value
    event.param7 = "Test7";     // String: Dummy value
    event.param8 = "Test8";     // String: Dummy value
    event.param9 = "Test9";     // String: Dummy value
    event.param10 = "Test10";   // String: Dummy value

    // Custom key-value pairs for flexible data (Map<String, Object>)
    event.setEventValue("signup_time", 1631234567890); // int: Timestamp
    event.setEventValue("device", "Flutter");           // String: Device type

    // Set user details in Trackier SDK
    Trackierfluttersdk.setUserId("USER123");              // String: User ID
    Trackierfluttersdk.setUserEmail("user@example.com");  // String: User email
    Trackierfluttersdk.setUserName("Jane Doe");           // String: User name
    Trackierfluttersdk.setUserPhone("+1234567890");       // String: User phone
    Trackierfluttersdk.setDOB("1990-01-01");              // String: Date of birth (YYYY-MM-DD)
    Trackierfluttersdk.setGender(Gender.Male);            // Gender: Male, Female, or Others
    Trackierfluttersdk.setIMEI("123456789012345", "987654321098765"); // String, String: Device IMEI
    Trackierfluttersdk.setMacAddress("00:1A:2B:3C:4D:5E"); // String: Device MAC address

    //Passing the custom params in events be like below example
    var eventCustomParams = Map<String, Object>();
    eventCustomParams={"name":"abcd"};
    eventCustomParams={"age":"28"};
    event.evMap=eventCustomParams;

    // Additional user details (Map)
    Map<String, Object> userDetails = {
      "Plan": "FREE_PLAN",
      "SignupMethod": "Email",
      "AppVersion": "1.0.0",
    };

    Trackierfluttersdk.setUserAdditonalDetail(userDetails);

    // Send the event to Apptrove
    Trackierfluttersdk.trackEvent(event);
    print("App open event tracked successfully.");
  } catch (error) {
    print("Error tracking app open event: $error");
  }
}

/// Set Trackier ID as Firebase user property for uninstall tracking Through Firebase Analytics
Future<void> _setTrackierUserProperty() async {
  try {
    print("Setting Trackier ID as Firebase user property...");
    final analytics = FirebaseAnalytics.instance;
    final trackierId = await Trackierfluttersdk.getTrackierId();

    if (trackierId.isNotEmpty) {
      await analytics.setUserProperty(name: "ct_objectId", value: trackierId);
      print("Trackier ID set as Firebase user property: $trackierId");
    } else {
      print("Trackier ID is null or empty, skipping Firebase user property");
    }
  } catch (error) {
    print("Error setting Trackier user property: $error");
    // Continue execution even if Firebase user property fails
  }
}

/// Initialize Firebase Cloud Messaging
Future<void> _initializeFCM() async {
  try {

    // Listen for token refresh and send to Trackier SDK For Uninstall trackier through FCM
    FirebaseMessaging.instance.onTokenRefresh.listen((String token) {
      print('FCM Token refreshed: $token');
      Trackierfluttersdk.sendFcmToken(token);
    });
  } catch (e) {
    print('Error initializing FCM: $e');
  }
}
