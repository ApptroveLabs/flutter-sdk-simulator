import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:apptrove_sdk_flutter/apptrovefluttersdk.dart';

class DynamicLinkScreen extends StatefulWidget {
  @override
  _DynamicLinkScreenState createState() => _DynamicLinkScreenState();
}

class _DynamicLinkScreenState extends State<DynamicLinkScreen> {
  final TextEditingController _templateIdController = TextEditingController(text: 'wy23Px');
  final TextEditingController _linkController = TextEditingController(text: 'https://apptrove58.u9ilnk.me');
  final TextEditingController _domainUriPrefixController = TextEditingController(text: 'apptrove58.u9ilnk.me');
  final TextEditingController _deepLinkValueController = TextEditingController(text: 'CakeActivity');
  final TextEditingController _androidRedirectController = TextEditingController(text: 'https://play.google.com/store/apps/details?id=com.apptrove.vistmarket');
  final TextEditingController _iosRedirectController = TextEditingController(text: 'https://www.example.com/ios');
  final TextEditingController _desktopRedirectController = TextEditingController(text: 'https://apptrove.com');
  final TextEditingController _productIdController = TextEditingController(text: 'chocochip');
  final TextEditingController _quantityController = TextEditingController(text: '2');
  final TextEditingController _channelController = TextEditingController(text: 'my_channel');
  final TextEditingController _mediaSourceController = TextEditingController(text: 'at_invite');
  final TextEditingController _campaignController = TextEditingController(text: 'sanu');
  final TextEditingController _titleController = TextEditingController(text: 'Your Title');
  final TextEditingController _descriptionController = TextEditingController(text: 'Your Description');
  final TextEditingController _imageLinkController = TextEditingController(text: 'https://www.example.com/image.jpg');
  
  final TextEditingController _resolveUrlController = TextEditingController(text: 'https://apptrove58.u9ilnk.me/d/NKmWH9E7b1');
  
  String _dynamicLinkResult = '';
  String _resolveResult = '';
  bool _isCreatingLink = false;
  bool _isResolvingLink = false;

  @override
  void dispose() {
    _templateIdController.dispose();
    _linkController.dispose();
    _domainUriPrefixController.dispose();
    _deepLinkValueController.dispose();
    _androidRedirectController.dispose();
    _iosRedirectController.dispose();
    _desktopRedirectController.dispose();
    _productIdController.dispose();
    _quantityController.dispose();
    _channelController.dispose();
    _mediaSourceController.dispose();
    _campaignController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _imageLinkController.dispose();
    _resolveUrlController.dispose();
    super.dispose();
  }

