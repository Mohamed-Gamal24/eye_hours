import 'dart:io';
import 'package:eye_hours/Basics/edit_setting.dart';
import 'package:eye_hours/Profile/edit_profile.dart';
import 'package:eye_hours/pages/login_page.dart';
import 'package:eye_hours/side_menu/Subscription.dart';
import 'package:eye_hours/side_menu/help_center.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;
  final Map<String, dynamic> _userData = {
    'firstName': 'John',
    'lastName': 'Doe',
    'email': 'john.doe@example.com', // سيتم عرضه مكان username
    'gender': 'Male',
  };

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildUserInfoSection(),
            const SizedBox(height: 24),
            _buildProfileOptions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: CircleAvatar(
            radius: 50,
            backgroundImage: _profileImage != null
                ? FileImage(_profileImage!)
                : const AssetImage(
                        'assets/image/441c14126a15ff18c7d8c7a84663aebe.jpg')
                    as ImageProvider,
            child: _profileImage == null
                ? const Icon(Icons.camera_alt, size: 30, color: Colors.white)
                : null,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '${_userData['firstName']} ${_userData['lastName']}',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _userData['email'], // عرض البريد الإلكتروني مباشرة
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileOptions(BuildContext context) {
    return Column(
      children: [
        _buildProfileOptionItem(
          context,
          icon: Icons.edit,
          title: 'Edit Profile',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditProfilePage(
                currentFirstName: _userData['firstName'],
                currentLastName: _userData['lastName'],
                currentEmail: _userData['email'],
                currentGender: _userData['gender'],
              ),
            ),
          ).then((updatedData) {
            if (updatedData != null) {
              setState(() {
                // تحديث جميع الحقول بما فيها البريد الإلكتروني
                _userData['firstName'] = updatedData['firstName'];
                _userData['lastName'] = updatedData['lastName'];
                _userData['email'] = updatedData['email'];
                _userData['gender'] = updatedData['gender'];
              });
            }
          }),
        ),
        _buildProfileOptionItem(
          context,
          icon: Icons.subscriptions,
          title: 'Subscriptions',
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const SubscriptionScreen())),
        ),
        _buildProfileOptionItem(
          context,
          icon: Icons.help_center,
          title: 'Help Center',
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => const HelpCenter())),
        ),
        _buildProfileOptionItem(
          context,
          icon: Icons.settings,
          title: 'Settings',
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => const SettingsPage())),
        ),
        const SizedBox(height: 16),
        _buildLogoutButton(context),
      ],
    );
  }

  Widget _buildProfileOptionItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepOrange),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrange,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text('Log Out', style: TextStyle(color: Colors.white)),
        onPressed: () => _showLogoutConfirmationDialog(context),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Log Out',
                style: TextStyle(color: Colors.deepOrange)),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
