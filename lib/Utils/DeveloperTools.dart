import 'package:flutter/material.dart';

class HiddenDeveloperTools {
  static int _tapCount = 0;
  
  static void processTap(BuildContext context) {
    _tapCount++;
    if (_tapCount >= 7) {
      _tapCount = 0; // reset
      _showDeveloperPanel(context);
    } else {
      if (_tapCount >= 4) {
        int tapsLeft = 7 - _tapCount;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("You are $tapsLeft taps away from being a developer!"),
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
  }

  static void _showDeveloperPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.indigo.shade900,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Apptrove SDK Testing",
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _devBtn(context, 'Built-in events', '/builtInEvents'),
                  _devBtn(context, 'Customs Events', '/customsEvents'),
                  _devBtn(context, 'Deep linking', '/deepLinking'),
                  _devBtn(context, 'Dynamic Link', '/dynamicLink'),
                  _devBtn(context, 'Campaign Data', '/campaignData'),
                ],
              )
            ],
          ),
        );
      }
    );
  }

  static Widget _devBtn(BuildContext context, String text, String route) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
      onPressed: () => Navigator.pushNamed(context, route),
      child: Text(text, style: TextStyle(color: Colors.indigo.shade900)),
    );
  }
}
