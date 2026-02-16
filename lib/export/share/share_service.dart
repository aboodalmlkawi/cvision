import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ShareService {

  static Future<void> sharePdf(Uint8List bytes, String fileName) async {
    try {
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/$fileName.pdf');

      await file.writeAsBytes(bytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'إليك سيرتي الذاتية التي تم إنشاؤها عبر تطبيق CVision 🚀',
      );
    } catch (e) {
      print("Error sharing file: $e");
      throw "فشل في مشاركة الملف";
    }
  }

}