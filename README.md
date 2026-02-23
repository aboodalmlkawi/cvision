# 📄 CVision: AI-Powered ATS Resume Architect

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0-0175C2?style=for-the-badge&logo=dart)
![Firebase](https://img.shields.io/badge/Firebase-Backend-FFCA28?style=for-the-badge&logo=firebase)
![Riverpod](https://img.shields.io/badge/State_Management-Riverpod-blue?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**CVision** isn't just a resume builder; it's a strategic career tool. Engineered with Flutter and Firebase, it seamlessly blends a premium Glassmorphism UI with a robust, AI-driven Applicant Tracking System (ATS) evaluator. It empowers job seekers to not only design high-fidelity resumes but to mathematically optimize them for modern recruitment algorithms.

---

## 📸 Application Showcase

| Dashboard & Analytics | Glassmorphism Editor | Smart Template Engine | ATS Scoring & Export |
|:---:|:---:|:---:|:---:|
| *![WhatsApp Image 2026-02-24 at 2 31 38 AM (2)](https://github.com/user-attachments/assets/6fb2a6d2-f24b-4680-adba-4e3696e93a1f)
* | *![WhatsApp Image 2026-02-24 at 2 31 38 AM](https://github.com/user-attachments/assets/55cfcd88-b005-4b6b-b42e-f7ac4dd888c5) *
 | *![WhatsApp Image 2026-02-24 at 2 31 38 AM (1)](https://github.com/user-attachments/assets/ffa546d0-4921-4e16-8fd8-ca23dabee38a)
* | *![Uploading WhatsApp Image 2026-02-24 at 2.32.57 AM.jpeg…]()
* |

---

## 🚀 Core Capabilities

### 🧠 **Intelligent ATS Evaluation Engine**
* **Algorithmic Scoring:** Built-in `cv_evaluator.dart` algorithm that parses resume data against strict ATS logic.
* **Actionable Skill-Gap Analysis:** Dynamically identifies missing keywords and recommends strategic improvements to beat recruiter filters.
* **Visual Metrics:** Real-time scoring rings and progress indicators via `cv_score_widget.dart`.

### 🎨 **Premium UI/UX & Glassmorphism**
* **Immersive Interface:** Custom frosted-glass components (`glass_widgets.dart`) for a sleek, modern aesthetic.
* **Fluid Micro-interactions:** Engaging pulse animations and transitions that elevate the user journey.
* **Adaptive Theming:** Deep integration of Dark/Light modes for optimal accessibility.

### 📄 **Dynamic Document Generation**
* **High-Fidelity PDF Engine:** Native pixel-perfect document rendering using `pdf_generator.dart`.
* **Multi-Format Templates:** Instantly toggle between *Modern*, *Classic*, *Creative*, and *Minimal* architectures without losing data.
* **Bilingual Support:** Full RTL/LTR localization for Arabic and English outputs.

### ☁️ **Cloud-Native Architecture**
* **Zero-Latency State:** Powered by Riverpod for highly responsive, state-managed form editing.
* **Secure Cloud Storage:** Real-time CRUD operations backed by Google Cloud Firestore and Firebase Auth.
* **Instant Sharing:** Generate deep links or vCard QR codes on the fly.

---

## 🏗️ Technical Architecture 

[Image of layered software architecture diagram]


CVision is built on a highly scalable **Feature-First (Layered) Architecture**, ensuring strict separation of concerns, testability, and modularity.

### 📂 Directory Map
```text
lib/
├── auth/                  # Authentication & Session Management
├── core/                  # Core Utilities, Theming, and Localization
├── cv/                    # CV Generation, Data Models, and PDF Templates
├── evaluation/            # ATS Logic, Scoring Algorithms, and Skill Mapping
├── export/                # PDF Assembly and QR/Link Sharing Services
├── home/                  # Dashboard, Navigation, and Profile State
└── settings/              # Application Preferences

