import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html; // Only for web

// Google Drive Resume Download Handler
class GoogleDriveResumeDownload {
  // Replace this with your actual Google Drive file ID
  static const String _fileId = '1iGQEj584o07oRUWl-itWKDfG9VHfBNy5'; // Fixed: removed /view from the end

  // Direct download URL for Google Drive
  static const String _downloadUrl = 'https://drive.google.com/uc?export=download&id=$_fileId';

  // View URL for Google Drive (fallback)
  static const String _viewUrl = 'https://drive.google.com/file/d/$_fileId/view';

  static Future<void> downloadResume(BuildContext? context) async {
    HapticFeedback.lightImpact();

    try {
      if (kIsWeb) {
        // For web - trigger direct download
        _downloadForWeb();
      } else {
        // For mobile - open in browser with download prompt
        await _downloadForMobile();
      }

      // Show success message if context is available
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Resume download started!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error downloading resume: $e');

      // Show error message if context is available
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to download. Please try again.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  static void _downloadForWeb() {
    // Create invisible anchor element and trigger download
    final anchor = html.AnchorElement(href: _downloadUrl)
      ..setAttribute('download', 'Farooq_Sarwar_Resume.pdf')
      ..style.display = 'none';

    html.document.body!.children.add(anchor);
    anchor.click();
    html.document.body!.children.remove(anchor);
  }

  static Future<void> _downloadForMobile() async {
    // Try download URL first, fallback to view URL
    try {
      if (await canLaunchUrl(Uri.parse(_downloadUrl))) {
        await launchUrl(
          Uri.parse(_downloadUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw Exception('Cannot launch download URL');
      }
    } catch (e) {
      // Fallback to view URL
      if (await canLaunchUrl(Uri.parse(_viewUrl))) {
        await launchUrl(
          Uri.parse(_viewUrl),
          mode: LaunchMode.externalApplication,
        );
      }
    }
  }
}
