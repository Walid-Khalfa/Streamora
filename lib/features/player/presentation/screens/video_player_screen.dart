import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import '../../../../core/theme/app_colors.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String streamUrl;
  final String title;
  final String? iconUrl;
  final String contentType;
  final int? contentId;

  const VideoPlayerScreen({
    super.key,
    required this.streamUrl,
    required this.title,
    this.iconUrl,
    required this.contentType,
    this.contentId,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    _setLandscapeOrientation();
  }

  void _setLandscapeOrientation() {
    if (widget.contentType != 'live') {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
  }

  void _restorePortraitOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  Future<void> _initializePlayer() async {
    if (widget.streamUrl.isEmpty) {
      setState(() {
        _hasError = true;
        _errorMessage = 'No stream URL provided';
      });
      return;
    }

    try {
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.streamUrl),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: false,
          allowCrossProtocolRedirects: true,
        ),
      );

      await _videoPlayerController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: widget.contentType == 'live',
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: AppColors.primary,
          handleColor: AppColors.primary,
          backgroundColor: AppColors.backgroundLighter,
          bufferedColor: AppColors.primary.withOpacity(0.3),
        ),
        placeholder: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          ),
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppColors.error,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading video',
                  style: TextStyle(
                    color: AppColors.textPrimary.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  errorMessage,
                  style: TextStyle(
                    color: AppColors.textTertiary.withOpacity(0.6),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
        customControls: _buildCustomControls(),
        allowFullScreen: true,
        allowMuting: true,
        showOptions: true,
        optionsTranslation: OptionsTranslation(
          playbackSpeedButtonText: 'Vitesse',
          captionsButtonText: 'Sous-titres',
          cancelButtonText: 'Annuler',
        ),
      );

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = e.toString();
        });
      }
    }
  }

  Widget _buildCustomControls() {
    return ChewieProgressColors(
      playedColor: AppColors.primary,
      handleColor: AppColors.primary,
      backgroundColor: AppColors.backgroundLighter,
      bufferedColor: AppColors.primary.withOpacity(0.3),
    );
  }

  @override
  void dispose() {
    _restorePortraitOrientation();
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _buildPlayerBody(),
    );
  }

  Widget _buildPlayerBody() {
    if (_hasError) {
      return _buildErrorState();
    }

    if (!_isInitialized || _chewieController == null) {
      return _buildLoadingState();
    }

    return SafeArea(
      child: Column(
        children: [
          // Video player with back button
          Expanded(
            child: Stack(
              children: [
                // Chewie video player
                Center(
                  child: AspectRatio(
                    aspectRatio: _videoPlayerController!.value.aspectRatio,
                    child: Chewie(controller: _chewieController!),
                  ),
                ),
                // Back button overlay
                Positioned(
                  top: 8,
                  left: 8,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                // Title overlay
                Positioned(
                  top: 8,
                  left: 48,
                  right: 48,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            shadows: [
                              Shadow(
                                blurRadius: 4,
                                color: Colors.black,
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (widget.contentType == 'live')
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.circle,
                                color: Colors.white,
                                size: 8,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'LIVE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Video info panel (for movies/series)
          if (widget.contentType != 'live' && _isInitialized)
            _buildVideoInfoPanel(),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: AppColors.primary,
          ),
          const SizedBox(height: 24),
          Text(
            'Loading ${widget.contentType == 'live' ? 'Live Stream' : 'Video'}...',
            style: TextStyle(
              color: AppColors.textPrimary.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.title,
            style: TextStyle(
              color: AppColors.textTertiary.withOpacity(0.6),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, color: AppColors.textTertiary),
            label: Text(
              'Go Back',
              style: TextStyle(color: AppColors.textTertiary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.error,
              size: 64,
            ),
            const SizedBox(height: 24),
            Text(
              'Unable to Play Video',
              style: TextStyle(
                color: AppColors.textPrimary.withOpacity(0.9),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _errorMessage,
              style: TextStyle(
                color: AppColors.textTertiary.withOpacity(0.7),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Stream URL: ${widget.streamUrl}',
              style: TextStyle(
                color: AppColors.textTertiary.withOpacity(0.5),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _initializePlayer,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                TextButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Go Back'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoInfoPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(
            color: AppColors.backgroundLighter,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Play/Pause button
          IconButton(
            onPressed: () {
              if (_videoPlayerController!.value.isPlaying) {
                _videoPlayerController!.pause();
              } else {
                _videoPlayerController!.play();
              }
              setState(() {});
            },
            icon: Icon(
              _videoPlayerController!.value.isPlaying
                  ? Icons.pause_circle_filled
                  : Icons.play_circle_filled,
              color: AppColors.primary,
              size: 48,
            ),
          ),
          const SizedBox(width: 8),
          // Progress indicator
          Expanded(
            child: ValueListenableBuilder<VideoPlayerValue>(
              valueListenable: _videoPlayerController!,
              builder: (context, value, child) {
                final duration = value.duration;
                final position = value.position;
                final progress = duration.inMilliseconds > 0
                    ? position.inMilliseconds / duration.inMilliseconds
                    : 0.0;
                
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppColors.backgroundLighter,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(position),
                          style: TextStyle(
                            color: AppColors.textTertiary.withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          _formatDuration(duration),
                          style: TextStyle(
                            color: AppColors.textTertiary.withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          // Volume control
          IconButton(
            onPressed: () {
              _showVolumeDialog();
            },
            icon: Icon(
              _videoPlayerController!.value.volume > 0
                  ? Icons.volume_up
                  : Icons.volume_off,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    
    return duration.inHours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }

  void _showVolumeDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.volume_up, color: AppColors.textPrimary),
                      const SizedBox(width: 16),
                      const Text(
                        'Volume',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${(_videoPlayerController!.value.volume * 100).round()}%',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Slider(
                    value: _videoPlayerController!.value.volume,
                    onChanged: (value) {
                      _videoPlayerController!.setVolume(value);
                      setModalState(() {});
                      setState(() {});
                    },
                    activeColor: AppColors.primary,
                    inactiveColor: AppColors.backgroundLighter,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [0, 0.25, 0.5, 0.75, 1.0].map((volume) {
                      return TextButton(
                        onPressed: () {
                          _videoPlayerController!.setVolume(volume);
                          setModalState(() {});
                          setState(() {});
                        },
                        child: Text(
                          '${(volume * 100).round()}%',
                          style: TextStyle(
                            color: _videoPlayerController!.value.volume == volume
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
