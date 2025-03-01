import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class SupabaseVideoPlayer extends StatefulWidget {

  const SupabaseVideoPlayer({
    Key? key,
    required this.videoUrl,
    this.autoPlay = false,
    this.looping = false,
    this.showControls = true,
    this.aspectRatio = 16 / 9,
    this.primaryColor = const Color(0xFF2AABEE), // Telegram blue
    this.secondaryColor = Colors.grey,
    this.borderRadius = 12.0,
    this.height = 220.0,
    this.compact = false,
    this.thumbnailUrl,
  }) : super(key: key);
  final String videoUrl;
  final bool autoPlay;
  final bool looping;
  final bool showControls;
  final double aspectRatio;
  final Color primaryColor;
  final Color secondaryColor;
  final double borderRadius;
  final double height;
  final bool compact;
  final String? thumbnailUrl;

  @override
  SupabaseVideoPlayerState createState() => SupabaseVideoPlayerState();
}

class SupabaseVideoPlayerState extends State<SupabaseVideoPlayer> with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _showControls = true;
  bool _isBuffering = false;
  bool _isMuted = false;
  bool _isFullScreen = false;
  late AnimationController _animationController;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isDragging = false;
  bool _hasTapped = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    
    // Hide controls after a delay if autoplay is enabled
    if (widget.autoPlay) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted && _isPlaying) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.network(widget.videoUrl);
    
    // Add listeners for video events
    _controller.addListener(_videoListener);
    
    // Initialize the controller
    await _controller.initialize();
    
    if (mounted) {
      setState(() {
        _isInitialized = true;
        _duration = _controller.value.duration;
        
        // Apply autoplay setting
        if (widget.autoPlay) {
          _controller.play();
          _isPlaying = true;
          _animationController.forward();
        }
        
        // Apply looping setting
        _controller.setLooping(widget.looping);
      });
    }
  }
  
  void _videoListener() {
    if (!mounted) return;
    
    // Update playback state
    final isPlaying = _controller.value.isPlaying;
    if (_isPlaying != isPlaying && !_isDragging) {
      setState(() {
        _isPlaying = isPlaying;
      });
    }
    
    // Update buffering state
    final isBuffering = _controller.value.isBuffering;
    if (_isBuffering != isBuffering) {
      setState(() {
        _isBuffering = isBuffering;
      });
    }
    
    // Update position
    if (!_isDragging) {
      setState(() {
        _position = _controller.value.position;
      });
    }
    
    // Check for playback completion
    if (_controller.value.position >= _controller.value.duration && !widget.looping) {
      setState(() {
        _isPlaying = false;
        _showControls = true;
        _animationController.reverse();
      });
    }
  }
  
  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _controller.pause();
        _animationController.reverse();
      } else {
        _controller.play();
        _animationController.forward();
        
        // Auto-hide controls after a delay
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted && _isPlaying && !_hasTapped) {
            setState(() {
              _showControls = false;
            });
          }
          _hasTapped = false;
        });
      }
      _isPlaying = !_isPlaying;
    });
  }
  
  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }
  
  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      
      if (_isFullScreen) {
        // Enter full screen
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      } else {
        // Exit full screen
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      }
    });
  }
  
  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
      _hasTapped = true;
    });
  }
  
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    
    return duration.inHours > 0
        ? '${twoDigits(duration.inHours)}:$minutes:$seconds'
        : '$minutes:$seconds';
  }
  
  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    _animationController.dispose();
    
    // Reset screen orientation and system UI
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine if we're using compact mode
    final bool useCompactMode = widget.compact;
    
    return Container(
      height: _isFullScreen ? null : widget.height,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(
          _isFullScreen ? 0.0 : widget.borderRadius
        ),
      ),
      child: _isInitialized
          ? GestureDetector(
              onTap: _toggleControls,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Video content
                  AspectRatio(
                    aspectRatio: _isFullScreen
                        ? MediaQuery.of(context).size.width / MediaQuery.of(context).size.height
                        : widget.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                  
                  // Loading indicator
                  if (_isBuffering)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(widget.primaryColor),
                        strokeWidth: 2,
                      ),
                    ),
                  
                  // Tap to play indicator when paused and controls are hidden
                  if (!_isPlaying && !_showControls)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(12),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  
                  // Controls overlay
                  if (_showControls && widget.showControls)
                    useCompactMode
                        ? _buildCompactControls()
                        : _buildFullControls(),
                ],
              ),
            )
          : Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Display thumbnail if available
                  if (widget.thumbnailUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      child: Image.network(
                        widget.thumbnailUrl!,
                        fit: BoxFit.cover,
                        height: widget.height,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.black,
                          height: widget.height,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  
                  // Loading indicator
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(widget.primaryColor),
                  ),
                ],
              ),
            ),
    );
  }
  
  // Compact Telegram-style controls (minimal)
  Widget _buildCompactControls() => Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.7),
          ],
          stops: const [0.7, 1.0],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Progress bar
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 2,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
              activeTrackColor: widget.primaryColor,
              inactiveTrackColor: Colors.white.withOpacity(0.3),
              thumbColor: widget.primaryColor,
              overlayColor: widget.primaryColor.withOpacity(0.2),
            ),
            child: Slider(
              min: 0.0,
              max: _duration.inMilliseconds.toDouble(),
              value: _position.inMilliseconds.toDouble().clamp(
                0.0, _duration.inMilliseconds.toDouble(),
              ),
              onChanged: (value) {
                setState(() {
                  _position = Duration(milliseconds: value.toInt());
                  _isDragging = true;
                });
              },
              onChangeStart: (_) {
                setState(() {
                  _isDragging = true;
                });
              },
              onChangeEnd: (value) {
                setState(() {
                  _isDragging = false;
                });
                _controller.seekTo(Duration(milliseconds: value.toInt()));
              },
            ),
          ),
          
          // Bottom control row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Play/Pause button
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  iconSize: 28,
                  onPressed: _togglePlayPause,
                ),
                
                // Time indicator
                Text(
                  '${_formatDuration(_position)} / ${_formatDuration(_duration)}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                
                // Mute button
                IconButton(
                  icon: Icon(
                    _isMuted ? Icons.volume_off : Icons.volume_up,
                    color: Colors.white,
                  ),
                  iconSize: 22,
                  onPressed: _toggleMute,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  
  // Full featured controls
  Widget _buildFullControls() => Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top bar with title (if any) and fullscreen button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                    color: Colors.white,
                  ),
                  onPressed: _toggleFullScreen,
                ),
              ],
            ),
          ),
          
          // Center play/pause button
          IconButton(
            icon: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: _animationController,
              color: Colors.white,
              size: 48,
            ),
            iconSize: 64,
            onPressed: _togglePlayPause,
          ),
          
          // Bottom controls
          Column(
            children: [
              // Progress bar and time indicators
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Text(
                      _formatDuration(_position),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 4,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                          activeTrackColor: widget.primaryColor,
                          inactiveTrackColor: Colors.white.withOpacity(0.3),
                          thumbColor: widget.primaryColor,
                          overlayColor: widget.primaryColor.withOpacity(0.2),
                        ),
                        child: Slider(
                          min: 0.0,
                          max: _duration.inMilliseconds.toDouble(),
                          value: _position.inMilliseconds.toDouble().clamp(
                            0.0, _duration.inMilliseconds.toDouble(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _position = Duration(milliseconds: value.toInt());
                              _isDragging = true;
                            });
                          },
                          onChangeStart: (_) {
                            setState(() {
                              _isDragging = true;
                            });
                          },
                          onChangeEnd: (value) {
                            setState(() {
                              _isDragging = false;
                            });
                            _controller.seekTo(Duration(milliseconds: value.toInt()));
                          },
                        ),
                      ),
                    ),
                    Text(
                      _formatDuration(_duration),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
              
              // Bottom control row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Play/Pause button
                    IconButton(
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                      ),
                      onPressed: _togglePlayPause,
                    ),
                    
                    // Additional controls
                    Row(
                      children: [
                        // Mute button
                        IconButton(
                          icon: Icon(
                            _isMuted ? Icons.volume_off : Icons.volume_up,
                            color: Colors.white,
                          ),
                          onPressed: _toggleMute,
                        ),
                        
                        // Fullscreen button
                        IconButton(
                          icon: Icon(
                            _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                            color: Colors.white,
                          ),
                          onPressed: _toggleFullScreen,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
}

// Telegram-style wrapper for the video player
class TelegramStyleVideoPlayer extends StatelessWidget {
  
  const TelegramStyleVideoPlayer({
    required this.videoUrl, super.key,
    this.thumbnailUrl,
    this.autoPlay = false,
  });
  final String videoUrl;
  final String? thumbnailUrl;
  final bool autoPlay;
  
  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: const Color(0xFFE6EBEE), // Light gray bubble
        borderRadius: BorderRadius.circular(18.0),
      ),
      padding: const EdgeInsets.all(4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.0),
        child: SupabaseVideoPlayer(
          videoUrl: videoUrl,
          thumbnailUrl: thumbnailUrl,
          autoPlay: autoPlay,
          height: 200.0,
          compact: true,
          borderRadius: 14.0,
        ),
      ),
    );
}
