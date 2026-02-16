import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class PdfHelper {

  // Save the PDF file temporarily for sharing or viewing
  static Future<File> saveDocument({
    required String name,
    required Uint8List bytes,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);
    return file;
  }

  // Share the PDF file directly (Share)
  static Future<void> sharePdf(Uint8List bytes, String fileName) async {
    final file = await saveDocument(name: fileName, bytes: bytes);

    // Using the share_plus library for sharing
    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'إليك سيرتي الذاتية التي تم إنشاؤها عبر تطبيق CVision',
    );
  }
}