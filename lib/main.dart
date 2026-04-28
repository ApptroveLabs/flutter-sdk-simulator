import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_simulator/Screens/HomeScreen.dart';
import 'package:flutter_simulator/Screens/SplashScreen.dart';
import 'package:flutter_simulator/Screens/ProductDetailScreen.dart';
import 'package:flutter_simulator/Models/Product.dart';
import 'package:apptrove_sdk_flutter/apptroveconfig.dart';
import 'package:app_links/app_links.dart';
import 'package:apptrove_sdk_flutter/apptrovefluttersdk.dart';
import 'package:apptrove_sdk_flutter/apptroveevent.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'apple_search_ads_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

import 'Screens/BuildinEventScreen.dart';
import 'Screens/CustomEventsScreen.dart';
import 'Screens/DeepLinkScreen.dart';
import 'Screens/ProductPageScreen.dart';
import 'Screens/AddtoCartScreen.dart';
import 'Screens/CakeScreen.dart';
import 'Screens/DynamicLinkScreen.dart';
import 'Screens/CampaignDataScreen.dart';

// Global navigator key for navigation from deferred deep link callback
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Flag to prevent multiple navigation attempts
bool _hasNavigatedFromDeepLink = false;

void main() async {
  // Catch all Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint("Flutter Error: ${details.exception}");
  };

  // Catch all asynchronous Dart errors
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint("Async Error: $error");
    return true; // Prevent the app from crashing
  };

  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Firebase safely
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initialization error: $e");
  }

  // 2. Load the environment variables safely
  try {
    await dotenv.load(isOptional: true);
  } catch (e) {
    debugPrint("DotEnv loading error: $e");
  }

  runApp(MyApp());
  
  // Initialize SDKs after the app is running
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    try {
      // Show App Tracking Transparency prompt on iOS safely
      if (Platform.isIOS) {
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
    } catch (e) {
      debugPrint("ATT request error: $e");
    }
    _initializeSDKs();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutmarket',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigoAccent,
          primary: Colors.indigoAccent,
          surface: Colors.white,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigoAccent,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigoAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
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
          case 'ProductDetail':
            final String? productId = resolvedUri.queryParameters['product_id'];
            if (productId != null) {
              final product = PreloadedProducts.products.firstWhere(
                (p) => p.id.toString() == productId,
                orElse: () => PreloadedProducts.products[0],
              );
              navigatorKey.currentState?.push(
                MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product)),
              );
            }
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
    String sdkKey = "";
    String secretId = "";
    String secretKey = "";

    if (Platform.isAndroid) {
      sdkKey = dotenv.env['ANDROID_APPTROVE_SDK_KEY'] ?? "";
      secretId = dotenv.env['ANDROID_APPTROVE_SECRET_ID'] ?? "";
      secretKey = dotenv.env['ANDROID_APPTROVE_SECRET_KEY'] ?? "";
    } else if (Platform.isIOS) {
      sdkKey = dotenv.env['IOS_APPTROVE_SDK_KEY'] ?? "";
      secretId = dotenv.env['IOS_APPTROVE_SECRET_ID'] ?? "";
      secretKey = dotenv.env['IOS_APPTROVE_SECRET_KEY'] ?? "";
    }

    if (sdkKey.isEmpty) {
      debugPrint("CRITICAL WARNING: Apptrove SDK Key is empty (likely due to missing .env file in CI/CD). Aborting SDK initialization to prevent fatal native crash.");
      return;
    }

    final apptroveSDKConfig = AppTroveSDKConfig(sdkKey, "development");

    // Set app secrets for security
    apptroveSDKConfig.setAppSecret(secretId, secretKey);

    // Set user details
    AppTroveFlutterSdk.setUserId("009013452535353");
    AppTroveFlutterSdk.setUserEmail("sanu@gmail.com");
    AppTroveFlutterSdk.setUserName("SanuTest");
    AppTroveFlutterSdk.setUserPhone("8130300721");



    // Deferred Deep Link Callback - Must be set BEFORE SDK initialization

    apptroveSDKConfig.deferredDeeplinkCallback = (deepLinkObj) {
      if (_hasNavigatedFromDeepLink) return;

      print('--- AppTrove Deferred Deep Link Received ---');

      print('The value of deeplinkUrl is: ${deepLinkObj.url}');
      print('isDeferred: ${deepLinkObj.isDeferred}');
      print('deepLinkValue: ${deepLinkObj.deepLinkValue}');
      print('campaign: ${deepLinkObj.campaign}');
      print('campaignId: ${deepLinkObj.campaignId}');
      print('partnerId: ${deepLinkObj.partnerId}');
      print('siteId: ${deepLinkObj.siteId}');
      print('subSiteId: ${deepLinkObj.subSiteId}');
      print('ad: ${deepLinkObj.ad}');
      print('adId: ${deepLinkObj.adId}');
      print('adSet: ${deepLinkObj.adSet}');
      print('adSetId: ${deepLinkObj.adSetId}');
      print('channel: ${deepLinkObj.channel}');
      print('clickId: ${deepLinkObj.clickId}');
      print('message: ${deepLinkObj.message}');
      print('p1-p5: ${deepLinkObj.p1} ${deepLinkObj.p2} ${deepLinkObj.p3} ${deepLinkObj.p4} ${deepLinkObj.p5}');
      print('sdkParams: ${deepLinkObj.sdkParams}');
      
      // 1. Check if we have ANY meaningful marketing data
      String? productId;
      String? productName;
      
      // Extract from SDK Params
      if (deepLinkObj.sdkParams != null) {
        productId = deepLinkObj.sdkParams!['productId'] ?? deepLinkObj.sdkParams!['product_id'] ?? deepLinkObj.sdkParams!['id'];
        productName = deepLinkObj.sdkParams!['productName'] ?? deepLinkObj.sdkParams!['product_name'] ?? deepLinkObj.sdkParams!['name'];
      }

      // 2. Determine if this is a "Marketing Link" vs "Organic"
      bool isMarketingLink = deepLinkObj.sdkParams?['clicked_apptrove_link'] == true || 
                             (deepLinkObj.deepLinkValue != null && deepLinkObj.deepLinkValue!.isNotEmpty);

      // 3. Navigation Decision
      if (productId != null && productId.toString().isNotEmpty) {
        // CASE 1: PRODUCT LINK
        print('Product ID found: $productId. Redirecting to Product Details.');
        _hasNavigatedFromDeepLink = true;
        Future.delayed(Duration(milliseconds: 1500), () => _navigateToProduct(productId, productName));
      } 
      else if (isMarketingLink) {
        // CASE 2: RANDOM MARKETING LINK
        print('Random Marketing link detected. Redirecting to Cake Screen.');
        _hasNavigatedFromDeepLink = true;
        Future.delayed(Duration(milliseconds: 1500), () => _navigateToCakeScreen(deepLinkObj.url));
      } 
      else {
        // CASE 3: ORGANIC INSTALL (Stay on Home Page)
        print('Organic install or no data. Staying on Home Page.');
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
            AppTroveFlutterSdk.updateAppleAdsToken(token);
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

    AppTroveFlutterSdk.waitForATTUserAuthorization(10);

    // Initialize Apptrove SDK
    AppTroveFlutterSdk.initializeSDK(apptroveSDKConfig);
    print("Apptrove SDK initialized successfully.");

    // For iOS Only: Enable deferred deep link functionality
    if (Platform.isIOS) {
      print("Subscribing to Attribution link (iOS)");
      AppTroveFlutterSdk.subscribeAttributionlink();
    }

    // Initialize deep link listener after SDK is initialized
    _initDeepLinkListener();

    _initializeFCM();
    // Initialize push tokens (FCM for Android, APNs for iOS)
    if (Platform.isIOS) {
      await _getAndSendApnsToken();
    }

    // Set Apptrove ID as Firebase user property for uninstall tracking
    await _setApptroveUserProperty();

    // Trigger app open event after SDK initialization this is completed event parameter for demo
    _trackAppOpen();
  } catch (e) {
    print("Error initializing Apptrove SDK: $e");
  }
}

