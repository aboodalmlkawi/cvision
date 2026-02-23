import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/cv_model.dart';
import '../data/repositories/cv_repository.dart';
import '../../evaluation/logic/cv_evaluator.dart';

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
    required String userId,
    String? title,
    String? templateId,
    List<String>? languages,
    DateTime? createdAt,
  }) async {
    state = const AsyncValue.loading();
    try {
      var cv = CVModel(
        id: id ?? '',
        userId: userId,
        title: title ?? 'Untitled CV',
        templateId: templateId ?? 'modern',
        personalInfo: PersonalInfo(
          fullName: fullName,
          email: email,
          phone: phone,
          summary: summary,
          jobTitle: '',
        ),
        skills: skills,
        education: education,
        experience: experience,
        languages: languages ?? [],
        createdAt: createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        score: 0,
      );

      final analysis = CVEvaluator.analyze(cv);
      final int newScore = analysis['score'];

      cv = cv.copyWith(score: newScore);

      await _repository.saveCV(cv);

      state = const AsyncValue.data(null);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }
}