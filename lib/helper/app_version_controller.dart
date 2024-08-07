import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppVersionController {
  Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    return version;
  }

  void _launchUpdateLink() async {
    const url = 'https://t.me/+B8QR3XcJ7r5lMmQ0';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<bool> checkLatestVersion() async {
    String currentVersion = await getAppVersion();
    final response = await Api().get(path: 'api/version', queryParams: {
      'current_version': currentVersion,
    });
    if (response == null) {
      return false;
    }
    final responseBody = response['body'];
    String? latestVersion = responseBody['latest_version'];
    int? currentVersionIsWork = responseBody['current_version_is_work'];
    if (currentVersion == latestVersion) {
      return true;
    }
    if (currentVersionIsWork == 1) {
      await showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          title: const Text("تحديث متاح"),
          content: Text("الأصدار ($latestVersion) أصبح متاح الرجاء التحديث."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text('لاحقاً'),
            ),
            TextButton(
              onPressed: () {
                _launchUpdateLink(); 
              },
              child: const Text('تحديث'),
            ),
          ],
        ),
      );
      return true;
    }
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text("تحديث متاح"),
        content: const Text(
            "عذراً هذا الأصدار أصبح قديم الرجاء التحديث ثم إعادة المحاولة."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );

    return false;
  }
}
