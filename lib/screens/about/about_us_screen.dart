import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:make_my_zen/utils/app_colors.dart';
import 'package:make_my_zen/utils/common/common_drawer.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightGrey,
      drawer: CommonDrawer(onClose: () => Navigator.pop(context)),

      /// APP BAR
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Builder(
              builder: (context) {
                return IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: const Icon(Icons.menu, color: Colors.black),
                );
              },
            ),
            title: Text(
              "About us",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            centerTitle: false,
          ),
        ),
      ),

      /// BODY
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "MakeMyZen – Guided Meditation & Daily Reflections",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),

            SizedBox(height: 12.h),

            Text(
              "MakeMyZen offers a space to explore guided meditations, "
              "personalized sessions, and daily blessings. Choose from "
              "single meditations or series designed for different experiences. "
              "Whether you prefer structured meditation journeys or standalone "
              "sessions, MakeMyZen provides a variety of options to explore at "
              "your own pace.",
              style: TextStyle(
                fontSize: 15.sp,
                height: 1.6,
                color: Colors.black87,
              ),
            ),

            SizedBox(height: 20.h),

            Text(
              "Download MakeMyZen and begin your journey today.",
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
