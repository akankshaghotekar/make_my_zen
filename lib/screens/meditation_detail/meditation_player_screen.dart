import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:make_my_zen/utils/app_colors.dart';
import 'package:path_provider/path_provider.dart';

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

  @override
  void initState() {
    super.initState();
    if (widget.audioUrl != null && widget.audioUrl!.isNotEmpty) {
      _initPlayer();
    }
  }

  Future<void> _initPlayer() async {
    final file = await _downloadAudio(widget.audioUrl!);

    await _player.setSourceDeviceFile(file.path);

    final d = await _player.getDuration();
    if (d != null) {
      setState(() => totalDuration = d);
    }

    _player.onPositionChanged.listen((p) {
      setState(() => currentPosition = p);
    });

    _player.onPlayerComplete.listen((_) {
      setState(() => isPlaying = false);
    });
  }

  Future<File> _downloadAudio(String url) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${url.split('/').last}');

    if (!await file.exists()) {
      final res = await http.get(Uri.parse(url));
      await file.writeAsBytes(res.bodyBytes);
    }

    return file;
  }

  @override
  void dispose() {
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
        title: Image.asset('assets/images/make-my-zen-logo.png', height: 36.h),
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
                        "${_format(currentPosition)} / ${_format(totalDuration)}",
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
                  onTap: hasAudio
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
              onChanged: hasAudio
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