  void _createDynamicLink() async {
    setState(() {
      _isCreatingLink = true;
      _dynamicLinkResult = '';
    });

    try {
      final url = await AppTroveFlutterSdk.createDynamicLink(
        templateId: _templateIdController.text,
        link: _linkController.text,
        domainUriPrefix: _domainUriPrefixController.text,
        deepLinkValue: _deepLinkValueController.text,
        androidRedirect: _androidRedirectController.text,
        iosRedirect: _iosRedirectController.text,
        desktopRedirect: _desktopRedirectController.text,
        sdkParameters: {
          'product_id': _productIdController.text,
          'quantity': _quantityController.text,
        },
        attributionParameters: {
          'channel': _channelController.text,
          'media_source': _mediaSourceController.text,
          'campaign': _campaignController.text,
        },
        socialMeta: {
          'title': _titleController.text,
          'description': _descriptionController.text,
          'imageLink': _imageLinkController.text,
        },
      );

      setState(() {
        _dynamicLinkResult = '✅ SUCCESS\nDynamic Link Created: $url';
        _resolveUrlController.text = url; // Auto-fill the resolve URL field
      });

      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Dynamic link created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      setState(() {
        _dynamicLinkResult = '❌ ERROR\nFailed to create dynamic link: $error';
      });

      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create dynamic link: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isCreatingLink = false;
      });
    }
  }

  void _resolveDeepLink() async {
    setState(() {
      _isResolvingLink = true;
      _resolveResult = '';
    });

    try {
      final resolvedUrl = await AppTroveFlutterSdk.resolveDeeplinkUrl(_resolveUrlController.text);
      
      setState(() {
        _resolveResult = '✅ SUCCESS\nResolved URL: $resolvedUrl';
      });

      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Deep link resolved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      setState(() {
        _resolveResult = '❌ ERROR\nFailed to resolve deep link: $error';
      });

      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to resolve deep link: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isResolvingLink = false;
      });
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied to clipboard!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Link'),
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
                      'Dynamic Link Features',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Create dynamic links with attribution and resolve deep links to get full URLs',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Create Dynamic Link Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1. Create Dynamic Link',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    
                    // Basic Parameters
                    Text('Basic Parameters', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    _buildTextField('Template ID', _templateIdController, 'wy23Px'),
                    _buildTextField('Link', _linkController, 'https://apptrove58.u9ilnk.me'),
                    _buildTextField('Domain URI Prefix', _domainUriPrefixController, 'apptrove58.u9ilnk.me'),
                    _buildTextField('Deep Link Value', _deepLinkValueController, 'CakeActivity'),
                    
                    SizedBox(height: 16),
                    
                    // Platform Redirects
                    Text('Platform Redirects', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    _buildTextField('Android Redirect', _androidRedirectController, 'Play Store URL'),
                    _buildTextField('iOS Redirect', _iosRedirectController, 'iOS App Store URL'),
                    _buildTextField('Desktop Redirect', _desktopRedirectController, 'Desktop fallback URL'),
                    
                    SizedBox(height: 16),
                    
                    // SDK Parameters
                    Text('SDK Parameters', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    _buildTextField('Product ID', _productIdController, 'chocochip'),
                    _buildTextField('Quantity', _quantityController, '2'),
                    
                    SizedBox(height: 16),
                    
                    // Attribution Parameters
                    Text('Attribution Parameters', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    _buildTextField('Channel', _channelController, 'my_channel'),
                    _buildTextField('Media Source', _mediaSourceController, 'at_invite'),
                    _buildTextField('Campaign', _campaignController, 'sanu'),
                    
                    SizedBox(height: 16),
                    
                    // Social Meta
                    Text('Social Meta (Open Graph)', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    _buildTextField('Title', _titleController, 'Your Title'),
                    _buildTextField('Description', _descriptionController, 'Your Description'),
                    _buildTextField('Image Link', _imageLinkController, 'https://www.example.com/image.jpg'),
                    
                    SizedBox(height: 20),
                    
                    // Create Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isCreatingLink ? null : _createDynamicLink,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: _isCreatingLink
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
                                  Text('Creating Link...'),
                                ],
                              )
                            : Text('Create Dynamic Link'),
                      ),
                    ),
                    
                    // Result Display
                    if (_dynamicLinkResult.isNotEmpty) ...[
                      SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _dynamicLinkResult.contains('✅') ? Colors.green[50] : Colors.red[50],
                          border: Border.all(
                            color: _dynamicLinkResult.contains('✅') ? Colors.green : Colors.red,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Result:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: Icon(Icons.copy, size: 20),
                                  onPressed: () => _copyToClipboard(_dynamicLinkResult),
                                ),
                              ],
                            ),
                            Text(
                              _dynamicLinkResult,
                              style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Resolve Deep Link Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '2. Resolve Deep Link',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Enter a dynamic link URL to resolve and get the full URL with parameters',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 16),
                    
                    _buildTextField('Deep Link URL', _resolveUrlController, 'https://apptrove58.u9ilnk.me/d/NKmWH9E7b1'),
                    
                    SizedBox(height: 16),
                    
                    // Resolve Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isResolvingLink ? null : _resolveDeepLink,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: _isResolvingLink
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
                                  Text('Resolving...'),
                                ],
                              )
                            : Text('Resolve Deep Link'),
                      ),
                    ),
                    
                    // Resolve Result Display
                    if (_resolveResult.isNotEmpty) ...[
                      SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _resolveResult.contains('✅') ? Colors.green[50] : Colors.red[50],
                          border: Border.all(
                            color: _resolveResult.contains('✅') ? Colors.green : Colors.red,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Resolved URL:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: Icon(Icons.copy, size: 20),
                                  onPressed: () => _copyToClipboard(_resolveResult),
                                ),
                              ],
                            ),
                            Text(
                              _resolveResult,
                              style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );
  }
}