// Initialize deep link listener after SDK is initialized
// Listen for incoming URLs and send to Apptrove SDK
void _initDeepLinkListener() async {
  final appLinks = AppLinks();

  try {
    // 1. Handle the initial link (when app is opened from a closed state)
    final Uri? initialUri = await appLinks.getInitialLink();
    if (initialUri != null) {
      print('Initial Applink: ${initialUri.toString()}');
      AppTroveFlutterSdk.parseDeeplink(initialUri.toString());
    } else {
      // If no initial link, subscribe for deferred deep link (iOS only)
      if (Platform.isIOS) {
        AppTroveFlutterSdk.subscribeAttributionlink();
      }
    }

    // 2. Listen for incoming links while the app is in foreground/background
    appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        print('Foreground Applink: ${uri.toString()}');
        AppTroveFlutterSdk.parseDeeplink(uri.toString());
      }
    }, onError: (err) {
      print('Error listening to deep link stream: $err');
    });
  } catch (e) {
    print('Exception in DeepLink Listener: $e');
  }
}



// Navigation helpers for Deep Linking
void _navigateToCakeScreen(String? url) {
  if (navigatorKey.currentState == null) {
    Future.delayed(Duration(milliseconds: 500), () => _navigateToCakeScreen(url));
    return;
  }
  navigatorKey.currentState?.pushReplacement(
    MaterialPageRoute(builder: (context) => CakeScreen(dlv: 'random_link', actionData: url))
  );
}

void _navigateToProduct(String? id, String? name) {
  if (navigatorKey.currentState == null) {
    Future.delayed(Duration(milliseconds: 500), () => _navigateToProduct(id, name));
    return;
  }

  // Try to find the product in our preloaded list
  final product = PreloadedProducts.products.firstWhere(
    (p) => p.id.toString() == id || p.name.toLowerCase() == name?.toLowerCase(),
    orElse: () => PreloadedProducts.products.first,
  );

  navigatorKey.currentState?.pushReplacement(
    MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product))
  );
}

