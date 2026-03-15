import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/network/api_client.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// Settings state providers
final darkModeProvider = StateProvider<bool>((ref) => true);
final notificationsProvider = StateProvider<bool>((ref) => true);
final videoQualityProvider = StateProvider<String>((ref) => 'Auto');
final subtitlesProvider = StateProvider<String>((ref) => 'Auto');
final audioLanguageProvider = StateProvider<String>((ref) => 'English');

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(darkModeProvider);
    final notifications = ref.watch(notificationsProvider);
    final videoQuality = ref.watch(videoQualityProvider);
    final subtitles = ref.watch(subtitlesProvider);
    final audioLanguage = ref.watch(audioLanguageProvider);
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Section
            _buildSectionTitle('Account'),
            _buildSettingsCard([
              _buildSettingsTile(
                icon: Icons.person,
                iconColor: AppColors.primary,
                title: 'Profile',
                subtitle: 'Manage your account',
                onTap: () => _showProfileDialog(context),
              ),
              _buildSettingsTile(
                icon: Icons.account_balance_wallet,
                iconColor: AppColors.accent,
                title: 'Subscription',
                subtitle: authState.user?.expiryDate != null
                    ? 'Active until ${_formatDate(authState.user!.expiryDate!)}'
                    : 'Check your subscription',
                onTap: () => _showSubscriptionDialog(context),
              ),
            ]),
            const SizedBox(height: 24),

            // Preferences Section
            _buildSectionTitle('Preferences'),
            _buildSettingsCard([
              _buildSwitchTile(
                icon: Icons.dark_mode,
                iconColor: AppColors.vodColor,
                title: 'Dark Mode',
                subtitle: 'Always enabled',
                value: darkMode,
                onChanged: (value) {
                  ref.read(darkModeProvider.notifier).state = value;
                },
              ),
              _buildSwitchTile(
                icon: Icons.notifications,
                iconColor: AppColors.liveColor,
                title: 'Notifications',
                subtitle: 'Get updates about new content',
                value: notifications,
                onChanged: (value) {
                  ref.read(notificationsProvider.notifier).state = value;
                },
              ),
              _buildSettingsTile(
                icon: Icons.lock,
                iconColor: AppColors.seriesColor,
                title: 'Parental Control',
                subtitle: 'Restrict mature content',
                onTap: () => _showParentalControlDialog(context),
              ),
            ]),
            const SizedBox(height: 24),

            // Playback Section
            _buildSectionTitle('Playback'),
            _buildSettingsCard([
              _buildSettingsTile(
                icon: Icons.hd,
                iconColor: AppColors.accent,
                title: 'Video Quality',
                subtitle: videoQuality,
                onTap: () => _showVideoQualityDialog(context, ref),
              ),
              _buildSettingsTile(
                icon: Icons.subtitles,
                iconColor: AppColors.warning,
                title: 'Subtitles',
                subtitle: subtitles,
                onTap: () => _showSubtitlesDialog(context, ref),
              ),
              _buildSettingsTile(
                icon: Icons.language,
                iconColor: AppColors.info,
                title: 'Audio Language',
                subtitle: audioLanguage,
                onTap: () => _showAudioLanguageDialog(context, ref),
              ),
            ]),
            const SizedBox(height: 24),

            // Storage Section
            _buildSectionTitle('Storage'),
            _buildSettingsCard([
              _buildSettingsTile(
                icon: Icons.cached,
                iconColor: AppColors.textSecondary,
                title: 'Clear Cache',
                subtitle: 'Free up storage space',
                onTap: () => _showClearCacheDialog(context, ref),
              ),
              _buildSettingsTile(
                icon: Icons.delete_outline,
                iconColor: AppColors.error,
                title: 'Clear Downloaded Data',
                subtitle: 'Remove all downloaded content',
                onTap: () => _showClearDownloadsDialog(context, ref),
              ),
            ]),
            const SizedBox(height: 24),

            // About Section
            _buildSectionTitle('About'),
            _buildSettingsCard([
              _buildSettingsTile(
                icon: Icons.info,
                iconColor: AppColors.textSecondary,
                title: 'About Streamora',
                subtitle: 'Version 1.0.0',
                onTap: () => _showAboutDialog(context),
              ),
              _buildSettingsTile(
                icon: Icons.privacy_tip,
                iconColor: AppColors.textSecondary,
                title: 'Privacy Policy',
                onTap: () {
                  // Navigate to privacy policy
                },
              ),
              _buildSettingsTile(
                icon: Icons.description,
                iconColor: AppColors.textSecondary,
                title: 'Terms of Service',
                onTap: () {
                  // Navigate to terms
                },
              ),
              _buildSettingsTile(
                icon: Icons.help,
                iconColor: AppColors.textSecondary,
                title: 'Help & Support',
                onTap: () => _showHelpDialog(context),
              ),
            ]),
            const SizedBox(height: 32),

            // Sign Out Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => _showSignOutDialog(context, ref),
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
      trailing: onTap != null
          ? const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textTertiary,
              size: 16,
            )
          : null,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
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
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: AppColors.textTertiary.withOpacity(0.8),
          fontSize: 13,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Profile', style: TextStyle(color: AppColors.textPrimary)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              'User Account',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Premium User',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSubscriptionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Subscription', style: TextStyle(color: AppColors.textPrimary)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.workspace_premium, size: 48, color: AppColors.accent),
            SizedBox(height: 16),
            Text(
              'Premium Active',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Expires: December 31, 2024',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showParentalControlDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Parental Control', style: TextStyle(color: AppColors.textPrimary)),
        content: const Text(
          'Parental control settings will be available in a future update.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showVideoQualityDialog(BuildContext context, WidgetRef ref) {
    final qualities = ['Auto', '1080p', '720p', '480p', '360p'];
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Video Quality',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ...qualities.map((quality) => ListTile(
              title: Text(quality, style: const TextStyle(color: AppColors.textPrimary)),
              trailing: quality == ref.read(videoQualityProvider)
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                ref.read(videoQualityProvider.notifier).state = quality;
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
    );
  }

  void _showSubtitlesDialog(BuildContext context, WidgetRef ref) {
    final options = ['Auto', 'English', 'French', 'Spanish', 'Off'];
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Subtitles',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ...options.map((option) => ListTile(
              title: Text(option, style: const TextStyle(color: AppColors.textPrimary)),
              trailing: option == ref.read(subtitlesProvider)
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                ref.read(subtitlesProvider.notifier).state = option;
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
    );
  }

  void _showAudioLanguageDialog(BuildContext context, WidgetRef ref) {
    final languages = ['English', 'French', 'Spanish', 'German', 'Italian'];
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Audio Language',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ...languages.map((lang) => ListTile(
              title: Text(lang, style: const TextStyle(color: AppColors.textPrimary)),
              trailing: lang == ref.read(audioLanguageProvider)
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                ref.read(audioLanguageProvider.notifier).state = lang;
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear Cache', style: TextStyle(color: AppColors.textPrimary)),
        content: const Text(
          'This will clear all cached data. Are you sure?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final apiClient = ref.read(apiClientProvider);
                await apiClient.clearCache();
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cache cleared successfully')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to clear cache: $e')),
                  );
                }
              }
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showClearDownloadsDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear Downloads', style: TextStyle(color: AppColors.textPrimary)),
        content: const Text(
          'This will delete all downloaded content. This action cannot be undone.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement actual download clearing when download feature is added
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloads cleared successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.play_circle_fill, color: AppColors.primary, size: 32),
            SizedBox(width: 12),
            Text('Streamora', style: TextStyle(color: AppColors.textPrimary)),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version 1.0.0',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            SizedBox(height: 16),
            Text(
              'Streamora is a premium cross-platform IPTV player app built with Flutter.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Help & Support', style: TextStyle(color: AppColors.textPrimary)),
        content: const Text(
          'For help and support, please visit our website or contact us via email.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sign Out', style: TextStyle(color: AppColors.textPrimary)),
        content: const Text(
          'Are you sure you want to sign out?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              Navigator.pop(context);
              context.go(AppRouter.login);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
