
import 'package:flutter/material.dart';
class EventsTrackingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trackier Flutter SDK'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              // Trackier Logo (Image)
              Image.asset(
                'Image/trackierlogo.png',  // Replace with your asset path
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 10,width: 30,),
              // Welcome Text
              Text(
                'Welcome to UniLink Simulator',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),

              // Buttons to navigate to different screens
              _buildButton(context, 'Built-in events', () {
                Navigator.pushNamed(context, '/builtInEvents');
              }),
              SizedBox(height: 10),
              _buildButton(context, 'Customs Events', () {
                Navigator.pushNamed(context, '/customsEvents');
              }),
              SizedBox(height: 10),
              _buildButton(context, 'Deep linking Page', () {
                Navigator.pushNamed(context, '/deepLinking');
              }),
              SizedBox(height: 10),
              _buildButton(context, 'Product Page', () {
                Navigator.pushNamed(context, '/productPage');
              }),
              SizedBox(height: 10),
              _buildButton(context, 'Dynamic Link', () {
                Navigator.pushNamed(context, '/dynamicLink');
              }),
              SizedBox(height: 10),
              _buildButton(context, 'Campaign Data', () {
                Navigator.pushNamed(context, '/campaignData');
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(200, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
      onPressed: onPressed,
      child: Text(label, style: TextStyle(fontSize: 16)),
    );
  }
}










