import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../providers/theme_provider.dart';
import '../themes/app_themes.dart';

import '../widgets/common/app_drawer_widget.dart';
import '../widgets/common/bottom_navigation_widget.dart';
import '../widgets/common/user_info_widget.dart';
import '../screens/login_screen.dart'; // LoginScreen importu eklendi
import 'notification_settings_screen.dart'; // Bildirim ayarları ekranı importu
import 'help_support_screen.dart'; // Yardım ve Destek ekranı importu
import 'kampuse_ulasim_screen.dart'; // Kampüse Ulaşım ekranı importu
import '../l10n/app_localizations.dart';
import '../providers/language_provider.dart'; // Dil ayarları için provider eklendi
import '../widgets/common/app_bar_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppThemes.getBackgroundColor(context),
      // Navy renkli AppBar / Navy colored AppBar
      appBar: ModernAppBar(
        title: AppLocalizations.of(context)!.profile,
        leading: Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              child: const Icon(Icons.menu, color: Colors.white, size: 24),
            );
          },
        ),
        centerTitle: true,
      ),

      // Ana sayfa drawer'ı / Main drawer
      drawer: const AppDrawerWidget(
        currentPageIndex: AppConstants.navIndexProfile,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Üst kullanıcı bilgi kartı / Top user info card
              _buildUserInfoCard(),

              const SizedBox(height: AppConstants.paddingXLarge),

              // İstatistik kartları başlığı / Stats cards title
              Text(
                AppLocalizations.of(context)!.quickStats,
                style: TextStyle(
                  fontSize: AppConstants.fontSizeXLarge,
                  fontWeight: FontWeight.bold,
                  color: AppThemes.getPrimaryColor(context),
                ),
              ),

              const SizedBox(height: AppConstants.paddingMedium),

              // Yatay kaydırılabilir istatistik kartları / Horizontal scrollable stats cards
              _buildStatsCards(context),

              const SizedBox(height: AppConstants.paddingXLarge),

              // Menü öğeleri başlığı / Menu items title
              Text(
                AppLocalizations.of(context)!.accountSettings,
                style: TextStyle(
                  fontSize: AppConstants.fontSizeXLarge,
                  fontWeight: FontWeight.bold,
                  color: AppThemes.getPrimaryColor(context),
                ),
              ),

              const SizedBox(height: AppConstants.paddingMedium),

              // Menü öğeleri listesi / Menu items list
              _buildMenuItems(),

              const SizedBox(
                height: 80,
              ), // Alt navigasyon için boşluk / Space for bottom navigation
            ],
          ),
        ),
      ),

      // Alt navigasyon çubuğu / Bottom navigation bar
      bottomNavigationBar: const BottomNavigationWidget(
        currentIndex: AppConstants.navIndexProfile,
      ),
    );
  }

  // Kullanıcı bilgi kartı / User info card
  Widget _buildUserInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        color: AppThemes.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: AppThemes.getCardShadow(context),
      ),
      child: const UserInfoWidget(showStudentId: true),
    );
  }

  // İstatistik kartları / Stats cards
  Widget _buildStatsCards(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      height: 94,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildStatCard(
            icon: Icons.event,
            title: l10n.statsEvents,
            value: '12',
            color: Colors.blue,
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            icon: Icons.school,
            title: l10n.statsGpa,
            value: '3.67',
            color: Colors.green,
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            icon: Icons.feedback,
            title: l10n.statsComplaints,
            value: '2',
            color: Colors.orange,
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            icon: Icons.assignment,
            title: l10n.statsAssignments,
            value: '28',
            color: Colors.purple,
          ),
        ],
      ),
    );
  }

  // İstatistik kartı / Stat card
  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(
        AppConstants.paddingSmall + 2,
      ), // Reduced padding
      decoration: BoxDecoration(
        color: AppThemes.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        boxShadow: AppThemes.getCardShadow(context),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 28, // Reduced from 32 to 28
            height: 28, // Reduced from 32 to 28
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 18, // Reduced from 20 to 18
            ),
          ),
          const SizedBox(height: 4), // Reduced from 6 to 4
          Text(
            value,
            style: TextStyle(
              fontSize: 16, // Reduced from 18 to 16
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10, // Reduced from 11 to 10
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Bayrak butonu (LoginScreen'den alınan)
  Widget _buildFlagButton({
    required String imagePath,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Image.asset(imagePath, width: 38, height: 28, fit: BoxFit.cover),
      ),
    );
  }

  // Menü öğeleri / Menu items
  Widget _buildMenuItems() {
    final languageProvider = Provider.of<LanguageProvider>(context);
    return Container(
      decoration: BoxDecoration(
        color: AppThemes.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        boxShadow: AppThemes.getCardShadow(context),
      ),
      child: Column(
        children: [
          _buildDivider(),
          // Dil seçici
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              ),
              child: Icon(
                Icons.language,
                color: AppConstants.primaryColor,
                size: 20,
              ),
            ),
            title: Text(
              AppLocalizations.of(context)!.language,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppThemes.getTextColor(context),
              ),
            ),
            subtitle: Text(
              AppLocalizations.of(context)!.languageDesc,
              style: TextStyle(
                fontSize: 12,
                color: AppThemes.getSecondaryTextColor(context),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildFlagButton(
                  imagePath: 'assets/images/turkey.png',
                  isSelected: languageProvider.locale.languageCode == 'tr',
                  onTap: () => languageProvider.setLocale(const Locale('tr')),
                ),
                const SizedBox(width: 8),
                _buildFlagButton(
                  imagePath: 'assets/images/uk.png',
                  isSelected: languageProvider.locale.languageCode == 'en',
                  onTap: () => languageProvider.setLocale(const Locale('en')),
                ),
              ],
            ),
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.notifications,
            title: AppLocalizations.of(context)!.notificationSettings,
            subtitle: AppLocalizations.of(context)!.notificationSettingsDesc,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationSettingsScreen(),
                ),
              );
            },
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.help,
            title: AppLocalizations.of(context)!.helpSupport,
            subtitle: AppLocalizations.of(context)!.helpSupportDesc,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HelpSupportScreen(),
                ),
              );
            },
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.directions_bus,
            title: AppLocalizations.of(context)!.campusTransport,
            subtitle: AppLocalizations.of(context)!.campusTransportDesc,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const KampuseUlasimScreen(),
                ),
              );
            },
          ),
          _buildDivider(),
          _buildThemeToggleItem(),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.logout,
            title: AppLocalizations.of(context)!.logout,
            subtitle: AppLocalizations.of(context)!.logoutDesc,
            iconColor: Colors.red,
            textColor: Colors.red,
            onTap: () {
              _showLogoutDialog();
            },
          ),
        ],
      ),
    );
  }

  // Menü öğesi / Menu item
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: (iconColor ?? AppConstants.primaryColor).withValues(
            alpha: 0.1,
          ),
          borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
        ),
        child: Icon(
          icon,
          color: iconColor ?? AppConstants.primaryColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textColor ?? AppThemes.getTextColor(context),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: AppThemes.getSecondaryTextColor(context),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey[400],
      ),
      onTap: onTap,
    );
  }

  // Tema değiştirme öğesi / Theme toggle item
  Widget _buildThemeToggleItem() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppThemes.getPrimaryColor(context).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            ),
            child: Icon(
              themeProvider.themeIcon,
              color: AppThemes.getPrimaryColor(context),
              size: 20,
            ),
          ),
          title: Text(
            AppLocalizations.of(context)!.theme,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppThemes.getTextColor(context),
            ),
          ),
          subtitle: Text(
            AppLocalizations.of(context)!.themeDesc,
            style: TextStyle(
              fontSize: 12,
              color: AppThemes.getSecondaryTextColor(context),
            ),
          ),
          trailing: Switch(
            value: themeProvider.isDarkMode,
            onChanged: (value) async {
              await themeProvider.toggleTheme();
            },
            activeColor: AppThemes.getPrimaryColor(context),
          ),
          onTap: () async {
            await themeProvider.toggleTheme();
          },
        );
      },
    );
  }

  // Ayırıcı çizgi / Divider
  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: AppThemes.getSecondaryTextColor(context).withValues(alpha: 0.3),
      indent: 72,
      endIndent: 16,
    );
  }

  // Çıkış yapma dialog'u / Logout dialog
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.logout,
            style: const TextStyle(color: AppConstants.primaryColor),
          ),
          content: Text(AppLocalizations.of(context)!.logoutConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Çıkış yap ve giriş ekranına yönlendir
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(AppLocalizations.of(context)!.logout),
            ),
          ],
        );
      },
    );
  }
}
