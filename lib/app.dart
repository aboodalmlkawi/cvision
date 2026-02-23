import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:cvision/core/theme/app_theme.dart';
import 'package:cvision/core/localization/app_localizations.dart';
import 'package:cvision/core/providers/locale_provider.dart';
import 'package:cvision/auth/ui/fancy_splash_screen.dart';

class CVisionApp extends ConsumerWidget {
  const CVisionApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    return MaterialApp(
      title: 'CVision',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      locale: currentLocale,
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const FancySplashScreen(),
    );
  }
}