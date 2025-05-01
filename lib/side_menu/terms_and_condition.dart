import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eye_hours/Home_Screen.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFBB7E3D);
    const secondaryColor = Color(0xFFD4A017);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        appBar: _buildAppBar(primaryColor, secondaryColor),
        body: _buildContent(primaryColor),
        floatingActionButton: _buildAcceptButton(context, primaryColor),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(Color primaryColor, Color secondaryColor) {
    return AppBar(
      title: const Text(
        'Terms & Conditions',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      elevation: 4,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  Widget _buildContent(Color primaryColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(primaryColor),
          const SizedBox(height: 24),
          _buildSectionTitle('1. Acceptance of Terms'),
          _buildSectionContent(
              'By using the Eye Of Hours application, you agree to comply with these Terms and Conditions. You may review these terms at any time in the app settings.'),
          const SizedBox(height: 20),
          _buildSectionTitle('2. App Description'),
          _buildSectionContent('Eye Of Hours provides the following features:'),
          _buildFeatureList(primaryColor),
          const SizedBox(height: 20),
          _buildSectionTitle('3. Responsible Use'),
          _buildSectionContent(
              'The app must be used for lawful purposes only. Any unauthorized or illegal use is prohibited. The app may not be used for any activities that could damage historical sites or monuments in Egypt.'),
          const SizedBox(height: 20),
          _buildSectionTitle('4. Privacy & Data Protection'),
          _buildSectionContent(
              'We are committed to protecting your privacy. Only necessary data is collected to improve user experience. You can review our full privacy policy in the app settings.'),
          const SizedBox(height: 20),
          _buildSectionTitle('5. Updates & Changes'),
          _buildSectionContent(
              'We reserve the right to modify these terms when necessary. Significant changes will be communicated through in-app notifications. We recommend reviewing the terms periodically.'),
          const SizedBox(height: 20),
          _buildSectionTitle('6. Contact Us'),
          _buildSectionContent(
              'For any questions or feedback regarding these Terms and Conditions, please contact us at:\nEmail: support@eyeofhours.com\nOr through the in-app contact form.'),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeader(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Eye Of Hours',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Terms and Conditions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Divider(
          thickness: 1.5,
          color: primaryColor.withOpacity(0.3),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        height: 1.5,
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
      child: Text(
        content,
        style: const TextStyle(
          fontSize: 16,
          height: 1.6,
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildFeatureList(Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFeatureItem(
              'Comprehensive information about Egyptian tourist attractions',
              primaryColor),
          _buildFeatureItem(
              'Scan technology for statues to reveal historical details',
              primaryColor),
          _buildFeatureItem('Display of historical events related to monuments',
              primaryColor),
          _buildFeatureItem(
              'Interactive guide for tourist locations in Egypt', primaryColor),
          _buildFeatureItem(
              'Augmented reality features to view 3D statues', primaryColor),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4.0, right: 8.0),
            child: Icon(Icons.circle, size: 8, color: primaryColor),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcceptButton(BuildContext context, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        },
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        label: const Text(
          'I Accept',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        elevation: 4,
      ),
    );
  }
}
