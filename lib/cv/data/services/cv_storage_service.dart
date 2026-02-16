import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as path;

class CVStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // رفع صورة الملف الشخصي
  Future<String> uploadProfileImage(File imageFile) async {
    final user = _auth.currentUser;
    if (user == null) throw "يجب تسجيل الدخول أولاً";

    try {
      // تحديد مسار الصورة في السيرفر: users/{uid}/profile_pic.jpg
      String fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      Reference ref = _storage.ref().child('users/${user.uid}/images/$fileName');

      // رفع الملف
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      // الحصول على رابط التحميل (URL)
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw "فشل رفع الصورة: $e";
    }
  }

  // حذف صورة قديمة (للتنظيف)
  Future<void> deleteImage(String imageUrl) async {
    try {
      await _storage.refFromURL(imageUrl).delete();
    } catch (e) {
      // تجاهل الخطأ إذا لم تكن الصورة موجودة
      print("Error deleting image: $e");
    }
  }
}