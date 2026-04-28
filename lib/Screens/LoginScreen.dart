import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'SignupScreen.dart';
import 'HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apptrove_sdk_flutter/apptrovefluttersdk.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:apptrove_sdk_flutter/apptroveevent.dart';
import '../Utils/AppTroveEvents.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  void _login() async {
    // Simulated login logic
    if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userEmail', _emailController.text);
      
      // Track user identity in AppTrove SDK
      AppTroveFlutterSdk.setUserEmail(_emailController.text);
      String userId = _emailController.text.split('@')[0];
      AppTroveFlutterSdk.setUserId(userId);
      
      // Sync identity with RevenueCat
      try {
        await Purchases.logIn(userId);
      } catch (e) {
        debugPrint("RevenueCat Login Error: $e");
      }
      
      // Track Login Event
      AppTroveEvent loginEvent = AppTroveEvent(AppTroveEvents.LOGIN);
      loginEvent.param1 = _emailController.text;
      loginEvent.param2 = "email_login";
      AppTroveFlutterSdk.trackEvent(loginEvent);
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EventsTrackingScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter email and password")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 100),
              Center(
                child: SvgPicture.asset(
                  'Image/flutmarket_icon_logo.svg',
                  height: 120,
                  width: 120,
                ),
              ),
              SizedBox(height: 40),
              Text(
                "Welcome Back!",
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                "Sign in to continue shopping",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 40),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email Address",
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text("Forgot Password?"),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigoAccent,
                    padding: EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    "Login",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('isLoggedIn', true);
                    await prefs.setString('userEmail', 'guest@flutmarket.com');
                    
                    AppTroveFlutterSdk.setUserId("guest_user");
                    AppTroveFlutterSdk.setUserName("Guest User");
                    AppTroveFlutterSdk.setUserEmail("guest@flutmarket.com");

                    // Sync identity with RevenueCat
                    try {
                      await Purchases.logIn("guest_user");
                    } catch (e) {
                      debugPrint("RevenueCat Guest Login Error: $e");
                    }
                    
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => EventsTrackingScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 18),
                    side: BorderSide(color: Colors.indigoAccent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    "Continue as Guest",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.indigoAccent,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupScreen()),
                      );
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.indigoAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
