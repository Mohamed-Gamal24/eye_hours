// widgets/side_menu.dart
import 'package:eye_hours/Basics/profile.dart';
import 'package:eye_hours/chat_bot.dart';
import 'package:eye_hours/pages/login_page.dart';
import 'package:eye_hours/side_menu/Subscription.dart';
import 'package:eye_hours/side_menu/help_center.dart';
import 'package:eye_hours/side_menu/terms_and_condition.dart';
import 'package:flutter/material.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  String selectedLanguage = 'English';
  final List<String> languages = ['English', 'Arabic'];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black87,
              image: DecorationImage(
                image: const AssetImage(
                    'assets/image/5d360bb1e8b064f361f88e3cf121f5a0.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4),
                  BlendMode.darken,
                ),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'EYE Of HORUS 𓂀',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Monomakh',
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Explore Ancient Wonders',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          // Language Selection
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: ListTile(
              leading: const Icon(Icons.language, color: Colors.deepOrange),
              title:
                  const Text('Select Language', style: TextStyle(fontSize: 16)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(selectedLanguage),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
              onTap: () {
                _showLanguageDialog(context);
              },
            ),
          ),
          _buildListTile(
            context,
            icon: Icons.person,
            title: 'Profile',
            onTap: () => _handleprofile(context),
          ),
          _buildListTile(
            context,
            icon: Icons.subscriptions,
            title: 'Subscription',
            onTap: () => _handleSubscription(context),
          ),
          _buildListTile(
            context,
            icon: Icons.support_agent,
            title: 'Customer Service',
            onTap: () => _handleCustomerService(context),
          ),
          _buildListTile(
            context,
            icon: Icons.chat,
            title: 'Chatbot',
            onTap: () => _handlechatbot(context),
          ),
          Divider(color: Colors.grey[300]),
          _buildListTile(
            context,
            icon: Icons.description,
            title: 'Terms and Conditions',
            onTap: () => _handleTermsAndConditions(context),
          ),
          _buildListTile(
            context,
            icon: Icons.help,
            title: 'Help Center',
            onTap: () => _handleHelpCenter(context),
          ),
          Divider(color: Colors.grey[300]),
          _buildListTile(
            context,
            icon: Icons.exit_to_app,
            title: 'Log Out',
            onTap: () => _handleLogOut(context),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: Container(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: languages.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(languages[index]),
                  onTap: () {
                    setState(() {
                      selectedLanguage = languages[index];
                    });
                    Navigator.pop(context);
                    // Here you can add logic to change the app's language
                    // For example, using a language provider or locale change
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Function() onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepOrange),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }

  void _handleprofile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
    );
  }

  void _handleSubscription(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SubscriptionScreen()),
    );
  }

  void _handleCustomerService(BuildContext context) {
    Navigator.pop(context);
  }

  void _handlechatbot(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatBotPage()),
    );
  }

  void _handleTermsAndConditions(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TermsAndConditionsScreen()),
    );
  }

  void _handleHelpCenter(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HelpCenter()),
    );
  }

  void _handleLogOut(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}
