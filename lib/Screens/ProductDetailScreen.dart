import 'package:flutter/material.dart';
import 'package:apptrove_sdk_flutter/apptroveevent.dart';
import 'package:apptrove_sdk_flutter/apptrovefluttersdk.dart';
import '../Utils/AppTroveEvents.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Models/Product.dart';
import '../Utils/CartManager.dart';
import 'AddtoCartScreen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  ProductDetailScreen({required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String selectedSize = 'M';
  Color selectedColor = Colors.black;

  @override
  void initState() {
    super.initState();
    // Track product view event
    AppTroveEvent appTroveEvent = AppTroveEvent(AppTroveEvents.PRODUCT_VIEW);
    appTroveEvent.param1 = "Product Viewed";
    appTroveEvent.param2 = widget.product.name;
    appTroveEvent.param3 = widget.product.category;
    appTroveEvent.productId = widget.product.id.toString();
    appTroveEvent.orderId = "VistMarket_${widget.product.id}";
    AppTroveFlutterSdk.trackEvent(appTroveEvent);
  }

  void _addToCart() {
    // Track add to cart event
    AppTroveEvent appTroveEvent = AppTroveEvent(AppTroveEvents.ADD_TO_CART);
    appTroveEvent.param1 = "Product Added to cart";
    appTroveEvent.param2 = widget.product.name;
    appTroveEvent.productId = widget.product.id.toString();
    appTroveEvent.revenue = widget.product.price;
    appTroveEvent.currency = "USD";
    appTroveEvent.param4 = selectedSize; 
    AppTroveFlutterSdk.trackEvent(appTroveEvent);

    CartManager().addItem(widget.product);

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(24),
        height: 350,
        child: Column(
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 30),
            Icon(Icons.check_circle, size: 80, color: Colors.green),
            SizedBox(height: 20),
            Text(
              "Added to Cart!",
              style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "${widget.product.name} (Size: $selectedSize) has been added to your basket.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.grey[600]),
            ),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: Text("Continue Shopping"),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/addtocart');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigoAccent,
                      padding: EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: Text("View Cart", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _shareProduct() async {
    try {
      // Create dynamic link using Apptrove SDK
      final dynamicLink = await AppTroveFlutterSdk.createDynamicLink(
        templateId: 'wy23Px',
        link: 'https://trackier58.u9ilnk.me',
        domainUriPrefix: 'trackier58.u9ilnk.me',
        deepLinkValue: 'ProductDetail',
        sdkParameters: {
          'product_id': widget.product.id.toString(),
          'product_name': widget.product.name,
        },
        socialMeta: {
          'title': 'Flutmarket - ${widget.product.name}',
          'description': 'Check out this premium ${widget.product.name} only for \$${widget.product.price.toStringAsFixed(2)}!',
          'imageLink': widget.product.imageUrl,
        },
      );

      Share.share(
        'Check out this premium ${widget.product.name} on Flutmarket!\n\nLink: $dynamicLink',
      );
    } catch (e) {
      // Fallback in case link generation fails
      Share.share(
        'Check out this premium ${widget.product.name} on Flutmarket for only \$${widget.product.price.toStringAsFixed(2)}!\n\nDownload the app now!',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.indigoAccent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      child: Icon(Icons.broken_image, size: 80, color: Colors.grey[400]),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black54, Colors.transparent, Colors.white],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 0.4, 1.0],
                      ),
                    ),
                  )
                ],
              ),
            ),
            iconTheme: IconThemeData(color: Colors.indigo.shade900),
            actions: [
              Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.favorite_border, color: Colors.redAccent),
                  onPressed: () {},
                ),
              ),
              Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.share, color: Colors.indigo.shade900),
                  onPressed: _shareProduct,
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              ),
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.indigoAccent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                widget.product.category,
                                style: TextStyle(
                                  color: Colors.indigoAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              widget.product.name,
                              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "\$${widget.product.price.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.indigoAccent.shade700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 22),
                      Icon(Icons.star, color: Colors.amber, size: 22),
                      Icon(Icons.star, color: Colors.amber, size: 22),
                      Icon(Icons.star, color: Colors.amber, size: 22),
                      Icon(Icons.star_half, color: Colors.amber, size: 22),
                      SizedBox(width: 8),
                      Text("4.5 (128 reviews)", style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 30),
                  
                  // Product Variants Mock (Size/Options)
                  Text("Select Size / Option", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 15),
                  Row(
                    children: ['S', 'M', 'L', 'XL'].map((size) {
                      bool isSelected = selectedSize == size;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedSize = size;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 15),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.indigoAccent : Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade300, width: 2),
                            boxShadow: isSelected ? [BoxShadow(color: Colors.indigoAccent.withOpacity(0.4), blurRadius: 10, offset: Offset(0, 5))] : [],
                          ),
                          child: Center(
                            child: Text(
                              size,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 30),
                  
                  Text("Color", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 15),
                  Row(
                    children: [Colors.black, Colors.indigo, Colors.red.shade900, Colors.grey.shade300].map((color) {
                      bool isSelected = selectedColor == color;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedColor = color;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 15),
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade300, width: 2),
                            boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 10, offset: Offset(0, 5))] : [],
                          ),
                          child: isSelected ? Icon(Icons.check, color: color == Colors.grey.shade300 ? Colors.black : Colors.white, size: 20) : null,
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 30),
                  
                  Text("Description", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text(
                    widget.product.description + "\n\nDesigned for maximum comfort and premium durability. This item is carefully crafted using top-tier materials to provide an extraordinary experience.",
                    style: TextStyle(fontSize: 16, color: Colors.grey[700], height: 1.6),
                  ),
                  SizedBox(height: 80), // Padding for bottom bar
                ],
              ),
            ),
          ),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: Offset(0, -10),
            )
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _addToCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigoAccent,
                    padding: EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                    shadowColor: Colors.indigoAccent.shade100,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag_outlined, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        "Add to Cart",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
