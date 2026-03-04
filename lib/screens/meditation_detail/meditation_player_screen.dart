import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:make_my_zen/utils/app_colors.dart';

class MeditationPlayerScreen extends StatefulWidget {
  final String title;
  final String? audioUrl;

  const MeditationPlayerScreen({super.key, required this.title, this.audioUrl});

  @override
  State<MeditationPlayerScreen> createState() => _MeditationPlayerScreenState();
}

class _MeditationPlayerScreenState extends State<MeditationPlayerScreen> {
  final AudioPlayer _player = AudioPlayer();

  bool get hasAudio => widget.audioUrl != null && widget.audioUrl!.isNotEmpty;

  Duration totalDuration = Duration.zero;
  Duration currentPosition = Duration.zero;
  bool isPlaying = false;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<void>? _completeSub;
  bool isReady = false;
  bool isDurationReady = false;

  @override
  void initState() {
    super.initState();
    if (widget.audioUrl != null && widget.audioUrl!.isNotEmpty) {
      _initPlayer();
    }
  }

  Future<void> _initPlayer() async {
    await _player.setSourceUrl(widget.audioUrl!);

    final d = await _player.getDuration();
    if (d != null && mounted) {
      setState(() {
        totalDuration = d;
        isDurationReady = true;
      });
    }

    _positionSub = _player.onPositionChanged.listen((p) {
      if (!mounted) return;
      setState(() => currentPosition = p);
    });

    _completeSub = _player.onPlayerComplete.listen((_) {
      if (!mounted) return;
      setState(() => isPlaying = false);
    });
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _completeSub?.cancel();
    _player.stop();
    _player.dispose();
    super.dispose();
  }

  String _format(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return "${two(d.inMinutes)}:${two(d.inSeconds % 60)}";
  }

  @override
  Widget build(BuildContext context) {
    final maxSeconds = totalDuration.inSeconds > 0
        ? totalDuration.inSeconds.toDouble()
        : 1.0;

    final currentSeconds = currentPosition.inSeconds.toDouble().clamp(
      0.0,
      maxSeconds,
    );
    return Scaffold(
      backgroundColor: AppColor.white,

      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Image.asset(
          'assets/images/make_my_zen_app_icon.png',
          height: 36.h,
        ),
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24.h),

            Text(
              "Player",
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700),
            ),

            SizedBox(height: 20.h),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        isDurationReady
                            ? "${_format(currentPosition)} / ${_format(totalDuration)}"
                            : "Loading audio...",

                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                /// PLAY / PAUSE
                GestureDetector(
                  onTap: hasAudio && isDurationReady
                      ? () async {
                          if (isPlaying) {
                            await _player.pause();
                          } else {
                            await _player.resume();
                          }
                          setState(() => isPlaying = !isPlaying);
                        }
                      : null,

                  child: Container(
                    width: 46.w,
                    height: 46.w,
                    decoration: BoxDecoration(
                      color: hasAudio ? Colors.pink : Colors.grey.shade400,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            /// PROGRESS BAR
            Slider(
              value: currentSeconds,
              max: maxSeconds,
              onChanged: hasAudio && isDurationReady
                  ? (value) async {
                      await _player.seek(Duration(seconds: value.toInt()));
                    }
                  : null,

              activeColor: Colors.pink,
              inactiveColor: Colors.grey.shade300,
            ),
          ],
        ),
      ),
    );
  }
}
