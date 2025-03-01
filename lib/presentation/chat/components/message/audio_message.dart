import 'dart:math';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

/// Data class to hold the position information needed for the UI
class PositionData {
  final Duration position;
  final Duration duration;

  PositionData(this.position, this.duration);
}

class SupabaseAudioPlayer extends StatefulWidget {
  const SupabaseAudioPlayer({
    required this.audioUrl,
    super.key,
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

class SupabaseAudioPlayerState extends State<SupabaseAudioPlayer>
    with WidgetsBindingObserver {
  final _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  Future<void> _init() async {
    // Configure the audio session
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());

    // Listen to errors during playback
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      debugPrint('A stream error occurred: $e');
    });

    // Try to load audio from source
    try {
      await _player.setUrl(widget.audioUrl);
    } catch (e) {
      debugPrint('Error loading audio source: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when the app is paused
      _player.pause();
    }
  }

  @override
  void dispose() {
    try {
      WidgetsBinding.instance.removeObserver(this);
      // Properly clean up the player
      _player.stop().then((_) {
        _player.dispose();
      });
    } catch (e) {
      print('DISPOSE PLAYER: $e');
    }
    super.dispose();
  }

  /// Combines position and duration streams into a single stream of PositionData
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest2<Duration, Duration?, PositionData>(
        _player.positionStream,
        _player.durationStream,
        (position, duration) => PositionData(
          position,
          duration ?? Duration.zero,
        ),
      );

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
          borderRadius:
              BorderRadius.circular(22), // Rounded corners like Telegram
        ),
        child: Row(
          children: [
            // Play/Pause button using StreamBuilder
            SizedBox(
              width: widget.height, // Square aspect ratio
              height: widget.height,
              child: StreamBuilder<PlayerState>(
                stream: _player.playerStateStream,
                builder: (context, snapshot) {
                  final playerState = snapshot.data;
                  final processingState = playerState?.processingState;
                  final playing = playerState?.playing;

                  // Loading or buffering state
                  if (processingState == ProcessingState.loading ||
                      processingState == ProcessingState.buffering) {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(widget.primaryColor),
                      ),
                    );
                  }

                  // Paused or stopped state
                  else if (playing != true) {
                    return InkWell(
                      onTap: _player.play,
                      child: Container(
                        decoration: BoxDecoration(
                          color: widget.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: widget.height * 0.5,
                        ),
                      ),
                    );
                  }

                  // Playing state
                  else if (processingState != ProcessingState.completed) {
                    return InkWell(
                      onTap: _player.pause,
                      child: Container(
                        decoration: BoxDecoration(
                          color: widget.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.pause,
                          color: Colors.white,
                          size: widget.height * 0.5,
                        ),
                      ),
                    );
                  }

                  // Completed state
                  else {
                    return InkWell(
                      onTap: () => _player.seek(Duration.zero),
                      child: Container(
                        decoration: BoxDecoration(
                          color: widget.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.replay,
                          color: Colors.white,
                          size: widget.height * 0.5,
                        ),
                      ),
                    );
                  }
                },
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

            // Progress bar using StreamBuilder
            Expanded(
              child: StreamBuilder<PositionData>(
                stream: _positionDataStream,
                builder: (context, snapshot) {
                  final positionData = snapshot.data ??
                      PositionData(Duration.zero, Duration.zero);

                  return SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 2, // Thinner track like Telegram
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 6),
                      overlayShape:
                          const RoundSliderOverlayShape(overlayRadius: 12),
                      activeTrackColor: widget.primaryColor,
                      inactiveTrackColor:
                          widget.secondaryColor.withOpacity(0.3),
                      thumbColor: widget.primaryColor,
                      overlayColor: widget.primaryColor.withOpacity(0.2),
                    ),
                    child: Slider(
                      max: positionData.duration.inMilliseconds.toDouble() > 0
                          ? positionData.duration.inMilliseconds.toDouble()
                          : 1.0,
                      value: min(
                          positionData.position.inMilliseconds.toDouble(),
                          positionData.duration.inMilliseconds.toDouble()),
                      onChanged: (value) {
                        final position = Duration(milliseconds: value.toInt());
                        _player.seek(position);
                      },
                    ),
                  );
                },
              ),
            ),

            // Duration indicator using StreamBuilder
            StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                final position = positionData?.position ?? Duration.zero;
                final duration = positionData?.duration ?? Duration.zero;

                return Padding(
                  padding: const EdgeInsets.only(right: 12.0, left: 4.0),
                  child: Text(
                    position == Duration.zero && duration == Duration.zero
                        ? "--:--"
                        : _formatDuration(duration - position),
                    style: TextStyle(
                      fontSize: 12,
                      color: widget.secondaryColor,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
}

// Example of Telegram-style wrapper to make it look even more authentic
class TelegramStyleAudioPlayer extends StatelessWidget {
  const TelegramStyleAudioPlayer({
    required this.audioUrl,
    super.key,
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
