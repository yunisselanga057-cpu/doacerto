# DoaCerto — Donation Bridge (Mozambique)

**DoaCerto** is a Flutter-based mobile application designed to bridge the gap between donors and social institutions in Mozambique. It streamlines the donation process through real-time location tracking, urgency-based filtering, and a gamified experience for donors.

---

## 🛠 Prerequisites

Before running the application, ensure your environment meets the following requirements:

* **Flutter SDK:** `>= 3.0.0` ([Installation Guide](https://docs.flutter.dev/get-started/install))
* **IDE:** VS Code (with Flutter extension) or Android Studio.
* **Target:** Physical Android device or Emulator (API 21+).

---

## Getting Started

Follow these steps to run the project on your local machine:

1.  **Extract** the provided ZIP file.
2.  **Navigate** to the project root directory in your terminal.
3.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
4.  **Initialize Assets Folders** (Required to avoid compilation errors due to missing paths):
    ```bash
    mkdir -p assets/images assets/icons
    ```
5.  **Run the application:**
    ```bash
    flutter run
    ```

---

## Project Architecture (`lib/`)

The source code is organized by feature to ensure scalability and maintainability:

* `main.dart`: App entry point and splash/router logic.
* `pages/`: Shared UI components (Auth, Onboarding, Profile Setup).
* `donor/`: Donor-specific flow (Interactive Map, Impact Dashboard, Gamification).
* `charity/`: Institution-specific flow (Donation Management, Needs Updates).
* `utils/`: Helper functions and global error handling.

---

##  Key Features

### For Donors
* **Interactive Mapping:** Real-time Map with urgency-coded pins (Orange/Green).
* **Smart Donation Flow:** Integrated forms with delivery scheduling.
* **Impact & Gamification:** Personal dashboard featuring monthly stats, points, streaks, and unlockable badges.
* **Onboarding:** 5-screen animated walkthrough for new users.

###  For Institutions
* **Management Dashboard:** View and track scheduled donations.
* **Needs Management:** Dynamic UI to update urgent requirements (e.g., Food, Blankets).
* **Location Control:** Interactive map picker to define the institution's location and visibility.

---

##  Main Dependencies

| Package | Version | Purpose |
| :--- | :--- | :--- |
| `flutter_map` | `^6.1.0` | OpenStreetMap Integration |
| `latlong2` | `^0.9.0` | GPS Coordinates Handling |
| `shared_preferences` | `^2.2.2` | Local Data Persistence (Auth/State) |
| `image_picker` | `^1.0.7` | Profile Picture Management |

---

##  Important Notes
* **Assets:** The application is designed to use Flutter Icons as fallbacks. However, the `assets/` folders **must exist** (even if empty) to satisfy the `pubspec.yaml` declaration.
* **Compatibility:** Developed and tested using Flutter 3.x.

---
**Developed by Yúnisse Langa** *Informatics Engineering · TechHub Academy 2nd Edition (Maputo, Mozambique)*
