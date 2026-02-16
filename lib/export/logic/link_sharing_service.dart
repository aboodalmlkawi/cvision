import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

class LinkSharingService {
  static Future<String> uploadAndGetLink(Uint8List pdfBytes, String fileName) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('shared_cvs/$fileName.pdf');


      await storageRef.putData(pdfBytes, SettableMetadata(contentType: 'application/pdf'));

      String downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw "فشل في رفع الملف: $e";
    }
  }
}