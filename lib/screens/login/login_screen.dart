import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:make_my_zen/api/api_service.dart';
import 'package:make_my_zen/screens/register_screen/register_screen.dart';
import 'package:make_my_zen/screens/verification/otp_verification_screen.dart';
import 'package:make_my_zen/utils/animation_helper/animated_page_route.dart';
import 'package:make_my_zen/utils/animation_helper/loading_screen.dart';
import 'package:make_my_zen/utils/app_colors.dart';
import 'package:make_my_zen/utils/common/common_gradient_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoginSelected = false;
  bool isLoading = false;

  final TextEditingController _emailController = TextEditingController();

  Future<void> _handleLogin() async {
    setState(() => isLoading = true);

    final res = await ApiService.sendOtp(email: _emailController.text.trim());

    setState(() => isLoading = false);

    if (res['status'] == 0) {
      Navigator.push(
        context,
        AnimatedPageRoute(
          page: LoadingScreen(email: _emailController.text.trim()),
        ),
      );
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
              SizedBox(height: 40.h),

              /// LOGO
              Image.asset('assets/images/make-my-zen-logo.png', width: 110.w),

              SizedBox(height: 32.h),

              /// REGISTER / LOGIN TOGGLE
              Container(
                height: 50.h,
                decoration: BoxDecoration(
                  color: AppColor.lightGrey,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Stack(
                  children: [
                    AnimatedAlign(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      alignment: isLoginSelected
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        width: (MediaQuery.of(context).size.width - 46.w) / 2,
                        height: 45.h,
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        _toggleText("Register", !isLoginSelected, () {
                          setState(() => isLoginSelected = false);
                        }),
                        _toggleText("Login", isLoginSelected, () {
                          setState(() => isLoginSelected = true);
                        }),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30.h),

              /// EMAIL FIELD
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",

                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
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

              SizedBox(height: 26.h),

              /// BUTTON (already bold inside widget)
              CommonGradientButton(
                title: isLoading
                    ? "Please wait..."
                    : isLoginSelected
                    ? "Login"
                    : "Sign up",
                onTap: isLoading
                    ? null
                    : () {
                        /// EMAIL VALIDATION (for both login & register)
                        if (_emailController.text.trim().isEmpty ||
                            !_emailController.text.contains('@')) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please enter a valid email"),
                            ),
                          );
                          return;
                        }

                        /// LOGIN FLOW
                        if (isLoginSelected) {
                          _handleLogin();
                        }
                        /// REGISTER FLOW
                        else {
                          Navigator.push(
                            context,
                            AnimatedPageRoute(
                              page: RegisterDetailsScreen(
                                email: _emailController.text.trim(),
                                isEditProfile: false,
                              ),
                            ),
                          );
                        }
                      },
              ),

              SizedBox(height: 18.h),

              /// TERMS
              if (!isLoginSelected)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Text.rich(
                    TextSpan(
                      text: "By signing up you accept our ",
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(
                          text: "terms and conditions",
                          style: TextStyle(
                            color: AppColor.linkBlue,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              SizedBox(height: 22.h),

              /// BOTTOM LINK
              Text.rich(
                TextSpan(
                  text: isLoginSelected
                      ? "Don't have an account? "
                      : "Have an account? ",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: isLoginSelected ? "Register" : "Login",
                      style: TextStyle(
                        color: AppColor.linkBlue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// TOGGLE TEXT
  Widget _toggleText(String title, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.black : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }
}
