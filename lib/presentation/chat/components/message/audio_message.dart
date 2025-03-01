import 'dart:math';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class SupabaseAudioPlayer extends StatefulWidget {

  const SupabaseAudioPlayer({
    required this.audioUrl, super.key,
    this.title,
    this.primaryColor = const Color(0xFF2AABEE), // Telegram-like blue
    this.secondaryColor = Colors.grey,
    this.backgroundColor = Colors.transparent,
    this.height = 48.0, // Compact height
    this.showTitle = false, // Hide title by default for compact mode
  });
  final String audioUrl;
  final String? title;
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final double height;
  final bool showTitle;

  @override
  SupabaseAudioPlayerState createState() => SupabaseAudioPlayerState();
}

class SupabaseAudioPlayerState extends State<SupabaseAudioPlayer> with WidgetsBindingObserver {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initAudioSession();
    _initPlayer();
  }
  
  Future<void> _initAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
  }
  
  Future<void> _initPlayer() async {
    // Listen to player state changes
    _player.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      
      setState(() {
        _isPlaying = isPlaying && processingState == ProcessingState.ready;
        _isLoading = processingState == ProcessingState.loading || 
                     processingState == ProcessingState.buffering;
      });
    });
    
    // Listen to position changes
    _player.positionStream.listen((position) {
      setState(() {
        _position = position;
      });
    });
    
    // Listen to duration changes
    _player.durationStream.listen((duration) {
      if (duration != null) {
        setState(() {
          _duration = duration;
        });
      }
    });
    
    // Try to load the audio from the Supabase URL
    try {
      await _player.setUrl(widget.audioUrl);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error loading audio: $e');
    }
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _player.pause();
    }
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _player.dispose();
    super.dispose();
  }
  
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
  
  @override
  Widget build(BuildContext context) => Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(22), // Rounded corners like Telegram
      ),
      child: Row(
        children: [
          // Play/Pause button
          SizedBox(
            width: widget.height, // Square aspect ratio
            height: widget.height,
            child: _isLoading 
                ? Container(
                    padding: const EdgeInsets.all(12),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(widget.primaryColor),
                    ),
                  )
                : InkWell(
                    onTap: () {
                      if (_isPlaying) {
                        _player.pause();
                      } else {
                        _player.play();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: widget.height * 0.5,
                      ),
                    ),
                  ),
          ),
          
          // Title if enabled
          if (widget.showTitle && widget.title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                widget.title!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          
          // Progress bar
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 2, // Thinner track like Telegram
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                activeTrackColor: widget.primaryColor,
                inactiveTrackColor: widget.secondaryColor.withOpacity(0.3),
                thumbColor: widget.primaryColor,
                overlayColor: widget.primaryColor.withOpacity(0.2),
              ),
              child: Slider(
                max: _duration.inMilliseconds.toDouble() > 0 
                    ? _duration.inMilliseconds.toDouble() 
                    : 1.0,
                value: min(_position.inMilliseconds.toDouble(), 
                          _duration.inMilliseconds.toDouble()),
                onChanged: _isLoading 
                    ? null 
                    : (value) {
                        final position = Duration(milliseconds: value.toInt());
                        _player.seek(position);
                      },
              ),
            ),
          ),
          
          // Duration indicator
          Padding(
            padding: const EdgeInsets.only(right: 12.0, left: 4.0),
            child: Text(
              _isLoading ? "--:--" : _formatDuration(_duration - _position),
              style: TextStyle(
                fontSize: 12,
                color: widget.secondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
}

// Example of Telegram-style wrapper to make it look even more authentic
class TelegramStyleAudioPlayer extends StatelessWidget {
  
  const TelegramStyleAudioPlayer({
    required this.audioUrl, super.key,
    this.title,
  });
  final String audioUrl;
  final String? title;
  
  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
      decoration: BoxDecoration(
        color: const Color(0xFFE6EBEE), // Light gray bubble
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: SupabaseAudioPlayer(
        audioUrl: audioUrl,
        title: title,
        height: 40.0, // Even more compact
      ),
    );
}

