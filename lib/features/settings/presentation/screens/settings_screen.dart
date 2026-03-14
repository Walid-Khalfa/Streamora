import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Account'),
            _buildSettingsCard([
              _buildSettingsTile(
                icon: Icons.person,
                iconColor: AppColors.primary,
                title: 'Profile',
                subtitle: 'Manage your account',
                onTap: () {},
              ),
              _buildSettingsTile(
                icon: Icons.account_balance_wallet,
                iconColor: AppColors.accent,
                title: 'Subscription',
                subtitle: 'Active until Dec 2024',
                onTap: () {},
              ),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle('Preferences'),
            _buildSettingsCard([
              _buildSettingsTile(
                icon: Icons.dark_mode,
                iconColor: AppColors.vodColor,
                title: 'Dark Mode',
                subtitle: 'Always enabled',
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                  activeColor: AppColors.primary,
                ),
              ),
              _buildSettingsTile(
                icon: Icons.notifications,
                iconColor: AppColors.liveColor,
                title: 'Notifications',
                subtitle: 'Get updates about new content',
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                  activeColor: AppColors.primary,
                ),
              ),
              _buildSettingsTile(
                icon: Icons.lock,
                iconColor: AppColors.seriesColor,
                title: 'Parental Control',
                subtitle: 'Restrict mature content',
                onTap: () {},
              ),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle('Playback'),
            _buildSettingsCard([
              _buildSettingsTile(
                icon: Icons.hd,
                iconColor: AppColors.accent,
                title: 'Video Quality',
                subtitle: 'Auto (Recommended)',
                onTap: () {},
              ),
              _buildSettingsTile(
                icon: Icons.subtitles,
                iconColor: AppColors.warning,
                title: 'Subtitles',
                subtitle: 'Auto-detect',
                onTap: () {},
              ),
              _buildSettingsTile(
                icon: Icons.language,
                iconColor: AppColors.info,
                title: 'Audio Language',
                subtitle: 'English',
                onTap: () {},
              ),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle('About'),
            _buildSettingsCard([
              _buildSettingsTile(
                icon: Icons.info,
                iconColor: AppColors.textSecondary,
                title: 'About Streamora',
                subtitle: 'Version 1.0.0',
                onTap: () {},
              ),
              _buildSettingsTile(
                icon: Icons.privacy_tip,
                iconColor: AppColors.textSecondary,
                title: 'Privacy Policy',
                onTap: () {},
              ),
              _buildSettingsTile(
                icon: Icons.help,
                iconColor: AppColors.textSecondary,
                title: 'Help & Support',
                onTap: () {},
              ),
            ]),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Logout
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surface,
                  foregroundColor: AppColors.error,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text(
                      'Sign Out',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.textTertiary.withOpacity(0.8),
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: _addDividers(children),
      ),
    );
  }

  List<Widget> _addDividers(List<Widget> children) {
    final result = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1) {
        result.add(
          const Divider(
            color: AppColors.backgroundLighter,
            height: 1,
            indent: 68,
          ),
        );
      }
    }
    return result;
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                color: AppColors.textTertiary.withOpacity(0.8),
                fontSize: 13,
              ),
            )
          : null,
      trailing: trailing ??
          (onTap != null
              ? const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textTertiary,
                  size: 16,
                )
              : null),
    );
  }
}
