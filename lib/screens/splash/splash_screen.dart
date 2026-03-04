import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:make_my_zen/screens/home/home_screen.dart';
import 'package:make_my_zen/screens/login/login_screen.dart';
import 'package:make_my_zen/shared_pref/shared_pref.dart';
import 'package:make_my_zen/utils/animation_helper/animated_page_route.dart';
import 'package:make_my_zen/utils/app_colors.dart';
import 'package:make_my_zen/utils/media_query.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToAuth();
  }

  void _navigateToAuth() async {
    await Future.delayed(const Duration(seconds: 2));

    final isLoggedIn = await SharedPrefHelper.isLoggedIn();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      AnimatedPageRoute(
        page: isLoggedIn ? const HomeScreen() : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MQ.width(context),
        height: MQ.height(context),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColor.pink, AppColor.purple, AppColor.blue],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200.w,
              height: 200.w,
              child: Image.asset(
                'assets/images/make_my_zen_app_icon.png',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'MakeMyZen',
              style: TextStyle(
                fontSize: 22.sp,
                color: AppColor.white,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
