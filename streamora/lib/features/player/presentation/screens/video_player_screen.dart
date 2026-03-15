import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../continue_watching/presentation/providers/continue_watching_provider.dart';

class VideoPlayerScreen extends ConsumerStatefulWidget {
  final String streamUrl;
  final String title;
  final String type;
  final int? streamId;
  final String? coverUrl;
  final double? position;

  const VideoPlayerScreen({
    super.key,
    required this.streamUrl,
    required this.title,
    required this.type,
    this.streamId,
    this.coverUrl,
    this.position,
  });

  @override
  ConsumerState<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  String? _errorMessage;
  Duration? _lastPosition;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.streamUrl));
      await _videoPlayerController!.initialize();

      // Seek to last position if available
      if (widget.position != null && widget.position! > 0) {
        final position = Duration(seconds: (widget.position! * _videoPlayerController!.value.duration.inSeconds).toInt());
        await _videoPlayerController!.seekTo(position);
      }

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        allowFullScreen: false,
        allowMuting: true,
        showControls: true,
        customControls: const MaterialControls(),
        materialProgressColors: ChewieProgressColors(
          playedColor: AppColors.primary,
          handleColor: AppColors.primary,
          bufferedColor: AppColors.gray600,
          backgroundColor: AppColors.gray800,
        ),
        errorBuilder: (context, errorMessage) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.white, size: 48),
              const SizedBox(height: 16),
              Text(errorMessage, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      );

      // Track position for continue watching
      _videoPlayerController!.addListener(_onPositionChanged);

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load video: $e';
      });
    }
  }

  void _onPositionChanged() {
    final position = _videoPlayerController?.value.position;
    if (position != null && position != _lastPosition) {
      _lastPosition = position;
      final duration = _videoPlayerController?.value.duration;
      if (duration != null && duration.inSeconds > 0) {
        final progress = position.inSeconds / duration.inSeconds;
        if (widget.streamId != null) {
          ref.read(continueWatchingNotifierProvider.notifier).updateProgress(
            contentId: widget.streamId!,
            contentType: widget.type,
            title: widget.title,
            streamUrl: widget.streamUrl,
            coverUrl: widget.coverUrl,
            position: position.inSeconds,
            duration: duration.inSeconds,
            progress: progress,
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.removeListener(_onPositionChanged);
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    WakelockPlus.disable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(child: LoadingWidget())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64.w, color: AppColors.error),
                      SizedBox(height: 16.h),
                      Text(_errorMessage!, style: TextStyle(color: Colors.white, fontSize: 16.sp), textAlign: TextAlign.center),
                      SizedBox(height: 24.h),
                      ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Go Back')),
                    ],
                  ),
                )
              : Chewie(controller: _chewieController!),
    );
  }
}
