import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:make_my_zen/screens/home/order_personalized_healing/steps/visualization_screen.dart';
import 'package:make_my_zen/utils/app_colors.dart';
import 'package:make_my_zen/utils/common/common_bottom_nav.dart';
import 'package:make_my_zen/utils/common/common_gradient_button.dart';
import 'package:make_my_zen/utils/personalised_healing_data.dart';

class SelectGenderScreen extends StatefulWidget {
  const SelectGenderScreen({super.key});

  @override
  State<SelectGenderScreen> createState() => _SelectGenderScreenState();
}

class _SelectGenderScreenState extends State<SelectGenderScreen> {
  String? selectedGender;

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
            /// STEP INDICATOR (✔ ✔ ✔ ✔ 5)
            _stepIndicator(),

            SizedBox(height: 28.h),

            /// TITLE
            Text(
              "Desired state",
              style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w800),
            ),

            SizedBox(height: 6.h),

            Text(
              "Select all state that apply",
              style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
            ),

            SizedBox(height: 40.h),

            /// GENDER CARDS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _genderCard(
                  gender: "Female",
                  image: "assets/images/select-female.png",
                ),
                _genderCard(
                  gender: "Male",
                  image: "assets/images/select-male.png",
                ),
              ],
            ),

            const Spacer(),

            /// BACK BUTTON
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.pink.shade400, width: 2),
                minimumSize: Size(double.infinity, 50.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                "Back",
                style: TextStyle(
                  color: Colors.pink.shade400,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
            ),

            SizedBox(height: 12.h),

            /// NEXT BUTTON
            CommonGradientButton(
              title: "Next",
              onTap: selectedGender == null
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please select gender")),
                      );
                    }
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              VisualizationStepScreen(gender: selectedGender!),
                        ),
                      );
                    },
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),

      bottomNavigationBar: const CommonBottomNav(currentIndex: 0),
    );
  }

  /// STEP INDICATOR
  Widget _stepIndicator() {
    return Row(
      children: [
        _completedStep(),
        _stepLine(),
        _completedStep(),
        _stepLine(),
        _completedStep(),
        _stepLine(),
        _completedStep(),
        _stepLine(),
        _activeStep("5"),
      ],
    );
  }

  Widget _completedStep() {
    return Container(
      width: 28.w,
      height: 28.w,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.pink,
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.check, size: 16, color: Colors.white),
    );
  }

  Widget _activeStep(String text) {
    return Container(
      width: 28.w,
      height: 28.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.pink, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.pink),
      ),
    );
  }

  Widget _stepLine() {
    return Expanded(child: Container(height: 2, color: Colors.grey.shade300));
  }

  /// GENDER CARD
  Widget _genderCard({required String gender, required String image}) {
    final bool isSelected = selectedGender == gender;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = gender;
          PersonalisedHealingData.voice = gender.toLowerCase();
        });
      },
      child: Container(
        width: 150.w,
        height: 180.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? Colors.pink : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, height: 90.h),
            SizedBox(height: 12.h),
            Text(
              gender,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
