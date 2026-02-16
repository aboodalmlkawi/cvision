# 1. إنشاء المجلدات
$dirs = @(
    "assets/icons", "assets/images", "assets/fonts",
    "lib/core/constants", "lib/core/theme", "lib/core/localization", "lib/core/animations", "lib/core/utils", "lib/core/widgets",
    "lib/auth/data", "lib/auth/logic", "lib/auth/ui",
    "lib/home/logic", "lib/home/ui",
    "lib/cv/data/models", "lib/cv/data/repositories", "lib/cv/data/services", "lib/cv/logic", "lib/cv/ui/create_cv", "lib/cv/ui/preview", "lib/cv/ui/manage", "lib/cv/templates",
    "lib/evaluation/data", "lib/evaluation/logic", "lib/evaluation/ui",
    "lib/settings/logic", "lib/settings/ui",
    "lib/export/pdf", "lib/export/share", "lib/export/ui",
    "test"
)
foreach ($dir in $dirs) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }

# 2. إنشاء الملفات
$files = @(
    "lib/main.dart", "lib/app.dart", "lib/firebase_options.dart",
    "lib/core/constants/colors.dart", "lib/core/constants/text_styles.dart", "lib/core/constants/app_strings.dart", "lib/core/constants/routes.dart",
    "lib/core/theme/app_theme.dart",
    "lib/core/localization/app_localizations.dart", "lib/core/localization/ar.json", "lib/core/localization/en.json",
    "lib/core/animations/pulse_animation.dart",
    "lib/core/utils/validators.dart", "lib/core/utils/helpers.dart", "lib/core/utils/pdf_helper.dart",
    "lib/core/widgets/custom_button.dart", "lib/core/widgets/custom_textfield.dart", "lib/core/widgets/loading_indicator.dart", "lib/core/widgets/app_dialog.dart",
    "lib/auth/data/auth_repository.dart", "lib/auth/data/auth_service.dart",
    "lib/auth/logic/auth_controller.dart",
    "lib/auth/ui/login_screen.dart", "lib/auth/ui/register_screen.dart", "lib/auth/ui/forgot_password_screen.dart",
    "lib/home/logic/home_controller.dart",
    "lib/home/ui/home_screen.dart", "lib/home/ui/cv_card_widget.dart", "lib/home/ui/empty_state.dart",
    "lib/cv/data/models/cv_model.dart", "lib/cv/data/models/education_model.dart", "lib/cv/data/models/experience_model.dart", "lib/cv/data/models/skill_model.dart",
    "lib/cv/data/repositories/cv_repository.dart",
    "lib/cv/data/services/cv_firestore_service.dart", "lib/cv/data/services/cv_storage_service.dart", "lib/cv/data/services/qr_service.dart",
    "lib/cv/logic/cv_controller.dart", "lib/cv/logic/cv_form_controller.dart", "lib/cv/logic/cv_preview_controller.dart",
    "lib/cv/ui/create_cv/create_cv_screen.dart", "lib/cv/ui/create_cv/personal_info_section.dart", "lib/cv/ui/create_cv/education_section.dart", "lib/cv/ui/create_cv/experience_section.dart", "lib/cv/ui/create_cv/skills_section.dart",
    "lib/cv/ui/preview/cv_preview_screen.dart",
    "lib/cv/ui/manage/edit_cv_screen.dart", "lib/cv/ui/manage/cv_settings_screen.dart",
    "lib/cv/templates/classic_cv.dart", "lib/cv/templates/modern_cv.dart", "lib/cv/templates/creative_cv.dart", "lib/cv/templates/minimal_cv.dart",
    "lib/evaluation/data/ats_rules.dart",
    "lib/evaluation/logic/cv_evaluator.dart", "lib/evaluation/logic/skill_gap_analyzer.dart",
    "lib/evaluation/ui/cv_score_widget.dart",
    "lib/settings/logic/settings_controller.dart",
    "lib/settings/ui/settings_screen.dart",
    "lib/export/pdf/cv_pdf_generator.dart",
    "lib/export/share/share_service.dart",
    "lib/export/ui/export_screen.dart",
    "test/auth_test.dart", "test/cv_test.dart", "test/evaluation_test.dart"
)
foreach ($file in $files) { New-Item -ItemType File -Force -Path $file | Out-Null }

Write-Host "✅ تم إنشاء هيكل المشروع بنجاح!" -ForegroundColor Green