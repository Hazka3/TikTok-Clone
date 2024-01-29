import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/views/video_preview_screen.dart';
import 'package:tiktok_clone/features/videos/views/widgets/recording_flashmode_button.dart';

class VideoRecordingScreen extends StatefulWidget {
  static const String routeName = "postVideo";
  static const String routeURL = "/upload";
  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool _hasPermission = false;
  bool _isSelfieMode = false;
  bool _isAppInactive = true;

  //iOSシミュレーターではカメラが起動しないため、iOSシミュレーターではcamerantrollerを初期化させないためのboolean
  late final bool _noCamera = kDebugMode && Platform.isIOS;

  late final double _minZoomLevel;
  late final double _maxZoomLevel;
  late double _currentZoomLevel;

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
    final cameras = await availableCameras();

    if (cameras.isEmpty) {
      return;
    }
    _cameraController = CameraController(
      cameras[_isSelfieMode ? 1 : 0],
      ResolutionPreset.ultraHigh,
    );

    await _cameraController.initialize();

    //iOSでのみ実行される。動画のシンクが合わないことがある問題を防止するための機能
    await _cameraController.prepareForVideoRecording();

    _flashMode = _cameraController.value.flashMode;

    _minZoomLevel = await _cameraController.getMinZoomLevel();
    _maxZoomLevel = await _cameraController.getMaxZoomLevel();

    setState(() {});
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

  Future<void> _changeZoomLevel(LongPressMoveUpdateDetails details) async {
    if (_noCamera) return;

    //端末の最大ズーム倍率に対応して計数を変化するための処理
    double zoomFactor = _maxZoomLevel > 100 ? 0.05 : 0.05;

    //垂直方向に動いた距離を計算
    double deltaY = -details.localOffsetFromOrigin.dy * zoomFactor;

    setState(() {
      // camera packageの setZoomLevel で1倍以下にズームアウトはできないため、最小値は1.0で固定
      _currentZoomLevel = deltaY.clamp(_minZoomLevel, _maxZoomLevel);
    });

    await _cameraController.setZoomLevel(_currentZoomLevel);
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
    if (_noCamera) return;
    if (_cameraController.value.isRecordingVideo) return;

    await _cameraController.startVideoRecording();

    _buttonAnimationController.forward();
    _progressAnimationController.forward();
  }

  Future<void> _stopRecording() async {
    if (_noCamera) return;
    if (!_cameraController.value.isRecordingVideo) return;

    _buttonAnimationController.reverse();
    _progressAnimationController.reset();

    final video = await _cameraController.stopVideoRecording();

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(
          video: video,
          isPicked: false,
        ),
      ),
    );
  }

  Future<void> _onPickVideoPressed() async {
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);

    //ユーザーがビデオをpickしなかった時は何もしない
    if (video == null) return;

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(
          video: video,
          isPicked: true,
        ),
      ),
    );
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    //disposeはcontrollerが初期化されていることが前提であるため、初期化されていないときは何もしない
    if (_noCamera ||
        !_hasPermission ||
        !_cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.paused) {
      _isAppInactive = false;
      await _cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _isAppInactive = true;
      await initCamera();
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (!_noCamera) {
      initPermission();
    } else {
      setState(() {
        _hasPermission = true;
      });
    }
    WidgetsBinding.instance.addObserver(this);
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
    if (!_noCamera) {
      _cameraController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: !_hasPermission
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
                    _isAppInactive && !_noCamera
                        ? CameraPreview(
                            _cameraController,
                          )
                        : Container(),
                    const Positioned(
                        top: 0,
                        left: Sizes.size10,
                        child: CloseButton(
                          color: Colors.white,
                        )),
                    if (!_noCamera)
                      Positioned(
                        top: Sizes.size20,
                        left: Sizes.size20,
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
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          const Spacer(),
                          GestureDetector(
                            onTapDown: _startRecording,
                            onTapUp: (details) => _stopRecording(),
                            onLongPressMoveUpdate: _changeZoomLevel,
                            onPanEnd: (details) => _stopRecording(),
                            onLongPressEnd: (details) => _stopRecording(),
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
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: IconButton(
                                onPressed: _onPickVideoPressed,
                                icon: const FaIcon(
                                  FontAwesomeIcons.image,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
