# 📄 CVision 

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0-0175C2?style=for-the-badge&logo=dart)
![Firebase](https://img.shields.io/badge/Firebase-Backend-FFCA28?style=for-the-badge&logo=firebase)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**CVision** is a state-of-the-art mobile application designed to empower job seekers by combining intuitive UI/UX with powerful ATS (Applicant Tracking System) analysis. Built with Flutter, it offers real-time resume creation, AI-driven evaluation, and high-fidelity PDF export across multiple professional templates.

---

## 📸 Screenshots & Demo

| Home Dashboard | Editor & Glass UI | Template Selection | ATS & PDF Preview |
|:---:|:---:|:---:|:---:|
| *(Place Screenshot Here)* | *(Place Screenshot Here)* | *(Place Screenshot Here)* | *(Place Screenshot Here)* |

---

## 🚀 Key Features

### 🎨 **Creative & Dynamic UI**
* **Glassmorphism Design:** Custom `glass_widgets` for a modern, premium feel.
* **Animations:** Smooth transitions and pulse animations (`pulse_animation.dart`) for engaging UX.
* **Theming:** Dark/Light mode support via `app_theme.dart`.

### 📝 **Advanced CV Management**
* **Template Engine:** Support for multiple layouts including:
    * *Modern*
    * *Classic*
    * *Creative*
    * *Minimal*
* **Real-time Editing:** State-managed forms (`cv_form_controller.dart`) for instant updates.
* **CRUD Operations:** Seamless saving and retrieving via **Cloud Firestore**.

### 🤖 **Smart ATS Evaluation**
* **AI Logic:** Built-in `cv_evaluator.dart` that analyzes resume content against industry standards (`ats_rules.dart`).
* **Skill Gap Analysis:** Identifies missing keywords and suggestions (`skill_gap_analyzer.dart`).
* **Scoring System:** Visual representation of CV strength (`cv_score_widget.dart`).

### 📤 **Export & Sharing**
* **Native PDF Generation:** High-resolution PDF creation using the `pdf` package (`pdf_generator.dart`), supporting Arabic & English.
* **Link Sharing:** Deep linking capabilities for sharing profiles.
* **QR Code Integration:** Generate QR codes for instant profile access (`qr_service.dart`).

---

## 🛠 Tech Stack & Architecture

This project follows a **Feature-First (Layered) Architecture**, ensuring scalability, testability, and separation of concerns.

* **Framework:** Flutter & Dart
* **State Management:** Flutter Riverpod (implied by `ConsumerWidget` usage).
* **Backend:** Firebase Auth & Cloud Firestore.
* **PDF Engine:** `pdf` & `printing` packages.
* **Localization:** `flutter_localizations` (Ar/En support).

### 📂 Folder Structure Breakdown

The codebase is organized by **Feature**, where each folder contains its own Data, Logic, and UI layers.

```text
lib/
├── auth/                  # Authentication Feature
│   ├── data/              # Repositories & Services (Firebase Auth)
│   ├── logic/             # State Management (Auth Controllers)
│   └── ui/                # Screens (Login, Register, Splash)
│
├── core/                  # Shared Resources
│   ├── animations/        # Reusable Animations
│   ├── constants/         # Strings, Colors, Routes
│   ├── localization/      # JSON Translation files
│   ├── theme/             # App Theme Logic
│   └── ui/                # Shared Widgets (GlassWidgets, Buttons)
│
├── cv/                    # Core Feature: CV Management
│   ├── create_cv/         # UI flows for creation
│   ├── data/              # Firestore Services & CV Models
│   ├── logic/             # Form & Preview Controllers
│   ├── templates/         # PDF Layout Definitions (Classic, Modern...)
│   ├── ui/                # Editor & Management Screens
│   └── utils/             # Specific PDF Helpers
│
├── evaluation/            # ATS Analysis Feature
│   ├── data/              # Rules & Keywords
│   ├── logic/             # Scoring Algorithms
│   └── ui/                # Score Display Widgets
│
├── export/                # Exporting Feature
│   ├── logic/             # Sharing Logic
│   └── pdf/               # Final PDF Generation Assembly
│
├── home/                  # Dashboard Feature
│   ├── logic/             # Home State Controllers
│   └── ui/                # Cards, Bottom Bar, Profile
│
└── settings/              # App Configuration