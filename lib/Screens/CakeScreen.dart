import 'package:flutter/material.dart';
import 'package:apptrove_sdk_flutter/apptroveevent.dart';
import 'package:apptrove_sdk_flutter/apptrovefluttersdk.dart';
import '../Utils/AppTroveEvents.dart';
import 'HomeScreen.dart';

class CakeScreen extends StatelessWidget {
  final String? productId;
  final String? quantity;
  final String? actionData;
  final String? dlv;
  final String? price;

  CakeScreen({
    this.productId,
    this.quantity,
    this.actionData,
    this.dlv,
    this.price,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint("CakeScreen received: productId=$productId, quantity=$quantity, actionData=$actionData, dlv=$dlv, price=$price");

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Exclusive Offer', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigoAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => EventsTrackingScreen()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 350,
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                border: Border(bottom: BorderSide(color: Colors.pink.shade100)),
              ),
              child: Image.asset(
                _getProductImage(),
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.cake, size: 100, color: Colors.pink.shade300);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _getDisplayTitle(),
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        "\$${price ?? '15.00'}",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigoAccent,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.pink.shade100,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "Bakery",
                      style: TextStyle(
                        color: Colors.pink.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Description",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "This delicious freshly baked cupcake is available exclusively through our special promotional link. Treat yourself to the finest ingredients and exquisite taste, baked fresh daily.",
                    style: TextStyle(fontSize: 16, color: Colors.grey[800], height: 1.5),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, -5),
            )
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            // Track Event
            AppTroveEvent apptroveEvent = AppTroveEvent(AppTroveEvents.ADD_TO_CART);
            apptroveEvent.param1 = "Special Cake Added to cart";
            apptroveEvent.param2 = productId ?? "unknown_cake";
            apptroveEvent.revenue = double.tryParse(price ?? "15.00") ?? 15.00;
            apptroveEvent.currency = "USD";
            AppTroveFlutterSdk.trackEvent(apptroveEvent);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("${_getDisplayTitle()} added to cart"),
                backgroundColor: Colors.indigoAccent,
              ),
            );

            Navigator.pushNamed(context, '/addtocart');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink.shade400,
            padding: EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            "Add Exclusive Item To Cart",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  String _getDisplayTitle() {
    switch (productId) {
      case "blueberry":
        return "Blueberry Cupcake";
      case "chocochip":
        return "Choco Chip Cupcake";
      case "vanilla":
        return "Vanilla Cupcake";
      default:
        return "Premium Cupcake";
    }
  }

  String _getProductImage() {
    switch (productId) {
      case "blueberry":
        return 'Image/blueberrycupcake.jpeg'; 
      case "chocochip":
        return 'Image/chocochipcupcake.png'; 
      case "vanilla":
        return 'Image/vanillaccupake.jpeg'; 
      default:
        return 'Image/chocochipcupcake.png'; 
    }
  }
}
