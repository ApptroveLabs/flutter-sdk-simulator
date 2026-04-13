import 'package:flutter/material.dart';

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
      'icon': Icons.storefront,
      'title': 'Thousands of Products',
      'subtitle': 'Shop from our curated collection of premium products across all categories.',
      'color1': Colors.indigoAccent,
      'color2': Colors.purple,
    },
    {
      'icon': Icons.local_shipping_outlined,
      'title': 'Fast & Free Delivery',
      'subtitle': 'Get your orders delivered in 3-5 business days. Free shipping on orders over \$500.',
      'color1': Colors.teal,
      'color2': Colors.green,
    },
    {
      'icon': Icons.security_outlined,
      'title': 'Safe & Secure Payments',
      'subtitle': 'Shop with confidence. All transactions are encrypted and 100% secure.',
      'color1': Colors.orange,
      'color2': Colors.deepOrange,
    },
  ];

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
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      (page['color1'] as Color).withOpacity(0.15),
                      Colors.white,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      SizedBox(height: 80),
                      Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [page['color1'] as Color, page['color2'] as Color],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (page['color1'] as Color).withOpacity(0.3),
                              blurRadius: 30,
                              offset: Offset(0, 15),
                            ),
                          ],
                        ),
                        child: Icon(page['icon'] as IconData, color: Colors.white, size: 90),
                      ),
                      SizedBox(height: 70),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: [
                            Text(
                              page['title'] as String,
                              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.black87),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            Text(
                              page['subtitle'] as String,
                              style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.6),
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
                          widget.onComplete();
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
                      onPressed: widget.onComplete,
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
