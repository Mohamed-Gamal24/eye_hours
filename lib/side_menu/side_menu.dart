import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:eye_hours/Basics/profile.dart';
import 'package:eye_hours/chat_bot.dart';
import 'package:eye_hours/pages/login_page.dart';
import 'package:eye_hours/provider/config_provider.dart';
import 'package:eye_hours/side_menu/Subscription.dart';
import 'package:eye_hours/side_menu/help_center.dart';
import 'package:eye_hours/side_menu/terms_and_condition.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    final configProvider = Provider.of<ConfigProvider>(context);
    final localizations = AppLocalizations.of(context)!;

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'EYE Of HORUS 𓂀',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Monomakh',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Explore Ancient Wonders',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          // Language Selector
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: ListTile(
              leading: const Icon(Icons.language, color: Colors.deepOrange),
              title: Text(AppLocalizations.of(context)!.select,
                  style: const TextStyle(fontSize: 16)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(configProvider.isEnglish ? 'English' : 'العربية'),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
              onTap: () => _showLanguageDialog(context, configProvider),
            ),
          ),
          _buildListTile(
            icon: Icons.person,
            title: AppLocalizations.of(context)!.profile,
            onTap: () => _navigateTo(context, ProfilePage()),
          ),
          _buildListTile(
            icon: Icons.subscriptions,
            title: AppLocalizations.of(context)!.subscription,
            onTap: () => _navigateTo(context, const SubscriptionScreen()),
          ),
          _buildListTile(
            icon: Icons.support_agent,
            title: AppLocalizations.of(context)!.customer,
            onTap: () => Navigator.pop(context),
          ),
          _buildListTile(
            icon: Icons.chat,
            title: AppLocalizations.of(context)!.chatbot,
            onTap: () => _navigateTo(context, ChatBotPage()),
          ),
          Divider(color: Colors.grey[300]),
          _buildListTile(
            icon: Icons.description,
            title: AppLocalizations.of(context)!.terms,
            onTap: () => _navigateTo(context, const TermsAndConditionsScreen()),
          ),
          _buildListTile(
            icon: Icons.help,
            title: AppLocalizations.of(context)!.help,
            onTap: () => _navigateTo(context, const HelpCenter()),
          ),
          Divider(color: Colors.grey[300]),
          _buildListTile(
            icon: Icons.exit_to_app,
            title: AppLocalizations.of(context)!.logout,
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, ConfigProvider provider) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.select),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('English'),
                onTap: () {
                  provider.changeAppLanguage('en');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('العربية'),
                onTap: () {
                  provider.changeAppLanguage('ar');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepOrange),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
