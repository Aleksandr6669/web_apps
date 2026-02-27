# My Flutter App

A modern and feature-rich Flutter application designed to showcase a variety of native capabilities and provide a smooth user experience.

## ✨ Features

This application integrates several powerful packages to deliver a robust feature set:

-   **🌐 In-App Web Browser:** Utilizes `webview_flutter` to seamlessly display web content within the app.
-   **🔒 Runtime Permissions:** Employs `permission_handler` to gracefully request and handle necessary device permissions (e.g., camera, location, storage).
-   **📶 Connectivity Monitoring:** Uses `connectivity_plus` to monitor the device's network state and adapt the app's behavior accordingly.
-   **💾 Local Data Persistence:** Leverages `shared_preferences` to store simple key-value data locally, such as user settings or session information.
-   **📁 File Selection:** Integrates `file_picker` to allow users to easily select files from their device storage.

## 🚀 Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing.

### Prerequisites

You need to have the Flutter SDK installed on your machine. For instructions on how to install Flutter, please see the [official Flutter documentation](https://docs.flutter.dev/get-started/install).

### Installation & Setup

1.  **Clone the repository** or download the source code.
2.  **Navigate to the project directory** in your terminal.
3.  **Install dependencies** by running the following command:
    ```bash
    flutter pub get
    ```

### Running the Application

To run the application, use the following command with a connected device or an open emulator:

```bash
flutter run
```

## ⚙️ Automated Workflows (CI/CD) with GitHub Actions

This project leverages **GitHub Actions** for robust Continuous Integration (CI) and Continuous Delivery (CD) to ensure code quality and automate the build process. The workflow configurations are located in the `.github/workflows/` directory.

### `ci.yaml`

This workflow file defines the core CI pipeline for the project. It is triggered automatically on every `push` and `pull_request` to the `main` and `develop` branches.

The primary job of this pipeline is to validate the integrity of the codebase by performing the following steps in a clean Ubuntu environment:

1.  **Checkout Code:** Clones the repository to the runner machine.
2.  **Set up Environment:** Configures the necessary Java and Flutter SDKs.
3.  **Install Dependencies:** Runs `flutter pub get` to download all the required packages.
4.  **Analyze Code:** Executes `flutter analyze` to check for static analysis errors, potential bugs, and style violations.
5.  **Run Tests:** Runs the project's unit tests with `flutter test` to ensure that all existing functionality works as expected.

This automated process helps catch issues early, maintain a high standard of code, and ensure that the main branches are always in a deployable state.

### `android_build.yml` (Manual Build)

This workflow is designed to build the Android application and generate a release-ready App Bundle (`.aab`).

-   **Trigger:** This workflow is triggered manually via the `workflow_dispatch` event from the GitHub Actions UI.
-   **Process:**
    1.  Sets up the build environment on an `ubuntu-latest` runner.
    2.  Builds the Android App Bundle using the `flutter build appbundle` command.
    3.  Uploads the generated `.aab` file as a build artifact, making it available for download and for publishing to the Google Play Store.

### `ios_build.yml` (Manual Build)

This workflow is responsible for building the iOS application.

-   **Trigger:** This workflow is also triggered manually using `workflow_dispatch`.
-   **Process:**
    1.  Sets up the build environment on a `macos-latest` runner, which is required for iOS builds.
    2.  Builds the iOS application using the `flutter build ios --release --no-codesign` command. The `--no-codesign` flag is used as code signing will typically be handled later in the distribution process (e.g., via Xcode or a dedicated CD service).
    3.  Uploads the resulting `Runner.app` directory as a build artifact.

## 📦 Core Packages

-   `flutter`
-   `webview_flutter`
-   `permission_handler`
-   `connectivity_plus`
-   `shared_preferences`
-   `file_picker`
-   `flutter_lints`
