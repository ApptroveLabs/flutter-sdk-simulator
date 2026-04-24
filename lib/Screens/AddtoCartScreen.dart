import 'package:flutter/material.dart';
import 'package:apptrove_sdk_flutter/apptroveevent.dart';
import 'package:apptrove_sdk_flutter/apptrovefluttersdk.dart';
import '../Utils/AppTroveEvents.dart';
import '../Models/Product.dart';
import 'OrderConfirmationScreen.dart';
import '../Utils/CartManager.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get subtotal => product.price * quantity;
}

class AddToCartScreen extends StatefulWidget {
  @override
  _AddToCartScreenState createState() => _AddToCartScreenState();
}

class _AddToCartScreenState extends State<AddToCartScreen> {
  List<CartItem> cartItems = CartManager().items;

  double get subtotal => cartItems.fold(0, (sum, item) => sum + item.subtotal);
  double get shipping => subtotal > 500 ? 0 : 9.99;
  double get total => subtotal + shipping;
  double get discount => subtotal * 0.05; // 5% discount

  void _purchase() {
    AppTroveEvent appTroveEvent = AppTroveEvent(AppTroveEvents.PURCHASE);
    appTroveEvent.revenue = total;
    appTroveEvent.currency = "USD";
    appTroveEvent.param1 = "Cart Purchase";
    appTroveEvent.param2 = cartItems.length.toString();
    AppTroveFlutterSdk.trackEvent(appTroveEvent);

    CartManager().clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => OrderConfirmationScreen(total: total)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('My Cart (${cartItems.length})', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigoAccent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey[400]),
                  SizedBox(height: 20),
                  Text("Your cart is empty", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[600])),
                  SizedBox(height: 10),
                  Text("Add items to get started", style: TextStyle(color: Colors.grey[400])),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigoAccent,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text("Browse Products", style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(16),
                    children: [
                      // Promo Banner
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.indigoAccent.shade100, Colors.indigoAccent.shade200],
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.local_offer, color: Colors.white),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                subtotal > 500
                                    ? "You got FREE shipping!"
                                    : "Spend \$${(500 - subtotal).toStringAsFixed(0)} more for FREE shipping!",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),

                      // Cart Items
                      ...cartItems.asMap().entries.map((entry) {
                        int index = entry.key;
                        CartItem item = entry.value;
                        return Container(
                          margin: EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: Offset(0, 4))
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    item.product.imageUrl,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      width: 80, height: 80, color: Colors.grey[200],
                                      child: Icon(Icons.image, color: Colors.grey),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.product.name,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4),
                                      Text(item.product.category, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                                      SizedBox(height: 8),
                                      Text(
                                        "\$${item.product.price.toStringAsFixed(2)}",
                                        style: TextStyle(color: Colors.indigoAccent, fontWeight: FontWeight.w900, fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.delete_outline, color: Colors.red.shade400, size: 22),
                                      onPressed: () {
                                        setState(() {
                                          CartManager().removeItem(index);
                                        });
                                      },
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.remove, size: 18),
                                            onPressed: () {
                                              setState(() {
                                                if (item.quantity > 1) item.quantity--;
                                              });
                                            },
                                            constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                                            padding: EdgeInsets.zero,
                                          ),
                                          Text(
                                            item.quantity.toString(),
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.add, size: 18, color: Colors.indigoAccent),
                                            onPressed: () => setState(() => item.quantity++),
                                            constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                                            padding: EdgeInsets.zero,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),

                      SizedBox(height: 16),

                      // Price Breakdown
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: Offset(0, 4))
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Order Summary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 15),
                            _summaryRow("Subtotal", "\$${subtotal.toStringAsFixed(2)}"),
                            _summaryRow("Discount (5%)", "-\$${discount.toStringAsFixed(2)}", color: Colors.green),
                            _summaryRow("Shipping", shipping == 0 ? "FREE" : "\$${shipping.toStringAsFixed(2)}", color: shipping == 0 ? Colors.green : null),
                            Divider(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Total", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                Text(
                                  "\$${(total - discount).toStringAsFixed(2)}",
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.indigoAccent),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 100),
                    ],
                  ),
                ),
                // Checkout Bar
                Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: Offset(0, -5))],
                  ),
                  child: SafeArea(
                    child: ElevatedButton(
                      onPressed: _purchase,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 60),
                        backgroundColor: Colors.indigoAccent,
                        elevation: 5,
                        shadowColor: Colors.indigoAccent.shade100,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock_outline, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            "Secure Checkout  •  \$${(total - discount).toStringAsFixed(2)}",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _summaryRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 15)),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: color ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}