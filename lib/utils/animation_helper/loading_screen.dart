import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:make_my_zen/screens/verification/otp_verification_screen.dart';
import 'package:make_my_zen/utils/animation_helper/animated_page_route.dart';
import 'package:make_my_zen/utils/app_colors.dart';

class LoadingScreen extends StatefulWidget {
  final String email;
  const LoadingScreen({super.key, required this.email});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  void _navigate() async {
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      AnimatedPageRoute(page: OtpVerificationScreen(email: widget.email)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/make-my-zen-logo.png', width: 120.w),
            SizedBox(height: 16.h),
            Text(
              "Loading...",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
