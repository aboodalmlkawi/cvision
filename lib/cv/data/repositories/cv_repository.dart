import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../firestore_service.dart';
import '../models/cv_model.dart';

final cvRepositoryProvider = Provider<CVRepository>((ref) {
  return CVRepository();
});

class CVRepository {
  final FirestoreService _firestoreService;

  CVRepository({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  Future<void> saveCV(CVModel cv) async {
    try {
      await _firestoreService.saveCV(cv);
    } catch (e) {
      throw "فشل في حفظ السيرة الذاتية: $e";
    }
  }

  Stream<List<CVModel>> getUserCVs() {
    return _firestoreService.getUserCVs();
  }

  Future<void> deleteCV(String cvId) async {
    try {
      await _firestoreService.deleteCV(cvId);
    } catch (e) {
      throw "فشل في حذف السيرة الذاتية: $e";
    }
  }
}