import 'package:flutter/material.dart';
import '../Models/Product.dart';
import 'ProductDetailScreen.dart';
import 'WishlistScreen.dart';
import '../Utils/DeveloperTools.dart';

class EventsTrackingScreen extends StatefulWidget {
  @override
  _EventsTrackingScreenState createState() => _EventsTrackingScreenState();
}

class _EventsTrackingScreenState extends State<EventsTrackingScreen> {
  String selectedCategory = 'All';
  String searchQuery = '';
  final PageController _pageController = PageController(viewportFraction: 0.9);

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

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Vist Market',
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
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/addtocart');
            },
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
                    child: Icon(Icons.person, color: Colors.indigoAccent, size: 45),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Guest User',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
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
            Divider(),
            ListTile(
              leading: Icon(Icons.policy_outlined, color: Colors.indigoAccent, size: 28),
              title: Text('Privacy Policy', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                _showPolicyDialog(context, 'Privacy Policy', 'We collect standard usage data to improve user experience. No personal data is shared with third parties without consent.');
              },
            ),
            ListTile(
              leading: Icon(Icons.description_outlined, color: Colors.indigoAccent, size: 28),
              title: Text('Terms & Conditions', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                _showPolicyDialog(context, 'Terms & Conditions', 'By using Vist Market, you agree to comply with our e-commerce regulations.');
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
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white.withOpacity(0.9),
                                          radius: 16,
                                          child: Icon(Icons.favorite_border, size: 18, color: Colors.redAccent),
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
            Icon(Icons.storefront, color: Colors.indigoAccent),
            SizedBox(width: 10),
            Text('About Vist Market', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vist Market is a premium e-commerce platform offering the best products directly to you with top-tier user experience.'),
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
