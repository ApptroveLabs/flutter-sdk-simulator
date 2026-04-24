import 'package:flutter/material.dart';
import 'package:apptrove_sdk_flutter/apptrovefluttersdk.dart';
import 'package:apptrove_sdk_flutter/apptroveevent.dart';
import '../Utils/AppTroveEvents.dart';

class CampaignDataScreen extends StatefulWidget {
  @override
  _CampaignDataScreenState createState() => _CampaignDataScreenState();
}

class _CampaignDataScreenState extends State<CampaignDataScreen> {
  final TextEditingController _eventIdController = TextEditingController(text: AppTroveEvents.PRODUCT_SEARCH);
  
  Map<String, String> _campaignData = {};
  bool _isLoading = false;
  String _trackEventResult = '';

  @override
  void dispose() {
    _eventIdController.dispose();
    super.dispose();
  }

  Future<void> _getCampaignData() async {
    setState(() {
      _isLoading = true;
      _campaignData.clear();
      _trackEventResult = '';
    });

    try {
      print("Getting campaign data...");
      
      // Retrieve all campaign data asynchronously
      final ad = await AppTroveFlutterSdk.getAd();
      final adID = await AppTroveFlutterSdk.getAdID();
      final campaign = await AppTroveFlutterSdk.getCampaign();
      final campaignID = await AppTroveFlutterSdk.getCampaignID();
      final adSet = await AppTroveFlutterSdk.getAdSet();
      final adSetID = await AppTroveFlutterSdk.getAdSetID();
      // final channel = await AppTroveFlutterSdk.getChannel(); // Method not available
      final clickId = await AppTroveFlutterSdk.getClickId();
      final pid = await AppTroveFlutterSdk.getPid();
      final dlv = await AppTroveFlutterSdk.getDlv();
      final isRetargeting = await AppTroveFlutterSdk.getIsRetargeting();
      
      // Get custom parameters P1-P5
      final p1 = await AppTroveFlutterSdk.getP1();
      final p2 = await AppTroveFlutterSdk.getP2();
      final p3 = await AppTroveFlutterSdk.getP3();
      final p4 = await AppTroveFlutterSdk.getP4();
      final p5 = await AppTroveFlutterSdk.getP5();

      setState(() {
        _campaignData = {
          'Ad Name': ad ?? 'N/A',
          'Ad ID': adID ?? 'N/A',
          'Campaign Name': campaign ?? 'N/A',
          'Campaign ID': campaignID ?? 'N/A',
          'Ad Set Name': adSet ?? 'N/A',
          'Ad Set ID': adSetID ?? 'N/A',
          // 'Channel': channel ?? 'N/A', // Method not available
          'Click ID': clickId ?? 'N/A',
          'Partner ID': pid ?? 'N/A',
          'Deep Link Value': dlv ?? 'N/A',
          'Is Retargeting': isRetargeting.toString(),
          'Custom Parameter P1': p1 ?? 'N/A',
          'Custom Parameter P2': p2 ?? 'N/A',
          'Custom Parameter P3': p3 ?? 'N/A',
          'Custom Parameter P4': p4 ?? 'N/A',
          'Custom Parameter P5': p5 ?? 'N/A',
        };
      });

      print("Campaign data retrieved successfully");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Campaign data retrieved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      print("Error getting campaign data: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error retrieving campaign data: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _trackEventWithCampaignData() async {
    if (_eventIdController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter an event ID'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _trackEventResult = '';
    });

    try {
      print("Tracking event with campaign data...");
      
      // Create event with the specified event ID
      AppTroveEvent apptroveEvent = AppTroveEvent(_eventIdController.text.trim());
      
      // Track the event (campaign data is automatically associated)
      AppTroveFlutterSdk.trackEvent(apptroveEvent);
      
      setState(() {
        _trackEventResult = ' SUCCESS\nEvent "${_eventIdController.text.trim()}" tracked successfully with campaign data!';
      });

      print("Event tracked successfully with campaign data");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Event tracked successfully with campaign data!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      print("Error tracking event: $error");
      setState(() {
        _trackEventResult = ' ERROR\nFailed to track event: $error';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error tracking event: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Campaign Data'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Campaign Data Overview',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Retrieve campaign attribution data to understand how users discovered your app',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Get Campaign Data Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1. Get Campaign Data',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Retrieve all available campaign attribution data',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 16),
                    
                    // Get Campaign Data Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _getCampaignData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: _isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text('Getting Campaign Data...'),
                                ],
                              )
                            : Text('Get Campaign Data'),
                      ),
                    ),
                    
                    // Campaign Data Display
                    if (_campaignData.isNotEmpty) ...[
                      SizedBox(height: 20),
                      Text(
                        'Campaign Attribution Data:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _campaignData.entries.map((entry) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 140,
                                    child: Text(
                                      '${entry.key}:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      entry.value,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'monospace',
                                        color: entry.value == 'N/A' ? Colors.grey[600] : Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Track Event with Campaign Data Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '2. Track Event with Campaign Data',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Track an event and automatically associate it with campaign data',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 16),
                    
                    // Event ID Input
                    TextField(
                      controller: _eventIdController,
                      decoration: InputDecoration(
                        labelText: 'Event ID',
                        hintText: '1CFfUn3xEY',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Track Event Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _trackEventWithCampaignData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: _isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text('Tracking Event...'),
                                ],
                              )
                            : Text('Track Event with Campaign Data'),
                      ),
                    ),
                    
                    // Track Event Result Display
                    if (_trackEventResult.isNotEmpty) ...[
                      SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _trackEventResult.contains('✅') ? Colors.green[50] : Colors.red[50],
                          border: Border.all(
                            color: _trackEventResult.contains('✅') ? Colors.green : Colors.red,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _trackEventResult,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            color: _trackEventResult.contains('✅') ? Colors.green[800] : Colors.red[800],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Information Card
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue[700]),
                        SizedBox(width: 8),
                        Text(
                          'Campaign Data Information',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      '• Campaign data is automatically associated with events when tracking\n'
                      '• Data includes ad names, campaign IDs, click identifiers, and custom parameters\n'
                      '• Use this data to understand user acquisition sources and campaign performance\n'
                      '• Ensure SDK is initialized before calling these methods',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
