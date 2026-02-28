import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Permission.notification.request();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WebViewScreen(),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final String _initialUrl = "https://permission.site/";
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    final WebViewController controller = WebViewController();

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..addJavaScriptChannel('Console', onMessageReceived: (JavaScriptMessage message) {
        if (kDebugMode) {
          print('JS Console: ${message.message}');
        }
      })
      ..loadRequest(Uri.parse(_initialUrl));

    _configureAndroid(controller);

    _controller = controller;
    _clearCacheIfOnline();
  }

  Future<void> _configureAndroid(WebViewController controller) async {
    if (WebViewPlatform.instance is! AndroidWebViewPlatform) {
      return;
    }

    // ВКЛЮЧАЕМ ОТЛАДКУ WEBVIEW (ИСПРАВЛЕНО)
    await AndroidWebViewController.enableDebugging(true);

    final androidController = controller.platform as AndroidWebViewController;

    androidController.setOnPlatformPermissionRequest(
      (PlatformWebViewPermissionRequest request) async {
        if (kDebugMode) {
          print('[WebView] Permission requested for: ${request.types.map((e) => e.name).join(', ')}');
        }

        bool allPermissionsGranted = true;

        for (final type in request.types) {
          final status = await _getPermissionStatus(type.name);
          if (kDebugMode) {
            print('[WebView] Permission status for ${type.name}: $status');
          }
          
          if (!status.isGranted) {
            allPermissionsGranted = false;
            break;
          }
        }

        if (kDebugMode) {
          print('[WebView] Final decision: ${allPermissionsGranted ? "GRANT" : "DENY"}');
        }

        if (allPermissionsGranted) {
          await request.grant();
        } else {
          await request.deny();
        }
      },
    );

    await androidController.setOnShowFileSelector((FileSelectorParams params) async {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: params.mode == FileSelectorMode.openMultiple,
      );
      if (result != null) {
        return result.paths.where((path) => path != null).map((path) => Uri.file(path!).toString()).toList();
      }
      return [];
    });
  }

  Future<PermissionStatus> _getPermissionStatus(String permissionName) async {
    switch (permissionName) {
      case 'geolocation':
        return await Permission.location.request();
      case 'camera':
        return await Permission.camera.request();
      case 'microphone':
        return await Permission.microphone.request();
      default:
        return PermissionStatus.denied;
    }
  }

  Future<void> _clearCacheIfOnline() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    final hasInternet = connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi);

    if (hasInternet) {
      await _controller.clearCache();
      await _controller.clearLocalStorage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
