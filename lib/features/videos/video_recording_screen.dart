import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen> {
  bool _hasPermission = false;

  bool _isSelfieMode = false;

  late CameraController _cameraController;

  Future<void> initCamera() async {
    // 使用可能なカメラ（フロントカメラ、バックカメラなど）のリストを受け取る
    final cameras = await availableCameras();

    //デバイスにカメラがない場合
    if (cameras.isEmpty) {
      return;
    }

    //デバイスにカメラがある場合、カメラを選択する
    _cameraController = CameraController(
      cameras[_isSelfieMode ? 1 : 0],
      ResolutionPreset.ultraHigh,
    );

    //cameraControllerを初期化
    await _cameraController.initialize();
  }

  Future<void> initPermission() async {
    final cameraPermission = await Permission.camera.request();
    final micPermission = await Permission.microphone.request();

    final cameraDenied =
        cameraPermission.isDenied || cameraPermission.isPermanentlyDenied;
    final micDenied =
        micPermission.isDenied || micPermission.isPermanentlyDenied;

    if (!cameraDenied && !micDenied) {
      await initCamera();
      _hasPermission = true;
      setState(() {});
    }
  }

  Future<void> _toggleSelfieMode() async {
    _isSelfieMode = !_isSelfieMode;
    await initCamera();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: !_hasPermission || !_cameraController.value.isInitialized
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Requesting permissions...",
                  ),
                  Gaps.v20,
                  CircularProgressIndicator.adaptive(),
                ],
              )
            : SafeArea(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CameraPreview(
                      _cameraController,
                    ),
                    Positioned(
                      top: Sizes.size10,
                      left: Sizes.size10,
                      child: IconButton(
                        color: Colors.white,
                        onPressed: _toggleSelfieMode,
                        icon: const Icon(
                          Icons.cameraswitch,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
