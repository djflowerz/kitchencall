import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppLauncher {
  AppLauncher._();

  static Future<void> call(BuildContext context, String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    final launched = await launchUrl(uri);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open dialer for $phoneNumber')),
      );
    }
  }

  static Future<void> email(BuildContext context, String address) async {
    final uri = Uri(scheme: 'mailto', path: address);
    final launched = await launchUrl(uri);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open mail app for $address')),
      );
    }
  }
}
