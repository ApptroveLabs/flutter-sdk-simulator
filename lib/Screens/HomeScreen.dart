import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Models/Product.dart';
import 'ProductDetailScreen.dart';
import 'WishlistScreen.dart';
import 'LoginScreen.dart';
import 'SignupScreen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:apptrove_sdk_flutter/apptrovefluttersdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Utils/DeveloperTools.dart';

class EventsTrackingScreen extends StatefulWidget {
  @override
  _EventsTrackingScreenState createState() => _EventsTrackingScreenState();
}

class _EventsTrackingScreenState extends State<EventsTrackingScreen> {
  String selectedCategory = 'All';
  String searchQuery = '';
  final PageController _pageController = PageController(viewportFraction: 0.9);
  DateTime? lastPressed;

  // Simulated banners
  final List<String> banners = [
    'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?auto=format&fit=crop&q=80&w=2000',
    'https://images.unsplash.com/photo-1607082350899-7e105aa886ae?auto=format&fit=crop&q=80&w=2000',
    'https://images.unsplash.com/photo-1441986300917-64674bd600d8?auto=format&fit=crop&q=80&w=2000',
  ];

  @override
  Widget build(BuildContext context) {
    List<Product> displayedProducts = PreloadedProducts.products.where((p) {
      final matchesCategory = selectedCategory == 'All' || p.category == selectedCategory;
      final matchesSearch = p.name.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    List<String> categories = ['All'] + PreloadedProducts.products.map((p) => p.category).toSet().toList();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        
        final now = DateTime.now();
        final maxDuration = const Duration(seconds: 2);
        final isWarning = lastPressed == null || now.difference(lastPressed!) > maxDuration;

        if (isWarning) {
          lastPressed = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Press back again to exit'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          // Exit App
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Flutmarket',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1),
        ),
        backgroundColor: Colors.indigoAccent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => WishlistScreen()));
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {
                  Navigator.pushNamed(context, '/addtocart');
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  constraints: BoxConstraints(minWidth: 14, minHeight: 14),
                  child: Text('2', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                ),
              )
            ],
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigoAccent, Colors.indigo.shade800],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: SvgPicture.asset(
                      'Image/flutmarket_icon_logo.svg',
                      height: 45,
                      width: 45,
                      colorFilter: ColorFilter.mode(Colors.indigoAccent, BlendMode.srcIn),
                    ),
                  ),
                  SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                    },
                    child: Text(
                      'Sign In / Register',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home_outlined, color: Colors.indigoAccent, size: 28),
              title: Text('Home', style: TextStyle(fontSize: 16)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.favorite_outline, color: Colors.indigoAccent, size: 28),
              title: Text('My Wishlist', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => WishlistScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_bag_outlined, color: Colors.indigoAccent, size: 28),
              title: Text('My Orders', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No past orders found.')));
              },
            ),
            ListTile(
              leading: Icon(Icons.share_outlined, color: Colors.indigoAccent, size: 28),
              title: Text('Share Flutmarket', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                Share.share('Check out Flutmarket! The best premium shopping app.\nDownload now: https://flutmarket.page.link/download');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.policy_outlined, color: Colors.indigoAccent, size: 28),
              title: Text('Privacy Policy', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                _showPolicyDialog(context, 'Privacy Policy', '''
Privacy Policy for Flutmarket

At Flutmarket, accessible from our mobile application, one of our main priorities is the privacy of our visitors. This Privacy Policy document contains types of information that is collected and recorded by Flutmarket and how we use it.

1. Information We Collect
We collect data through SDKs like Apptrove, CleverTap, and WebEngage to provide personalized features and track attribution.

2. How we use your information
We use the information we collect in various ways, including to:
- Provide, operate, and maintain our app
- Improve, personalize, and expand our app
- Understand and analyze how you use our app
- Communicating with you for customer service
- Provide you with advertising experiences via CleverTap

3. Data Safety
We ensure your data is encrypted during transmission. You can request data deletion at any time by contacting our support.
''');
              },
            ),
            ListTile(
              leading: Icon(Icons.description_outlined, color: Colors.indigoAccent, size: 28),
              title: Text('Terms & Conditions', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                _showPolicyDialog(context, 'Terms & Conditions', 'By using Flutmarket, you agree to comply with our e-commerce regulations.');
              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline, color: Colors.indigoAccent, size: 28),
              title: Text('About Us', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                _showAboutDialog(context);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.redAccent, size: 28),
              title: Text('Logout', style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold)),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false);
                Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              color: Colors.indigoAccent,
              padding: EdgeInsets.fromLTRB(16, 10, 16, 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
                  ],
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    prefixIcon: Icon(Icons.search, color: Colors.indigoAccent),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),
          ),
          if (searchQuery.isEmpty)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Container(
                    height: 180,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: banners.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: NetworkImage(banners[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                colors: [Colors.black54, Colors.transparent],
                                begin: Alignment.bottomLeft,
                                end: Alignment.center,
                              ),
                            ),
                            padding: EdgeInsets.all(20),
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              index == 0 ? "Winter Sale - 50% Off" : 
                              index == 1 ? "New Arrivals" : "Exclusive Bundles",
                              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Shop by Category",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: categories.map((category) {
                        bool isSelected = category == selectedCategory;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: ChoiceChip(
                            label: Text(category),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                selectedCategory = category;
                              });
                            },
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            selectedColor: Colors.indigoAccent,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.indigoAccent.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.indigoAccent.shade100, width: 1),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Trending Products",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: displayedProducts.isEmpty
                ? SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Text("No products found.", style: TextStyle(color: Colors.grey, fontSize: 16)),
                      ),
                    ),
                  )
                : SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = displayedProducts[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailScreen(product: product),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: Offset(0, 5),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                        child: Image.network(
                                          product.imageUrl,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            color: Colors.grey[200],
                                            child: Icon(Icons.image, size: 50, color: Colors.grey[400]),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Column(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: Colors.white.withOpacity(0.9),
                                              radius: 16,
                                              child: Icon(Icons.favorite_border, size: 18, color: Colors.redAccent),
                                            ),
                                            SizedBox(height: 8),
                                            GestureDetector(
                                              onTap: () async {
                                                try {
                                                  final dynamicLink = await AppTroveFlutterSdk.createDynamicLink(
                                                    templateId: 'wy23Px',
                                                    link: 'https://apptrove58.u9ilnk.me',
                                                    domainUriPrefix: 'apptrove58.u9ilnk.me',
                                                    deepLinkValue: 'ProductDetail',
                                                    sdkParameters: {
                                                      'product_id': product.id.toString(),
                                                    },
                                                    socialMeta: {
                                                      'title': product.name,
                                                      'description': 'Check this out on Flutmarket!',
                                                      'imageLink': product.imageUrl,
                                                    },
                                                  );
                                                  Share.share('Check out ${product.name} on Flutmarket!\n$dynamicLink');
                                                } catch (e) {
                                                  Share.share('Check out ${product.name} on Flutmarket!\n\$${product.price}');
                                                }
                                              },
                                              child: CircleAvatar(
                                                backgroundColor: Colors.white.withOpacity(0.9),
                                                radius: 16,
                                                child: Icon(Icons.share, size: 18, color: Colors.indigoAccent),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.name,
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              product.category,
                                              style: TextStyle(color: Colors.grey[500], fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "\$${product.price.toStringAsFixed(2)}",
                                              style: TextStyle(
                                                color: Colors.indigoAccent.shade700,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.indigoAccent,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              padding: EdgeInsets.all(4),
                                              child: Icon(Icons.add_shopping_cart, color: Colors.white, size: 16),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: displayedProducts.length,
                    ),
                  ),
          ),
        ],
      ),
    ),
  );
}

  void _showPolicyDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(content),
        actions: [
          TextButton(
            child: Text('Understood', style: TextStyle(color: Colors.indigoAccent)),
            onPressed: () => Navigator.pop(ctx),
          ),
        ],
      )
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            SvgPicture.asset(
              'Image/flutmarket_icon_logo.svg',
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(Colors.indigoAccent, BlendMode.srcIn),
            ),
            SizedBox(width: 10),
            Text('About Flutmarket', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Flutmarket is a premium e-commerce platform offering the best products directly to you with top-tier user experience.'),
            SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                HiddenDeveloperTools.processTap(context);
              },
              child: Container(
                color: Colors.transparent,
                child: Text(
                  'Version: 1.0.0 (Build 98)',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigoAccent),
            child: Text('Close', style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.pop(ctx),
          ),
        ],
      )
    );
  }
}
