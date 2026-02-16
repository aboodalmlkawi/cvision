import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cvision/cv/data/models/cv_model.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final homeCVsProvider = StreamProvider.autoDispose<List<CVModel>>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (user) {
      print(user);
      if (user == null) {
        return Stream.value([]);
      }
      print(user.uid);
      return FirebaseFirestore.instance.collection('users').doc(user.uid)
          .collection('cvs')
          .snapshots()
          .map((snapshot) {
        final cvs = snapshot.docs.map((doc) {
          try {
            return CVModel.fromMap(doc.data(), doc.id);
          } catch (e) {
            print("⚠️ Error parsing CV (${doc.id}): $e");
            return null;
          }
        })
            .where((element) => element != null)
            .cast<CVModel>()
            .toList();
        cvs.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

        return cvs;
      });
    },
    loading: () => Stream.value([]),
    error: (e, s) {
      print("🔴 Error in homeCVsProvider: $e");
      return Stream.value([]);
    },
  );
});