import 'package:flutter/material.dart';
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
  bool _isPlaying = true;
  bool _showControls = true;
  double _volume = 1.0;
  bool _isFullscreen = false;

  @override
  void initState() {
    super.initState();
    _hideControlsAfterDelay();
  }

  void _hideControlsAfterDelay() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _isPlaying) {
        setState(() => _showControls = false);
      }
    });
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
    if (_showControls) {
      _hideControlsAfterDelay();
    }
  }

  void _togglePlayPause() {
    setState(() => _isPlaying = !_isPlaying);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Video placeholder
            Container(
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.contentType == 'live'
                          ? Icons.live_tv
                          : widget.contentType == 'movie'
                              ? Icons.movie
                              : Icons.video_library,
                      color: AppColors.textTertiary.withOpacity(0.5),
                      size: 80,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Video Player\n${widget.streamUrl.isEmpty ? "(Demo Mode)" : ""}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textTertiary.withOpacity(0.5),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Controls overlay
            if (_showControls)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                    stops: const [0.0, 0.2, 0.8, 1.0],
                  ),
                ),
              ),

            // Top bar
            if (_showControls)
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (widget.contentType == 'live')
                              Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'LIVE',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite_border, color: Colors.white),
                        onPressed: () {
                          // TODO: Toggle favorite
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings, color: Colors.white),
                        onPressed: () {
                          // TODO: Show settings
                        },
                      ),
                    ],
                  ),
                ),
              ),

            // Center play button
            if (_showControls)
              Center(
                child: GestureDetector(
                  onTap: _togglePlayPause,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),

            // Bottom controls
            if (_showControls)
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Progress bar
                      if (widget.contentType != 'live')
                        SliderTheme(
                          data: SliderThemeData(
                            activeTrackColor: AppColors.primary,
                            inactiveTrackColor: Colors.white.withOpacity(0.3),
                            thumbColor: AppColors.primary,
                            overlayColor: AppColors.primary.withOpacity(0.2),
                            trackHeight: 4,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 6,
                            ),
                          ),
                          child: Slider(
                            value: 0.3,
                            onChanged: (value) {
                              // TODO: Seek
                            },
                          ),
                        ),

                      // Control buttons
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                            ),
                            onPressed: _togglePlayPause,
                          ),
                          if (widget.contentType != 'live') ...[
                            IconButton(
                              icon: const Icon(Icons.replay_10, color: Colors.white),
                              onPressed: () {
                                // TODO: Rewind 10s
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.forward_10, color: Colors.white),
                              onPressed: () {
                                // TODO: Forward 10s
                              },
                            ),
                          ],
                          const Spacer(),
                          // Volume control
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _volume == 0
                                    ? Icons.volume_off
                                    : _volume < 0.5
                                        ? Icons.volume_down
                                        : Icons.volume_up,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 80,
                                child: SliderTheme(
                                  data: SliderThemeData(
                                    activeTrackColor: Colors.white,
                                    inactiveTrackColor: Colors.white.withOpacity(0.3),
                                    thumbColor: Colors.white,
                                    trackHeight: 2,
                                    thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 4,
                                    ),
                                  ),
                                  child: Slider(
                                    value: _volume,
                                    onChanged: (value) {
                                      setState(() => _volume = value);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          // Fullscreen toggle
                          IconButton(
                            icon: Icon(
                              _isFullscreen
                                  ? Icons.fullscreen_exit
                                  : Icons.fullscreen,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() => _isFullscreen = !_isFullscreen);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
