import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/widgets/recording_flashmode_button.dart';

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen>
    with TickerProviderStateMixin {
  bool _hasPermission = false;
  bool _isSelfieMode = false;
  late FlashMode _flashMode;

  late CameraController _cameraController;

  //録画ボタンのアニメーション
  late final AnimationController _buttonAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  //録画時の録画ボタン周辺にあるプログレスアイコンのアニメーション
  late final AnimationController _progressAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10), //録画は最大10秒まで

    lowerBound: 0.0,
    upperBound: 1.0,
  );

  late final Animation<double> _buttonAnimation = Tween(
    begin: 1.0,
    end: 1.3,
  ).animate(_buttonAnimationController);

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

    await _cameraController.prepareForVideoRecording();

    //フラッシュモードを初期化
    _flashMode = _cameraController.value.flashMode;
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

  Future<void> _setFlashMode(FlashMode newFlashMode) async {
    await _cameraController.setFlashMode(newFlashMode);
    _flashMode = newFlashMode;
    setState(() {});
  }

  Future<void> _startRecording(TapDownDetails _) async {
    if (_cameraController.value.isRecordingVideo) return;

    await _cameraController.startVideoRecording();

    _buttonAnimationController.forward();
    _progressAnimationController.forward();
  }

  Future<void> _stopRecording() async {
    if (!_cameraController.value.isRecordingVideo) return;

    _buttonAnimationController.reverse();
    _progressAnimationController.reset();

    final file = await _cameraController.stopVideoRecording();

    print(file.name);
    print(file.path);
  }

  @override
  void initState() {
    super.initState();
    initPermission();
    _progressAnimationController.addListener(() {
      setState(() {});
    });
    _progressAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _stopRecording();
      }
    });
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    _progressAnimationController.dispose();
    _cameraController.dispose();
    super.dispose();
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
                      child: Column(
                        children: [
                          IconButton(
                            color: Colors.white,
                            onPressed: _toggleSelfieMode,
                            icon: const Icon(
                              Icons.cameraswitch,
                            ),
                          ),
                          Gaps.v10,
                          FlashModeButton(
                            onPressed: _setFlashMode,
                            flashMode: FlashMode.off,
                            selectedFlashMode: _flashMode,
                            icon: Icons.flash_off_rounded,
                          ),
                          FlashModeButton(
                            onPressed: _setFlashMode,
                            flashMode: FlashMode.always,
                            selectedFlashMode: _flashMode,
                            icon: Icons.flash_on_rounded,
                          ),
                          FlashModeButton(
                            onPressed: _setFlashMode,
                            flashMode: FlashMode.auto,
                            selectedFlashMode: _flashMode,
                            icon: Icons.flash_auto_rounded,
                          ),
                          FlashModeButton(
                            onPressed: _setFlashMode,
                            flashMode: FlashMode.torch,
                            selectedFlashMode: _flashMode,
                            icon: Icons.flashlight_on_rounded,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: Sizes.size40,
                      child: GestureDetector(
                        onTapDown: _startRecording,
                        onTapUp: (details) => _stopRecording(),
                        child: ScaleTransition(
                          scale: _buttonAnimation,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: Sizes.size80 + Sizes.size14,
                                height: Sizes.size80 + Sizes.size14,
                                child: CircularProgressIndicator(
                                  color: Colors.red.shade400,
                                  strokeWidth: Sizes.size6,
                                  value: _progressAnimationController.value,
                                ),
                              ),
                              Container(
                                width: Sizes.size80,
                                height: Sizes.size80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red.shade400,
                                ),
                              ),
                            ],
                          ),
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