/// Track app open event with complete registration example
void _trackAppOpen() {
  try {

    // Create event with COMPLETE_REGISTRATION ID (String) or Custom Event ID
    AppTroveEvent event = AppTroveEvent(AppTroveEvent.COMPLETE_REGISTRATION);
    // Alternatively: AppTroveEvent event = AppTroveEvent("w43424"); // Pass your Custom Event ID

    // Built-in fields for event tracking
    event.orderId = "REG_001";         // String: Unique registration ID
    event.couponCode = "coupontest123satyam";             // String: No coupon used (empty for free plan)
    event.discount = 20.0;              // double: No discount applied
    event.revenue = 20.0;               // double: No revenue (free signup)
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

    // Set user details in Apptrove SDK
    AppTroveFlutterSdk.setUserId("USER123");              // String: User ID
    AppTroveFlutterSdk.setUserEmail("user@example.com");  // String: User email
    AppTroveFlutterSdk.setUserName("Jane Doe");           // String: User name
    AppTroveFlutterSdk.setUserPhone("+1234567890");       // String: User phone
    AppTroveFlutterSdk.setDOB("1990-01-01");              // String: Date of birth (YYYY-MM-DD)
    AppTroveFlutterSdk.setGender(Gender.Male);            // Gender: Male, Female, or Others
    AppTroveFlutterSdk.setIMEI("123456789012345", "987654321098765"); // String, String: Device IMEI
    AppTroveFlutterSdk.setMacAddress("00:1A:2B:3C:4D:5E"); // String: Device MAC address

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

    AppTroveFlutterSdk.setUserAdditionalDetails(userDetails);

    // Send the event to Apptrove
    AppTroveFlutterSdk.trackEvent(event);
    print("App open event tracked successfully.");
  } catch (error) {
    print("Error tracking app open event: $error");
  }
}

/// Set Apptrove ID as Firebase user property for uninstall tracking Through Firebase Analytics
Future<void> _setApptroveUserProperty() async {
  try {
    print("Setting Apptrove ID as Firebase user property...");
    final analytics = FirebaseAnalytics.instance;
    final apptroveId = await AppTroveFlutterSdk.getAppTroveId();

    if (apptroveId.isNotEmpty) {
      await analytics.setUserProperty(name: "ct_objectId", value: apptroveId);
      print("Apptrove ID set as Firebase user property: $apptroveId");
    } else {
      print("Apptrove ID is null or empty, skipping Firebase user property");
    }
  } catch (error) {
    print("Error setting Apptrove user property: $error");
    // Continue execution even if Firebase user property fails
  }
}

/// Initialize Firebase Cloud Messaging
Future<void> _initializeFCM() async {
  try {

    // Listen for token refresh and send to Apptrove SDK For Uninstall apptrove through FCM
    FirebaseMessaging.instance.onTokenRefresh.listen((String token) {
      print('FCM Token refreshed: $token');
      AppTroveFlutterSdk.sendFcmToken(token);
    });
  } catch (e) {
    print('Error initializing FCM: $e');
  }
}


/// Get and send APNs token for iOS - with retry logic
/// Requests notification permissions and retrieves APNs token, then sends to Apptrove SDK
Future<void> _getAndSendApnsToken() async {
  if (!Platform.isIOS) {
    print('Not iOS platform, skipping APNs token retrieval');
    return;
  }

  try {
    final messaging = FirebaseMessaging.instance;
    
    // Request notification permissions (required for APNs token on iOS)
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Notification permission granted, getting APNs token...');
    } else {
      print('Notification permission denied: ${settings.authorizationStatus}');
      // Still try to get token even if permission is denied (might work for some cases)
    }

    // Get APNs token with retry logic
    String? apnsToken;
    int retryCount = 0;
    const maxRetries = 3;
    const retryDelay = Duration(seconds: 2);

    while (apnsToken == null && retryCount < maxRetries) {
      try {
        apnsToken = await messaging.getAPNSToken();
        print('APNs Token attempt ${retryCount + 1}: ${apnsToken ?? 'null'}');
      } catch (e) {
        print('Error getting APNs token: $e');
      }

      if (apnsToken == null) {
        retryCount++;
        if (retryCount < maxRetries) {
          print('APNs token not ready, retrying in ${retryDelay.inSeconds}s...');
          await Future.delayed(retryDelay);
        }
      }
    }

    if (apnsToken != null && apnsToken.isNotEmpty) {
      print('Raw APNs Token: $apnsToken');
      AppTroveFlutterSdk.sendAPNToken(apnsToken);
      print('APNs Token sent to Apptrove successfully');
    } else {
      print('Failed to get APNs token after $maxRetries retries (common on simulator; test on device)');
    }
  } catch (e) {
    print('Error getting APNs token: $e');
  }
}
