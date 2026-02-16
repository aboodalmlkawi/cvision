import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final localeProvider = StateProvider<Locale>((ref) {
  return const Locale('ar');
});

final notificationsProvider = StateProvider<bool>((ref) => true);

class SettingsController {
  final Ref ref;

  SettingsController(this.ref);

  void toggleLanguage() {
    final current = ref.read(localeProvider);
    if (current.languageCode == 'ar') {
      ref.read(localeProvider.notifier).state = const Locale('en');
    } else {
      ref.read(localeProvider.notifier).state = const Locale('ar');
    }
  }

  void toggleNotifications(bool value) {
    ref.read(notificationsProvider.notifier).state = value;
  }
}

final settingsControllerProvider = Provider<SettingsController>((ref) {
  return SettingsController(ref);
});