import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  File? _image;
  final picker = ImagePicker();
  bool _isLoading = false;
  bool _isProcessing = false;
  String? _detectionResult;

  // API Configuration
  static const String API_BASE_URL = 'https://your-api-endpoint.com';
  static const String DETECTION_ENDPOINT = '/detect';

  // Function to show image source dialog
  Future<void> _showImageSourceDialog() async {
    if (_isLoading) return; // Prevent multiple dialogs

    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Select Image Source',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSourceOption(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    color: Colors.deepOrange,
                    onTap: () {
                      Navigator.pop(context);
                      _getImageFromCamera();
                    },
                  ),
                  _buildSourceOption(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    color: Colors.deepOrange,
                    onTap: () {
                      Navigator.pop(context);
                      _getImageFromGallery();
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.black, size: 30),
            ),
            SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to get image from camera
  Future _getImageFromCamera() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _detectionResult = null; // Reset previous result
        });
        _showSuccessSnackBar('Image captured successfully!');

        // Automatically start detection after image selection
        await _performDetection();
      }
    } catch (e) {
      _showErrorSnackBar('Error capturing image');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to get image from gallery
  Future _getImageFromGallery() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _detectionResult = null; // Reset previous result
        });
        _showSuccessSnackBar('Image selected successfully!');

        // Automatically start detection after image selection
        await _performDetection();
      }
    } catch (e) {
      _showErrorSnackBar('Error selecting image');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to perform image detection via API
  Future<void> _performDetection() async {
    if (_image == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // Convert image to base64
      List<int> imageBytes = await _image!.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      // Prepare API request
      final response = await http.post(
        Uri.parse('$API_BASE_URL$DETECTION_ENDPOINT'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          // Add authorization headers if needed
          // 'Authorization': 'Bearer $yourToken',
        },
        body: jsonEncode({
          'image': base64Image,
          'format': 'jpg', // or determine from file extension
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        String detectionResult = responseData['detection_type'] ??
            responseData['class'] ??
            responseData['result'] ??
            'Unknown';

        setState(() {
          _detectionResult = detectionResult;
        });

        // Check if detection was successful
        if (detectionResult.toLowerCase() == 'unknown' ||
            detectionResult.toLowerCase() == 'not found' ||
            detectionResult.toLowerCase() == 'no detection' ||
            detectionResult.isEmpty) {
          _showUnrecognizedImageDialog();
        } else {
          _showSuccessSnackBar('Detection completed successfully!');
          // Navigate to appropriate page based on detection result
          await _navigateBasedOnResult(_detectionResult!);
        }
      } else {
        throw Exception('Detection failed: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorSnackBar('Detection error: ${e.toString()}');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  // Function to navigate based on detection result
  Future<void> _navigateBasedOnResult(String detectionResult) async {
    Widget? targetPage;
    String route = '';

    // Map detection results to specific pages
    switch (detectionResult.toLowerCase()) {
      case 'document':
      case 'text':
      case 'receipt':
        route = '/document_page';
        // targetPage = DocumentPage(); // Replace with your actual page
        break;
      case 'barcode':
      case 'qr_code':
      case 'qrcode':
        route = '/barcode_page';
        // targetPage = BarcodePage(); // Replace with your actual page
        break;
      case 'product':
      case 'item':
        route = '/product_page';
        // targetPage = ProductPage(); // Replace with your actual page
        break;
      case 'person':
      case 'face':
        route = '/person_page';
        // targetPage = PersonPage(); // Replace with your actual page
        break;
      default:
        route = '/general_result_page';
        // targetPage = GeneralResultPage(result: detectionResult); // Replace with your actual page
        break;
    }

    // Show confirmation dialog before navigation
    bool shouldNavigate = await _showNavigationDialog(detectionResult, route);

    if (shouldNavigate) {
      // Option 1: Navigation with route name
      Navigator.pushNamed(context, route, arguments: {
        'image': _image,
        'detectionResult': detectionResult,
      });

      // Option 2: Navigation with page widget (uncomment if you have the page widgets)
      /*
      if (targetPage != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetPage!),
        );
      }
      */
    }
  }

  // Function to show unrecognized image dialog
  Future<void> _showUnrecognizedImageDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            children: [
              Icon(Icons.warning_rounded, color: Colors.orange, size: 28),
              SizedBox(width: 10),
              Text('Image Not Recognized'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Unfortunately, we couldn\'t recognize what\'s in this image.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),
              Text(
                'Please try:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text('• Take a clearer photo'),
              Text('• Make sure the object is well-lit'),
              Text('• Get closer to the object'),
              Text('• Try a different angle'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Try Again',
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _showNavigationDialog(String result, String route) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              title: Row(
                children: [
                  Icon(Icons.visibility, color: Colors.deepOrange),
                  SizedBox(width: 10),
                  Text('Detection Complete'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Detected: $result'),
                  SizedBox(height: 10),
                  Text(
                      'Would you like to proceed to the ${result.toLowerCase()} page?'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Stay Here'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Continue'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  // Function to clear selected image
  void _clearImage() {
    setState(() {
      _image = null;
      _detectionResult = null;
    });
    _showSuccessSnackBar('Image removed');
  }

  // Function to show success message
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  // Function to show error message
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Scan Page',
          style: TextStyle(
            fontSize: 26,
          ),
        ),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepOrange.shade50, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Image display area
              Container(
                width: double.infinity,
                height: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: _image == null
                      ? Container(
                          color: Colors.grey.shade100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_outlined,
                                size: 80,
                                color: Colors.grey.shade400,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No image selected',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Tap the button below to select an image',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Stack(
                          children: [
                            Image.file(
                              _image!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.white),
                                  onPressed: _clearImage,
                                ),
                              ),
                            ),
                            // Processing overlay
                            if (_isProcessing)
                              Container(
                                color: Colors.black54,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.black),
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Processing image...',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                ),
              ),

              SizedBox(height: 20),

              // Detection result display
              if (_detectionResult != null)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.visibility, color: Colors.green.shade700),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Detection Result:',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.green.shade700,
                              ),
                            ),
                            Text(
                              _detectionResult!,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              SizedBox(height: 20),

              // Buttons row
              Row(
                children: [
                  // Select/Change image button
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _isLoading || _isProcessing
                            ? null
                            : _showImageSourceDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          foregroundColor: Colors.black,
                          elevation: 8,
                          shadowColor: Colors.deepOrange.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate,
                                    size: 24,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    _image == null
                                        ? 'Select Image'
                                        : 'Change Image',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),

                  // Detect again button (only show if image is selected)
                  if (_image != null) ...[
                    SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 60,
                        child: ElevatedButton(
                          onPressed: _isProcessing ? null : _performDetection,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            foregroundColor: Colors.black,
                            elevation: 8,
                            shadowColor: Colors.deepOrange.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: _isProcessing
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.black),
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.search,
                                        size: 24, color: Colors.black),
                                    Text(
                                      'Detect',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
