import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

void main() {
  // Убедимся, что все инициализировано до запуска
  WidgetsFlutterBinding.ensureInitialized();
  // Запрашиваем разрешения до запуска самого приложения
  _setupPermissions();
  
  runApp(const MyApp());
}

// Выносим эту функцию на верхний уровень, чтобы вызвать до runApp
Future<void> _setupPermissions() async {
  // Запрашиваем только необходимые разрешения
  await Permission.notification.request();
  await Permission.location.request(); 
  if (defaultTargetPlatform == TargetPlatform.android) {
    await Permission.sensors.request();
  }
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

    if (controller.platform is AndroidWebViewController) {
      final androidController = controller.platform as AndroidWebViewController;
      
      androidController.setGeolocationEnabled(true);

      androidController.setOnShowFileSelector((FileSelectorParams params) async {
        final result = await FilePicker.platform.pickFiles(
          allowMultiple: params.mode == FileSelectorMode.openMultiple,
        );
        if (result != null) {
          return result.paths.where((path) => path != null).map((path) => Uri.file(path!).toString()).toList();
        }
        return [];
      });

      androidController.setOnPlatformPermissionRequest(
        (PlatformWebViewPermissionRequest request) async {
          bool allPermissionsGranted = true;

          for (final type in request.types) {
            PermissionStatus status;
            switch (type) {
              case WebViewPermissionResourceType.camera:
                status = await Permission.camera.request();
                if (!status.isGranted) allPermissionsGranted = false;
                break;
              case WebViewPermissionResourceType.microphone:
                status = await Permission.microphone.request();
                if (!status.isGranted) allPermissionsGranted = false;
                break;
              default:
                allPermissionsGranted = false;
                break;
            }
          }

          if (allPermissionsGranted) {
            await request.grant();
          } else {
            await request.deny();
          }
        },
      );
    }
    
    _controller = controller;
    _clearCacheIfOnline();
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
