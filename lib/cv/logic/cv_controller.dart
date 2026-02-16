import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cvision/cv/data/models/cv_model.dart';

final cvControllerProvider = StateNotifierProvider<CVController, AsyncValue<List<CVModel>>>((ref) {
  return CVController();
});

class CVController extends StateNotifier<AsyncValue<List<CVModel>>> {
  CVController() : super(const AsyncValue.loading()) {
    fetchCVs();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> fetchCVs() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        state = const AsyncValue.data([]);
        return;
      }

      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cvs')
          .orderBy('createdAt', descending: true)
          .get();

      final cvs = snapshot.docs.map((doc) => CVModel.fromMap(doc.data(), doc.id)).toList();
      state = AsyncValue.data(cvs);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> saveCV(CVModel cv) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cvs')
          .doc(cv.id)
          .set(cv.toMap());

      final currentList = state.value ?? [];
      final index = currentList.indexWhere((element) => element.id == cv.id);

      if (index != -1) {
        currentList[index] = cv;
        state = AsyncValue.data([...currentList]);
      } else {
        state = AsyncValue.data([cv, ...currentList]);
      }
    } catch (e) {
      print("Error saving CV: $e");
    }
  }

  Future<void> deleteCV(String cvId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cvs')
          .doc(cvId)
          .delete();

      final currentList = state.value ?? [];
      currentList.removeWhere((cv) => cv.id == cvId);
      state = AsyncValue.data([...currentList]);
    } catch (e) {
      print("Error deleting CV: $e");
    }
  }
}