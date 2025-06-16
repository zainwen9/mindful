import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mental_health/core/theme.dart';
import 'package:mental_health/features/auth/domain/entities/auth/googleapisignin.dart';
import 'package:mental_health/features/meditation/presentation/pages/generalSettings/fieldUpdates.dart';
import 'package:mental_health/presentation/onboarding/onboarding.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../resources/app_colors.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> with SingleTickerProviderStateMixin {
  Future<void>? _launched;
  late AnimationController _animationController;
  final List<String> _settingsCategories = [
    'General Settings',
    'Health and Data',
    'Data Storage',
    'API Integrations',
    'Notifications',
    'Support and Feedback',
    'Advanced Settings',
    'Miscellaneous',
    'Help',
    'Invite Others',
    'Logout',
    'Clear Cache',
  ];

  final List<String> _settingsIcons = [
    'assets/essentials/admin.png',
    'assets/essentials/heart.png',
    'assets/essentials/health.png',
    'assets/essentials/api.png',
    'assets/essentials/noti.png',
    'assets/essentials/support.png',
    'assets/essentials/adv.png',
    'assets/essentials/misc.png',
    'assets/essentials/help.png',
    'assets/essentials/invite.png',
    'assets/essentials/logout.png',
    'assets/essentials/clear.png',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _launchInAppWithBrowserOptions(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppBrowserView,
      browserConfiguration: const BrowserConfiguration(showTitle: true),
    )) {
      throw Exception('Could not launch $url');
    }
  }

  void _handleSettingTap(int index) async {
    switch (index) {
      case 0: // General Settings
        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) => upDate()),
        );
        break;
      case 2: // Data Storage
        final Uri toLaunch = Uri(scheme: 'https', host: 'www.postgresql.org', path: '/');
        setState(() {
          _launched = _launchInAppWithBrowserOptions(toLaunch);
        });
        break;
      case 3: // API Integrations
        final Uri toLaunch = Uri(
          scheme: 'https',
          host: 'docs.llama-api.com',
          path: '/essentials/chat',
        );
        setState(() {
          _launched = _launchInAppWithBrowserOptions(toLaunch);
        });
        break;
      case 10: // Logout
        final m = Hive.box('lastlogin');
        if (m.get('google').toString() == "true") {
          m.put('google', 'false');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => const Onboarding()),
                (route) => false,
          );
          await GoogleSignInApi.logout();
        } else {
          await FirebaseAuth.instance.signOut();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => const Onboarding()),
                (route) => false,
          );
        }
        break;
      default:
      // Show a coming soon message for other settings
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: ColorManager.buttonColor,
            content: Text(
              '${_settingsCategories[index]} coming soon!',
              style: TextStyle(color: ColorManager.backgroundColor),
            ),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: _buildProfileCard(),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Text(
                  "Settings",
                  style: TextStyle(
                    color: ColorManager.buttonColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return _buildSettingItem(index);
                  },
                  childCount: _settingsCategories.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 30),
            ),
            SliverToBoxAdapter(
              child: _buildAppInfo(),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 30),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: ColorManager.backgroundColor,
      expandedHeight: 100,
      floating: false,
      pinned: true,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'My Account',
          style: TextStyle(
            color: ColorManager.buttonColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        centerTitle: false,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                ColorManager.bubbleColor.withOpacity(0.2),
                ColorManager.backgroundColor,
              ],
            ),
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: IconButton(
            onPressed: () {},
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ColorManager.bubbleColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                color: ColorManager.buttonColor,
                size: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorManager.bubbleColor.withOpacity(0.7),
            ColorManager.buttonColor.withOpacity(0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ColorManager.buttonColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: ColorManager.backgroundColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
              image: const DecorationImage(
                image: AssetImage('assets/essentials/admin.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Jane Doe",
                  style: TextStyle(
                    color: ColorManager.backgroundColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "jane.doe@example.com",
                  style: TextStyle(
                    color: ColorManager.backgroundColor.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: ColorManager.backgroundColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Premium Member",
                    style: TextStyle(
                      color: ColorManager.backgroundColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ColorManager.backgroundColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.edit_outlined,
              color: ColorManager.backgroundColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(int index) {
    final Animation<double> animation = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        (1 / _settingsCategories.length) * index,
        (1 / _settingsCategories.length) * (index + 1),
        curve: Curves.easeOut,
      ),
    );

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(animation),
      child: FadeTransition(
        opacity: animation,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: ColorManager.bubbleColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: ColorManager.bubbleColor.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () => _handleSettingTap(index),
              splashColor: ColorManager.buttonColor.withOpacity(0.1),
              highlightColor: ColorManager.buttonColor.withOpacity(0.05),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: ColorManager.bubbleColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.asset(
                        _settingsIcons[index],
                        width: 24,
                        height: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        _settingsCategories[index],
                        style: TextStyle(
                          color: ColorManager.buttonColor,
                          fontSize: 16,
                          fontWeight: index == 10 ? FontWeight.bold : FontWeight.w500, // Make logout bold
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: ColorManager.buttonColor.withOpacity(0.7),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: ColorManager.bubbleColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/essentials/set.png',
                    width: 30,
                    height: 30,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Mental Health App",
            style: TextStyle(
              color: ColorManager.buttonColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Version 1.2.0",
            style: TextStyle(
              color: ColorManager.buttonColor.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialButton(Icons.facebook_outlined),
              const SizedBox(width: 16),
              _buildSocialButton(Icons.link),
              const SizedBox(width: 16),
              _buildSocialButton(Icons.email_outlined),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            "© 2025 Mental Health App. All rights reserved.",
            style: TextStyle(
              color: ColorManager.buttonColor.withOpacity(0.5),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: ColorManager.bubbleColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          icon,
          color: ColorManager.buttonColor,
          size: 20,
        ),
      ),
    );
  }
}