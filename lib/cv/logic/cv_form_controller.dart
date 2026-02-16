import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/cv_model.dart';
import '../data/repositories/cv_repository.dart';
import 'cv_controller.dart';

final cvFormProvider = StateNotifierProvider.autoDispose<CVFormController, AsyncValue<void>>((ref) {
  return CVFormController(ref.watch(cvRepositoryProvider));
});

class CVFormController extends StateNotifier<AsyncValue<void>> {
  final CVRepository _repository;

  CVFormController(this._repository) : super(const AsyncValue.data(null));

  Future<bool> saveCV({
    required String? id,
    required String fullName,
    required String email,
    required String phone,
    required String summary,
    required List<String> skills,
    required List<Education> education,
    required List<Experience> experience,
    required DateTime? createdAt,
    required String userId,
  }) async {
    state = const AsyncValue.loading();
    try {
      final cv = CVModel(
        id: id ?? '',
        userId: userId,
        personalInfo: PersonalInfo(
          fullName: fullName,
          email: email,
          phone: phone,
        ),
        summary: summary,
        skills: skills,
        education: education,
        experience: experience,
        createdAt: createdAt,
      );

      await _repository.saveCV(cv);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }
}