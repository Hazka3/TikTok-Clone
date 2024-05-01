import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';
import 'package:tiktok_clone/features/videos/view_models/video_post_view_models.dart';
import 'package:tiktok_clone/features/videos/view_models/playback_config_vm.dart';
import 'package:tiktok_clone/features/videos/views/widgets/video_button.dart';
import 'package:tiktok_clone/features/videos/views/widgets/video_comments.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:tiktok_clone/generated/l10n.dart';

class VideoPost extends ConsumerStatefulWidget {
  final Function onVideoFinished;
  final int index;
  final VideoModel videoData;

  const VideoPost({
    super.key,
    required this.onVideoFinished,
    required this.index,
    required this.videoData,
  });

  @override
  VideoPostState createState() => VideoPostState();
}

class VideoPostState extends ConsumerState<VideoPost>
    with SingleTickerProviderStateMixin {
  late final VideoPlayerController _videoPlayerController;
  late final AnimationController _animationController;
  final Duration _animationDuration = const Duration(milliseconds: 200);

  bool _isPause = false;
  bool _isEllipsis = false;
  bool _isLiked = false;
  late bool _isMuted;
  int _likesCount = 0;

  void _onVideoChange() {
    if (_videoPlayerController.value.isInitialized) {
      // ビデオの長さ = 再生位置　、つまり再生終了時の処理
      if (_videoPlayerController.value.duration ==
          _videoPlayerController.value.position) {
        widget.onVideoFinished();
      }
    }
  }

  Future<void> _initVideoPlayer() async {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoData.fileUrl));
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);

    if (kIsWeb || _isMuted) {
      _videoPlayerController.setVolume(0);
    } else {
      _videoPlayerController.setVolume(1);
    }
    _videoPlayerController.addListener(_onVideoChange);
    _likesCount = widget.videoData.likes;
    _isLiked = await ref
        .read(videoPostProvider(widget.videoData.id).notifier)
        .isLikedVideo();
    setState(() {});
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction == 1 &&
        !_isPause &&
        !_videoPlayerController.value.isPlaying) {
      final autoplay = ref.read(playbackConfigProvider).autoplay;
      if (autoplay) {
        _videoPlayerController.play();
      }
    }
    if (_videoPlayerController.value.isPlaying && info.visibleFraction == 0) {
      _onTogglePause();
    }
    //他の動画から再度戻ってきた時、_isMuteの値が保持されていないようにするためにもう一度グローバルのmute値をチェック
    _onPlaybackConfigChanged();
  }

  void _onTogglePause() {
    if (!mounted) return;
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
      _animationController.reverse();
    } else {
      _videoPlayerController.play();
      _animationController.forward();
    }
    setState(() {
      _isPause = !_isPause;
    });
  }

  void _toggleSeeMore() {
    setState(() {
      _isEllipsis = !_isEllipsis;
    });
  }

  void _onCommentsTap(BuildContext context) async {
    if (_videoPlayerController.value.isPlaying) {
      _onTogglePause();
    }
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const VideoComments(),
    );
    _onTogglePause();
  }

  void _onPlaybackConfigChanged() {
    if (!mounted) return;
    _isMuted = ref.read(playbackConfigProvider).muted;
    _checkVideoMute();
    setState(() {});
  }

  void _onVolumeTap() {
    _isMuted = !_isMuted;
    _checkVideoMute();
    setState(() {});
  }

  void _checkVideoMute() {
    if (_isMuted) {
      _videoPlayerController.setVolume(0);
    } else {
      _videoPlayerController.setVolume(1);
    }
  }

  void onLikeTap() async {
    await ref
        .read(videoPostProvider(widget.videoData.id).notifier)
        .toggleLikeVideo();
    _isLiked = !_isLiked;
    if (_isLiked) {
      _likesCount++;
    } else {
      _likesCount--;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
    _animationController = AnimationController(
      vsync: this,
      value: 1.5,
      lowerBound: 1.0,
      upperBound: 1.5,
      duration: _animationDuration,
    );
    _isPause = !ref.read(playbackConfigProvider).autoplay;
    _isMuted = ref.read(playbackConfigProvider).muted;
    if (_isMuted) {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _animationController.dispose();
    widget.onVideoFinished;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(playbackConfigProvider, (previous, next) {
      _onPlaybackConfigChanged();
    });
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return VisibilityDetector(
      key: Key("${widget.index}"),
      onVisibilityChanged: _onVisibilityChanged,
      child: Stack(
        children: [
          Positioned.fill(
            child: _videoPlayerController.value.isInitialized
                ? VideoPlayer(_videoPlayerController)
                : Image.network(
                    widget.videoData.thumbnailUrl,
                    fit: BoxFit.cover,
                  ),
          ),
          Positioned.fill(
            child: GestureDetector(
              onTap: _onTogglePause,
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animationController.value,
                      child: child,
                    );
                  },
                  child: AnimatedOpacity(
                    opacity: _isPause ? 1 : 0,
                    duration: _animationDuration,
                    child: const FaIcon(
                      FontAwesomeIcons.play,
                      color: Colors.white,
                      size: Sizes.size52,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '@${widget.videoData.creator}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: Sizes.size20,
                  ),
                ),
                Gaps.v10,
                Text(
                  widget.videoData.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: Sizes.size16,
                  ),
                ),
                Gaps.v5,
                Row(
                  children: [
                    SizedBox(
                      width: 250,
                      child: Text(
                        '#googleearth #googlemaps #video #flutter #makeoverflow',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: Sizes.size16,
                        ),
                        overflow: _isEllipsis
                            ? TextOverflow.fade
                            : TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: _toggleSeeMore,
                      child: _isEllipsis
                          ? Container()
                          : const Text(
                              'See more',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: Sizes.size16,
                              ),
                            ),
                    ),
                  ],
                ),
                Gaps.v5,
                _isEllipsis
                    ? GestureDetector(
                        onTap: _toggleSeeMore,
                        child: const Text(
                          ' See Less',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: Sizes.size16,
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 10,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.black,
                  foregroundImage: NetworkImage(
                    "https://firebasestorage.googleapis.com/v0/b/clone-tiktok-uryuryuc.appspot.com/o/avatars%2F${widget.videoData.creatorUid}?alt=media",
                  ),
                ),
                Gaps.v24,
                GestureDetector(
                  onTap: onLikeTap,
                  child: VideoButton(
                    icon: FontAwesomeIcons.solidHeart,
                    color: _isLiked ? Colors.red : Colors.white,
                    text: '$_likesCount',
                  ),
                ),
                Gaps.v24,
                GestureDetector(
                  onTap: () => _onCommentsTap(context),
                  child: VideoButton(
                    icon: FontAwesomeIcons.solidComment,
                    color: Colors.white,
                    text: S.of(context).commentCount(widget.videoData.comments),
                  ),
                ),
                Gaps.v24,
                const VideoButton(
                  icon: FontAwesomeIcons.share,
                  color: Colors.white,
                  text: "Share",
                ),
              ],
            ),
          ),
          Positioned(
            top: 50,
            left: 10,
            child: IconButton(
              icon: FaIcon(
                _isMuted
                    ? FontAwesomeIcons.volumeXmark
                    : FontAwesomeIcons.volumeHigh,
                color: Colors.white,
              ),
              onPressed: _onVolumeTap,
            ),
          ),
        ],
      ),
    );
  }
}
