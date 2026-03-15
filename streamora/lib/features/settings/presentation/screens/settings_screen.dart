import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // Account Section
          _buildSectionHeader('Account'),
          authState.whenOrNull(
            authenticated: (user, credentials) => Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Username'),
                  subtitle: Text(user.username),
                ),
                ListTile(
                  leading: const Icon(Icons.dns),
                  title: const Text('Server'),
                  subtitle: Text(credentials?.serverUrl ?? 'Unknown'),
                ),
                ListTile(
                  leading: Icon(
                    user.isActive ? Icons.check_circle : Icons.error,
                    color: user.isActive ? AppColors.success : AppColors.error,
                  ),
                  title: const Text('Status'),
                  subtitle: Text(user.status),
                ),
                if (user.expDate.isNotEmpty)
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Expires'),
                    subtitle: Text(user.expDate),
                  ),
              ],
            ),
          ) ?? const SizedBox.shrink(),
          const Divider(),

          // Preferences Section
          _buildSectionHeader('Preferences'),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            subtitle: const Text('Use dark theme'),
            value: true,
            onChanged: (value) {},
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: const Text('English'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          const Divider(),

          // Playback Section
          _buildSectionHeader('Playback'),
          ListTile(
            leading: const Icon(Icons.speed),
            title: const Text('Default Playback Speed'),
            subtitle: const Text('1.0x'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          SwitchListTile(
            secondary: const Icon(Icons.auto_play),
            title: const Text('Auto-play Next Episode'),
            subtitle: const Text('Automatically play next episode in series'),
            value: true,
            onChanged: (value) {},
          ),
          const Divider(),

          // Data Section
          _buildSectionHeader('Data'),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Clear Cache'),
            subtitle: const Text('Free up storage space'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear Cache'),
                  content: const Text('Are you sure you want to clear all cached data?'),
                  actions: [
                    TextButton(onPressed: () => context.pop(), child: const Text('Cancel')),
                    ElevatedButton(onPressed: () => context.pop(), child: const Text('Clear')),
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Clear Watch History'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          const Divider(),

          // About Section
          _buildSectionHeader('About'),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About Streamora'),
            subtitle: const Text('Version 1.0.0'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          const Divider(),

          // Logout
          Padding(
            padding: EdgeInsets.all(16.w),
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(onPressed: () => context.pop(), child: const Text('Cancel')),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(authNotifierProvider.notifier).logout();
                          context.pop();
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, minimumSize: Size(double.infinity, 48.h)),
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.primary),
      ),
    );
  }
}
