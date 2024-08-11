import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/helper/shared_perferences.dart';
import 'package:graduation_mobile/models/device_model.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:share/share.dart';

class DeviceReportController {
  Future<Uint8List> createPdfReport(Device device) async {
    final pdf = pw.Document();
    final arabicFontData =
        await rootBundle.load('assets/fonts/NotoNaskhArabic-Regular.ttf');
    final englishFontData =
        await rootBundle.load('assets/fonts/NotoSans-Regular.ttf');

    final arabicFont = pw.Font.ttf(arabicFontData);
    final englishFont = pw.Font.ttf(englishFontData);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy_MM_dd HH:mm').format(now);
    String? centerName = await InstanceSharedPrefrences().getCenterName();
    pdf.addPage(
      pw.Page(
        theme: pw.ThemeData.withFont(
          base: englishFont,
          bold: englishFont,
          italic: englishFont,
          boldItalic: englishFont,
        ),
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  'وصل استلام جهاز جاهز من المركز',
                  style: pw.TextStyle(
                    font: arabicFont,
                    fontSize: 24,
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'تحية طيبة سيد ${device.customer?.name} ${device.customer?.lastName}\nتم استلام الجهاز من قبل حضرتكم بتاريخ $formattedDate',
                  style: pw.TextStyle(
                    font: arabicFont,
                    fontSize: 16,
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
                pw.Text(
                  'نوع الهاتف: ${device.model}',
                  style: pw.TextStyle(
                    font: arabicFont,
                    fontSize: 16,
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'كود الهاتف: ${device.code}',
                  style: pw.TextStyle(
                    font: arabicFont,
                    fontSize: 16,
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
                pw.Text(
                  'التكلفة: ${device.costToCustomer ?? 'لم يتم تحديدها'}',
                  style: pw.TextStyle(
                    font: arabicFont,
                    fontSize: 16,
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
                pw.Text(
                  'تنتهي كفالة هذا الجهاز بتاريخ: ${device.customerDateWarranty?.toLocal().toString().split(' ')[0] ?? 'لم يتم تحديدها'}',
                  style: pw.TextStyle(
                    font: arabicFont,
                    fontSize: 16,
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'شكراً لزيارتكم \n $centerName',
                  style: pw.TextStyle(
                    font: arabicFont,
                    fontSize: 20,
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
              ],
            ),
          );
        },
      ),
    );

    return await pdf.save();
  }

  Future<void> showReportPreview(Device device) async {
    Uint8List pdfData = await createPdfReport(device);
    Navigator.pop(Get.context!, true);

    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('وصل كفالة تسليم الجهاز'),
          content: SizedBox(
            width: 400,
            height: 600,
            child: PdfPreview(
              build: (format) => pdfData,
              canChangeOrientation: false,
              canChangePageFormat: false,
              canDebug: false,
              allowSharing: false,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('مشاركة'),
              onPressed: () async {
                final output = await getTemporaryDirectory();
                final filePath = '${output.path}/report.pdf';
                final customerPhoneNumber =
                    '+963${device.customer?.phone.substring(1)}';
                final File file = File(filePath);
                await file.writeAsBytes(pdfData);
                await Clipboard.setData(
                    ClipboardData(text: customerPhoneNumber));
                ScaffoldMessenger.of(Get.context!).showSnackBar(
                  const SnackBar(
                    content: Text('تم النسخ رقم الزبون الى الحافظة'),
                    duration: Duration(milliseconds: 1500),
                    backgroundColor: Color.fromRGBO(250, 10, 0, 1),
                  ),
                );
                Share.shareFiles([filePath],
                    text: 'وصل استلام جهاز', subject: 'PDF Document');

                Navigator.of(Get.context!).pop();
              },
            ),
            TextButton(
              child: const Text('الغاء'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
