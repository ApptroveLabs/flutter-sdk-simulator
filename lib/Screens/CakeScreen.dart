import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      appBar: AppBar(
        title: Text('Cake Activity'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate to home screen instead of just popping
            // This prevents blank screen when CakeScreen was reached via pushReplacement
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => EventsTrackingScreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Product Image
            Image.asset(
              _getProductImage(),
              width: 200,
              height: 200,
            ),
            SizedBox(height: 10),
            // Product Name
            Text(
              "Name: ${productId?.toUpperCase() ?? 'Unknown'}",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Quantity
            Text(
              "Quantity: ${quantity ?? '0'}",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Price
            Text(
              "Price: \$${price ?? '0'}",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            SizedBox(height: 10),
            // JSON Data
            Text(
              _getJsonData(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Copy Data Button
            ElevatedButton.icon(
              onPressed: () {
                _copyDataToClipboard(context);
              },
              icon: Icon(Icons.content_copy),
              label: Text(
                "Data Copy",
                style: TextStyle(color: Colors.white), // Change the text color here
              ), style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            ),
          ],
        ),
      ),
    );
  }

  String _getProductImage() {
    // Log productId to see which image is being used
    debugPrint("Fetching image for product: $productId");

    switch (productId) {
      case "blueberry":
        return 'Image/blueberrycupcake.jpeg'; // Fixed extension to match actual file
      case "chocochip":
        return 'Image/chocochipcupcake.png'; // Correct extension
      case "vanilla":
        return 'Image/vanillaccupake.jpeg'; // Fixed extension to match actual file
      default:
        return 'Image/chocochipcupcake.png'; // Default image if none match
    }
  }

  String _getJsonData() {
    return '{"Action": "$actionData", "Dlv": "$dlv", "Quantity": "$quantity", "Product": "$productId", "Price": "$price"}';
  }

  void _copyDataToClipboard(BuildContext context) {
    final data = _getJsonData();
    Clipboard.setData(ClipboardData(text: data));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Data Copied")),
    );
  }
}
