import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:make_my_zen/api/api_service.dart';
import 'package:make_my_zen/screens/home/home_screen.dart';
import 'package:make_my_zen/shared_pref/shared_pref.dart';
import 'package:make_my_zen/utils/app_colors.dart';
import 'package:make_my_zen/utils/common/common_gradient_button.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  const OtpVerificationScreen({super.key, required this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool isLoading = false;

  Future<void> _verifyOtp() async {
    if (_otpController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter OTP")));
      return;
    }

    setState(() => isLoading = true);

    final res = await ApiService.login(
      email: widget.email,
      otp: _otpController.text.trim(),
    );

    setState(() => isLoading = false);

    if (res != null) {
      await SharedPrefHelper.saveLogin(
        userSrNo: res.userSrNo,
        name: res.name,
        email: res.email,
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (_) => false,
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid OTP")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 100.h),

              /// OTP FIELD
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter one time password sent on your email",
                  labelStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  filled: true,
                  fillColor: AppColor.lightGrey,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 18.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              SizedBox(height: 30.h),

              /// SIGN IN BUTTON
              CommonGradientButton(
                title: isLoading ? "Signing in..." : "Sign in",
                onTap: isLoading ? null : _verifyOtp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
