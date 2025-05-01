import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Replace with your actual home screen import

class HelpCenter extends StatelessWidget {
  const HelpCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/image/559f259ca5df59ecbaeaff840cbd1f1c.jpg', // Add this image to your assets
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 32),
            const Text(
              'Temporary Service Interruption',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFBB7E3D), // Using your gold color
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'We apologize, but our database service is temporarily unavailable. Our team is working to restore access as quickly as possible.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildStatusIndicator(),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBB7E3D),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // Option 1: Retry logic
                _retryConnection(context);

                // Option 2: Navigate to home
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (context) => const HomeScreen()),
                // );
              },
              child: const Text(
                'Try Again',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Navigate to offline content if available
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OfflineContentScreen()),
                );
              },
              child: const Text(
                'View Offline Content',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFBB7E3D),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Column(
      children: [
        const Text(
          'Service Status:',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.orange),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Maintenance in Progress',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _retryConnection(BuildContext context) {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFBB7E3D)),
        ),
      ),
    );

    // Simulate retry after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Dismiss loading

      // In a real app, you would check connection here
      // For this example, we'll just show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Still unable to connect. Please try again later.'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }
}

// Placeholder for offline content screen
class OfflineContentScreen extends StatelessWidget {
  const OfflineContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Content'),
      ),
      body: const Center(
        child: Text('Limited offline content would be shown here'),
      ),
    );
  }
}
