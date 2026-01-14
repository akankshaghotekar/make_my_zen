import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:make_my_zen/screens/home/order_personalized_healing/steps/select_meditation_screen.dart';
import 'package:make_my_zen/utils/app_colors.dart';
import 'package:make_my_zen/utils/common/common_bottom_nav.dart';
import 'package:make_my_zen/utils/common/common_gradient_button.dart';
import 'package:make_my_zen/utils/personalised_healing_data.dart';

class PreferredNameScreen extends StatefulWidget {
  const PreferredNameScreen({super.key});

  @override
  State<PreferredNameScreen> createState() => _PreferredNameScreenState();
}

class _PreferredNameScreenState extends State<PreferredNameScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightGrey,

      appBar: AppBar(
        backgroundColor: AppColor.lightGrey,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),

            /// STEP INDICATOR
            _stepIndicator(),

            SizedBox(height: 30.h),

            /// TITLE
            Text(
              "Preferred Name",
              style: TextStyle(
                fontSize: 26.sp,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),

            SizedBox(height: 20.h),

            /// LABEL
            Text(
              "Name",
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),

            SizedBox(height: 6.h),

            /// INPUT
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Enter your Name",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 18.h,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide(width: 2, color: Colors.pink.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide(width: 2, color: Colors.pink.shade400),
                ),
              ),
            ),

            const Spacer(),

            /// NEXT BUTTON
            CommonGradientButton(
              title: "Next",
              onTap: () {
                if (_nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter your name")),
                  );
                  return;
                }
                PersonalisedHealingData.name = _nameController.text.trim();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SelectMeditationScreen(),
                  ),
                );
              },
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),

      /// KEEP BOTTOM NAV CONSISTENT
      bottomNavigationBar: const CommonBottomNav(currentIndex: 0),
    );
  }

  /// STEP INDICATOR WIDGET
  Widget _stepIndicator() {
    return Row(
      children: [
        _stepCircle("1", true),
        _stepLine(),
        _stepCircle("2", false),
        _stepLine(),
        _stepCircle("3", false),
      ],
    );
  }

  Widget _stepCircle(String text, bool active) {
    return Container(
      width: 28.w,
      height: 28.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: active ? Colors.pink : Colors.grey, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: active ? Colors.pink : Colors.grey,
        ),
      ),
    );
  }

  Widget _stepLine() {
    return Expanded(child: Container(height: 2, color: Colors.grey.shade300));
  }
}
