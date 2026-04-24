import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:apptrove_sdk_flutter/apptroveevent.dart';
import 'package:apptrove_sdk_flutter/apptrovefluttersdk.dart';
import '../Utils/AppTroveEvents.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const OnboardingScreen({required this.onComplete});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final pages = [
    {
      'icon': Icons.shopping_bag_outlined,
      'title': 'Discover Products',
      'subtitle': 'Explore thousands of premium products at your fingertips.',
    },
    {
      'icon': Icons.local_shipping_outlined,
      'title': 'Fast Delivery',
      'subtitle': 'Enjoy lightning-fast shipping right to your doorstep.',
    },
    {
      'icon': Icons.support_agent_outlined,
      'title': 'Expert Support',
      'subtitle': 'Our customer support team is available 24/7 to help you.',
    },
  ];

  Future<void> _completeOnboarding() async {
    // Track Onboarding Event
    AppTroveEvent onboardingEvent = AppTroveEvent(AppTroveEvents.ONBOARDING);
    onboardingEvent.param1 = "walkthrough_completed";
    AppTroveFlutterSdk.trackEvent(onboardingEvent);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingSeen', true);
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: pages.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final page = pages[index];
              return Container(
                color: Colors.white,
                child: SafeArea(
                  child: Column(
                    children: [
                      SizedBox(height: 100),
                      Icon(
                        page['icon'] as IconData,
                        size: 150,
                        color: Colors.indigoAccent,
                      ),
                      SizedBox(height: 80),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: [
                            Text(
                              page['title'] as String,
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo.shade900,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            Text(
                              page['subtitle'] as String,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey[700],
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Bottom controls
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.fromLTRB(30, 30, 30, 50),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dots indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(pages.length, (index) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        width: _currentPage == index ? 30 : 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? Colors.indigoAccent : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage < pages.length - 1) {
                          _controller.nextPage(duration: Duration(milliseconds: 400), curve: Curves.easeOut);
                        } else {
                          _completeOnboarding();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigoAccent,
                        padding: EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 5,
                        shadowColor: Colors.indigoAccent.shade100,
                      ),
                      child: Text(
                        _currentPage == pages.length - 1 ? "Start Shopping" : "Next",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  if (_currentPage < pages.length - 1)
                    TextButton(
                      onPressed: _completeOnboarding,
                      child: Text("Skip", style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
