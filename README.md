# RDSO Documents — Flutter Frontend

A cross-platform Flutter application for browsing, viewing, and managing **RDSO (Research Designs & Standards Organisation)** railway documents. The app provides HRMS-based authentication, categorised document navigation, PDF viewing, and a notifications feed — all built on the **UX4G** design system for a consistent government-standard UI.

---

## Table of Contents

1. [Features](#features)
2. [Screenshots & Screens](#screenshots--screens)
3. [Architecture](#architecture)
4. [Project Structure](#project-structure)
5. [Tech Stack](#tech-stack)
6. [Prerequisites](#prerequisites)
7. [Installation](#installation)
8. [Running the App](#running-the-app)
9. [Building for Production](#building-for-production)
10. [Configuration](#configuration)
11. [Contributing](#contributing)
12. [License](#license)

---

## Features

- **HRMS Login** — Secure login screen with HRMS ID and password fields.
- **Home Dashboard** — Search bar, recently-viewed documents with version badges (Current / Archive).
- **Category Navigation** — Sidebar drawer with expandable categories (Bridges & Structures, Track Design, etc.) splitting into *Current* and *Archive* sub-sections.
- **Category Results** — Scrollable list of documents with view and download actions.
- **PDF Viewer** — Full-screen document viewer with feedback and download buttons.
- **Notifications** — Feed of new-file and document-revision notifications.
- **Cross-platform** — Runs on Android, iOS, Web, macOS, Linux, and Windows.

---

## Screenshots & Screens

| Route | Screen | Description |
|---|---|---|
| `/login` | `LoginScreen` | HRMS ID / password login form with a confidential-system badge |
| `/home` | `HomeDashboard` | Search bar + recently-viewed document cards + sidebar drawer |
| `/results` | `CategoryResultsScreen` | Filtered document list with view / download actions |
| `/pdf` | `PdfViewScreen` | Document viewer placeholder with feedback & download toolbar |
| `/notifications` | `NotificationsScreen` | Chronological notification feed |

---

## Architecture

The app follows a **simple screen-based architecture** suited for a document-browsing application:

```
┌─────────────────────────────────────────────────┐
│                  main.dart                      │
│   (MaterialApp, route table, theme config)      │
└──────────────────┬──────────────────────────────┘
                   │
       ┌───────────┼───────────────┐
       ▼           ▼               ▼
   Screens      Widgets        UX4G (pkg)
  ┌────────┐  ┌───────────┐  ┌──────────────┐
  │ Login  │  │ AppDrawer │  │ Ux4gScaffold │
  │ Home   │  │ (Sidebar) │  │ Ux4gAppBar   │
  │ Results│  └───────────┘  │ Ux4gCard     │
  │ PDF    │                 │ Ux4gButton   │
  │ Notifs │                 │ Ux4gBadge    │
  └────────┘                 │ Ux4gTextField│
                             │ Ux4gSidebar  │
                             └──────────────┘
```

### Key design decisions

| Concern | Approach |
|---|---|
| **Routing** | Named routes defined in `MaterialApp.routes` (`/login`, `/home`, `/results`, `/pdf`, `/notifications`) |
| **Design System** | All UI components come from the [`ux4g`](https://pub.dev/packages/ux4g) package — India's Government UX design system for Flutter |
| **State Management** | Currently uses basic `StatefulWidget` + `setState` (login form). Screens are mostly stateless, receiving data via route arguments |
| **Navigation Arguments** | Route arguments are passed as `String` (category name) or `Map<String, String>` (document name + version) |
| **Theme** | Material 3 with a `ColorScheme` seeded from `Ux4gColors.primary` |

---

## Project Structure

```
rdso_documents/
├── lib/
│   ├── main.dart                          # App entry point, routes & theme
│   ├── screens/
│   │   ├── login_screen.dart              # HRMS login form
│   │   ├── home_dashboard.dart            # Dashboard with search & recent docs
│   │   ├── category_results_screen.dart   # Filtered document listing
│   │   ├── pdf_view_screen.dart           # PDF viewer (placeholder)
│   │   └── notifications_screen.dart      # Notification feed
│   └── widgets/
│       └── app_drawer.dart                # Sidebar / navigation drawer builder
├── test/
│   └── widget_test.dart                   # Widget tests
├── android/                               # Android platform shell
├── ios/                                   # iOS platform shell
├── web/                                   # Web platform shell
├── macos/                                 # macOS platform shell
├── linux/                                 # Linux platform shell
├── windows/                               # Windows platform shell
├── pubspec.yaml                           # Dependencies & project metadata
└── analysis_options.yaml                  # Dart linter configuration
```

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart SDK `^3.10.8`) |
| Design System | [UX4G](https://pub.dev/packages/ux4g) `^0.1.1` — Government of India UX components |
| Icons | Cupertino Icons `^1.0.8` + Material Icons |
| Lint Rules | `flutter_lints ^6.0.0` |
| Build | Flutter CLI (`flutter build`) |

---

## Prerequisites

| Requirement | Minimum Version |
|---|---|
| Flutter SDK | 3.10.8+ |
| Dart SDK | 3.10.8+ (bundled with Flutter) |
| Android Studio / Xcode | Latest stable (for mobile targets) |
| Chrome | Any modern version (for web target) |

Verify your environment:

```bash
flutter doctor -v
```

---

## Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd railway/rdso_documents
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Verify setup**

   ```bash
   flutter analyze
   ```

   This runs the Dart analyzer with the lint rules defined in `analysis_options.yaml`.

---

## Running the App

### Android (emulator or device)

```bash
flutter run                    # defaults to connected Android device
```

### iOS (simulator or device — macOS only)

```bash
flutter run -d ios
```

### Web (Chrome)

```bash
flutter run -d chrome
```

### macOS

```bash
flutter run -d macos
```

### Linux

```bash
flutter run -d linux
```

### Windows

```bash
flutter run -d windows
```

> **Tip:** Use `flutter devices` to list all available targets.

---

## Building for Production

### Android APK

```bash
flutter build apk --release
```

### Android App Bundle (for Play Store)

```bash
flutter build appbundle --release
```

### iOS (macOS only)

```bash
flutter build ios --release
```

### Web

```bash
flutter build web --release
# Output → build/web/
```

### macOS / Linux / Windows

```bash
flutter build macos --release
flutter build linux --release
flutter build windows --release
```

---

## Configuration

| Item | Location | Notes |
|---|---|---|
| App name & version | `pubspec.yaml` → `name`, `version` | Currently `1.0.0+1` |
| Theme seed colour | `lib/main.dart` → `ColorScheme.fromSeed` | Uses `Ux4gColors.primary` |
| Initial route | `lib/main.dart` → `initialRoute` | Set to `/login` |
| Android config | `android/app/build.gradle.kts` | Min SDK, signing, etc. |
| iOS config | `ios/Runner/Info.plist` | Bundle ID, permissions |
| Web manifest | `web/manifest.json` | PWA metadata & icons |

---

## Contributing

1. Fork the repository.
2. Create a feature branch: `git checkout -b feature/my-feature`.
3. Commit changes: `git commit -m "feat: add my feature"`.
4. Push: `git push origin feature/my-feature`.
5. Open a Pull Request.

Please run `flutter analyze` and `flutter test` before submitting.

---

## License

This project is proprietary software of RDSO, Indian Railways. Unauthorised distribution is prohibited.
