import 'package:flutter/material.dart';
import 'HomeScreen.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final double total;

  const OrderConfirmationScreen({required this.total});

  @override
  Widget build(BuildContext context) {
    final orderId = "VM${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success animation placeholder
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.indigoAccent, Colors.purple.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigoAccent.withOpacity(0.3),
                        blurRadius: 30,
                        offset: Offset(0, 15),
                      )
                    ],
                  ),
                  child: Icon(Icons.check_rounded, color: Colors.white, size: 70),
                ),
                SizedBox(height: 40),
                Text(
                  "Order Placed!",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.black87),
                ),
                SizedBox(height: 15),
                Text(
                  "Thank you for shopping with Flutmarket",
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                FutureBuilder<CustomerInfo>(
                  future: Purchases.getCustomerInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && (snapshot.data?.entitlements.all["premium"]?.isActive ?? false)) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.amber.shade300),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, color: Colors.amber.shade800, size: 16),
                            SizedBox(width: 6),
                            Text("PREMIUM MEMBER", style: TextStyle(color: Colors.amber.shade900, fontWeight: FontWeight.bold, fontSize: 12)),
                          ],
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
                SizedBox(height: 30),

                // Order summary card
                Container(
                  padding: EdgeInsets.all(24),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      _infoRow(Icons.receipt_long, "Order ID", "#$orderId"),
                      Divider(height: 20),
                      _infoRow(Icons.attach_money, "Amount Paid", "\$${total.toStringAsFixed(2)}"),
                      Divider(height: 20),
                      _infoRow(Icons.local_shipping_outlined, "Estimated Delivery", "3-5 Business Days"),
                      Divider(height: 20),
                      _infoRow(Icons.payment, "Payment Status", "Confirmed"),
                    ],
                  ),
                ),
                SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => EventsTrackingScreen()),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigoAccent,
                      padding: EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 5,
                      shadowColor: Colors.indigoAccent.shade100,
                    ),
                    child: Text(
                      "Continue Shopping",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "Track your order via My Orders in the menu",
                  style: TextStyle(color: Colors.grey[400], fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.indigoAccent, size: 20),
            SizedBox(width: 10),
            Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          ],
        ),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
      ],
    );
  }
}
