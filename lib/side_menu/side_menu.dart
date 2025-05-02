// widgets/side_menu.dart
import 'package:eye_hours/Basics/profile.dart';
import 'package:eye_hours/chat_bot.dart';
import 'package:eye_hours/pages/login_page.dart';
import 'package:eye_hours/provider/config_provider.dart';
import 'package:eye_hours/side_menu/Subscription.dart';
import 'package:eye_hours/side_menu/help_center.dart';
import 'package:eye_hours/side_menu/terms_and_condition.dart';
import 'package:eye_hours/widget/custom_drop_down_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  String selectedLang = "English";
  String selectedTheme = "Light";
  late ConfigProvider configProvider;

  @override
  Widget build(BuildContext context) {
    configProvider = Provider.of<ConfigProvider>(context);
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
          _buildListTile(
            context,
            icon: Icons.person,
            title: AppLocalizations.of(context)!.profile,
            onTap: () => _handleprofile(context),
          ),
          _buildListTile(
            context,
            icon: Icons.subscriptions,
            title: AppLocalizations.of(context)!.subscription,
            onTap: () => _handleSubscription(context),
          ),
          _buildListTile(
            context,
            icon: Icons.support_agent,
            title: AppLocalizations.of(context)!.customer,
            onTap: () => _handleCustomerService(context),
          ),
          _buildListTile(
            context,
            icon: Icons.chat,
            title: AppLocalizations.of(context)!.chatbot,
            onTap: () => _handlechatbot(context),
          ),
          Divider(color: Colors.grey[300]),
          _buildListTile(
            context,
            icon: Icons.description,
            title: AppLocalizations.of(context)!.terms,
            onTap: () => _handleTermsAndConditions(context),
          ),
          _buildListTile(
            context,
            icon: Icons.help,
            title: AppLocalizations.of(context)!.help,
            onTap: () => _handleHelpCenter(context),
          ),
          Divider(color: Colors.grey[300]),
          CustomDropDownMenu(
            title: AppLocalizations.of(context)!.language,
            textView: configProvider.isEnglish ? "English" : "عربي",
            menuItems: ["English", "عربي"],
            onChange: _onLanguageChange,
          ),
          _buildListTile(
            context,
            icon: Icons.exit_to_app,
            title: AppLocalizations.of(context)!.logout,
            onTap: () => _handleLogOut(context),
          ),
        ],
      ),
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
    // تنفيذ الاشتراك
  }

  void _handleCustomerService(BuildContext context) {
    Navigator.pop(context);
    // تنفيذ خدمة العملاء
  }

  void _handlechatbot(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatBotPage()),
    );
    // تنفيذ الاشتراك
  }

  void _handleTermsAndConditions(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TermsAndConditionsScreen()),
    );
    // عرض الشروط والأحكام
  }

  void _handleHelpCenter(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HelpCenter()),
    );
    // عرض مركز المساعدة
  }

  void _handleLogOut(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
    // تنفيذ تسجيل الخروج
  }

  void _onLanguageChange(String? newLang) {
    configProvider.ChangeAppLanguage(newLang == "English" ? "en" : "ar");
  }
}
