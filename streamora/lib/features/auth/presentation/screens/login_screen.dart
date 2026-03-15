import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../providers/auth_provider.dart';
import '../widgets/m3u_import_dialog.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _serverUrlController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isM3UImport = false;

  @override
  void dispose() {
    _serverUrlController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      
      if (_isM3UImport) {
        ref.read(authNotifierProvider.notifier).loginWithM3U(
          m3uUrl: _serverUrlController.text.trim(),
        );
      } else {
        ref.read(authNotifierProvider.notifier).login(
          serverUrl: _serverUrlController.text.trim().removeTrailingSlash,
          username: _usernameController.text.trim(),
          password: _passwordController.text,
        );
      }
    }
  }

  void _showM3UImportDialog() {
    showDialog(
      context: context,
      builder: (context) => M3UImportDialog(
        onImport: (url) {
          setState(() {
            _isM3UImport = true;
            _serverUrlController.text = url;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen(authNotifierProvider, (previous, next) {
      next.whenOrNull(
        error: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: AppColors.error,
            ),
          );
        },
      );
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
                  Container(
                    width: 100.w,
                    height: 100.h,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Icon(
                      Icons.play_circle_filled,
                      size: 50.w,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Title
                  Text(
                    'Streamora',
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimaryDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Your Premium IPTV Experience',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.textSecondaryDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 48.h),

                  // Toggle between Xtream Codes and M3U
                  SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment(
                        value: false,
                        label: Text('Xtream Codes'),
                        icon: Icon(Icons.login),
                      ),
                      ButtonSegment(
                        value: true,
                        label: Text('M3U URL'),
                        icon: Icon(Icons.link),
                      ),
                    ],
                    selected: {_isM3UImport},
                    onSelectionChanged: (value) {
                      setState(() {
                        _isM3UImport = value.first;
                        _serverUrlController.clear();
                      });
                    },
                  ),
                  SizedBox(height: 24.h),

                  // Server URL / M3U URL Field
                  TextFormField(
                    controller: _serverUrlController,
                    keyboardType: TextInputType.url,
                    textInputAction: _isM3UImport ? TextInputAction.done : TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: _isM3UImport ? 'M3U URL' : 'Server URL',
                      hintText: _isM3UImport
                          ? 'http://example.com/get.php?username=...'
                          : 'http://example.com:port',
                      prefixIcon: Icon(
                        _isM3UImport ? Icons.link : Icons.dns,
                        color: AppColors.textTertiaryDark,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return _isM3UImport
                            ? 'Please enter M3U URL'
                            : 'Please enter server URL';
                      }
                      if (!value.startsWith('http://') &&
                          !value.startsWith('https://')) {
                        return 'URL must start with http:// or https://';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) {
                      if (!_isM3UImport) {
                        FocusScope.of(context).nextFocus();
                      } else {
                        _login();
                      }
                    },
                  ),
                  SizedBox(height: 16.h),

                  // Username and Password fields (only for Xtream Codes)
                  if (!_isM3UImport) ...[
                    TextFormField(
                      controller: _usernameController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        hintText: 'Enter your username',
                        prefixIcon: Icon(
                          Icons.person,
                          color: AppColors.textTertiaryDark,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter username';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    ),
                    SizedBox(height: 16.h),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: AppColors.textTertiaryDark,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.textTertiaryDark,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _login(),
                    ),
                    SizedBox(height: 24.h),
                  ],

                  // Login Button
                  SizedBox(
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: authState.maybeWhen(
                        loading: () => null,
                        orElse: () => _login,
                      ),
                      child: authState.maybeWhen(
                        loading: () => const LoadingWidget(),
                        orElse: () => const Text('Connect'),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Help text
                  TextButton(
                    onPressed: _showM3UImportDialog,
                    child: const Text('Need help importing your playlist?'),
                  ),

                  // Privacy note
                  SizedBox(height: 24.h),
                  Text(
                    'Your credentials are securely stored on your device only.',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textTertiaryDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension on String {
  String get removeTrailingSlash {
    if (endsWith('/')) return substring(0, length - 1);
    return this;
  }
}
