import 'package:flutter/material.dart';
import 'package:apptrove_sdk_flutter/apptroveevent.dart';
import 'package:apptrove_sdk_flutter/apptrovefluttersdk.dart';
import '../Utils/AppTroveEvents.dart';


class ProductPageScreen extends StatefulWidget {
  @override
  _ProductPageScreenState createState() => _ProductPageScreenState();
}

class _ProductPageScreenState extends State<ProductPageScreen> {
  @override
  void initState() {
    super.initState();
    // Track product view event
    AppTroveEvent apptroveEvent = AppTroveEvent(AppTroveEvents.PRODUCT_VIEW);
    apptroveEvent.param1="Product Viewed";
    apptroveEvent.orderId="Britania12123";
    AppTroveFlutterSdk.trackEvent(apptroveEvent);

  }

  void _addToCart() {
    // Track add to cart event
    AppTroveEvent apptroveEvent = AppTroveEvent(AppTroveEvents.ADD_TO_CART);
    apptroveEvent.param1="Product Added to cart";
    AppTroveFlutterSdk.trackEvent(apptroveEvent);
   // log("getPartner--${AppTroveFlutterSdk.getPartner()}");

    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Product has been added to cart")),
    );

    Navigator.pushNamed(context, '/addtocart'); // Correct usage

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'Image/apptrovelogo.png', // Replace with your logo asset
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              'Flutter Simulator', // Replace with your app name
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Image.asset(
              'Image/chocochipcupcake.png',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              'Britannia Cupcake',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              '30.00 RS', // Replace with your product price
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _addToCart,
              child: Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}

