import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:make_my_zen/utils/app_colors.dart';

class CommonGradientButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const CommonGradientButton({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isLoading = onTap == null;

    return InkWell(
      borderRadius: BorderRadius.circular(14.r),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          gradient: LinearGradient(
            colors: isLoading
                ? [Colors.grey.shade400, Colors.grey.shade400]
                : const [AppColor.blue, AppColor.purple, AppColor.pink],
          ),
        ),
        alignment: Alignment.center,
        child: isLoading
            ? SizedBox(
                width: 24.w,
                height: 24.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                title,
                style: TextStyle(
                  color: AppColor.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
