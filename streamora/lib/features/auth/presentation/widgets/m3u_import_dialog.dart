import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class M3UImportDialog extends StatelessWidget {
  final Function(String) onImport;

  const M3UImportDialog({
    super.key,
    required this.onImport,
  });

  @override
  Widget build(BuildContext context) {
    final urlController = TextEditingController();

    return AlertDialog(
      title: Text(
        'Import M3U Playlist',
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Paste your M3U playlist URL below. The app will automatically extract your login credentials.',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondaryDark,
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: urlController,
              maxLines: 3,
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                hintText: 'http://example.com/get.php?username=...&password=...',
                hintStyle: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textTertiaryDark,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Supported formats:',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            _buildFormatItem('M3U Plus URL'),
            _buildFormatItem('Xtream Codes API URL'),
            _buildFormatItem('Standard M3U playlist URL'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final url = urlController.text.trim();
            if (url.isNotEmpty) {
              onImport(url);
              context.pop();
            }
          },
          child: const Text('Import'),
        ),
      ],
    );
  }

  Widget _buildFormatItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: 14.w,
            color: AppColors.success,
          ),
          SizedBox(width: 8.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondaryDark,
            ),
          ),
        ],
      ),
    );
  }
}

class QRScannerButton extends StatelessWidget {
  final Function(String) onScan;

  const QRScannerButton({
    super.key,
    required this.onScan,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        // QR scanning functionality would be implemented here
        // For now, show a placeholder
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('QR Scanner'),
            content: const Text('QR code scanning will be available in a future update.'),
            actions: [
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
      icon: const Icon(Icons.qr_code_scanner),
      label: const Text('Scan QR Code'),
    );
  }
}
