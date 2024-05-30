import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScanner {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final TextEditingController _errorImeiController = TextEditingController();
  final TextEditingController _imeiController = TextEditingController();
  QRViewController? controller;

  Future<String> scanQR() async {
    await showScanQRDialog();
    return _imeiController.text == "Unknown" ? "" : _imeiController.text;
  }

  Future<void> showScanQRDialog() async {
    await showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: const Text('Scan IMEI QR Code')),
          body: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 10,
                borderWidth: 10,
                cutOutHeight: 100,
                cutOutWidth: 400),
          ),
        );
      },
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      String imei = extractImei(scanData.code!);
      _imeiController.text = imei;
      if (imei != 'Unknown') {
        ScaffoldMessenger.of(Get.context!).clearSnackBars();
        controller.pauseCamera();
        // Navigator.of(Get.context!).pop();
        Get.back();
      } else {
        if (scanData.code != _errorImeiController.text) {
          _errorImeiController.text = scanData.code!;
          _showErrorMessage("الرجاء توجيه العدسة فقط الى IMEI", "خطأ بالقراءة");
        }
      }
    });
  }

  void _showErrorMessage(String message, String title) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(
          '$title: $message',
          textDirection: TextDirection.rtl,
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  String extractImei(String qrData) {
    final imeiPattern = RegExp(r'\b\d{15}\b');
    final match = imeiPattern.firstMatch(qrData);
    if (match != null) {
      return match.group(0) ?? 'Unknown';
    } else {
      return 'Unknown';
    }
  }
}
