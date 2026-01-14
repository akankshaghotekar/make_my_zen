import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:make_my_zen/api/api_service.dart';
import 'package:make_my_zen/model/meditation_type_model.dart';
import 'package:make_my_zen/screens/home/order_personalized_healing/steps/issues_screen.dart';
import 'package:make_my_zen/utils/app_colors.dart';
import 'package:make_my_zen/utils/common/common_bottom_nav.dart';
import 'package:make_my_zen/utils/personalised_healing_data.dart';

class SelectMeditationScreen extends StatefulWidget {
  const SelectMeditationScreen({super.key});

  @override
  State<SelectMeditationScreen> createState() => _SelectMeditationScreenState();
}

class _SelectMeditationScreenState extends State<SelectMeditationScreen> {
  List<MeditationTypeModel> meditationList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMeditations();
  }

  Future<void> _loadMeditations() async {
    final res = await ApiService.getMeditationTypes();

    if (!mounted) return;

    setState(() {
      meditationList = res;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

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

            /// STEP INDICATOR (STEP 2)
            _stepIndicator(),

            SizedBox(height: 24.h),

            /// TITLE
            Center(
              child: Text(
                "Select Meditation",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
              ),
            ),

            SizedBox(height: 20.h),

            /// GRID OPTIONS
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      itemCount: meditationList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14.w,
                        mainAxisSpacing: 16.h,
                        childAspectRatio: 0.9,
                      ),
                      itemBuilder: (_, index) {
                        final item = meditationList[index];

                        return GestureDetector(
                          onTap: () {
                            PersonalisedHealingData.meditationTypeSrNo =
                                item.srNo;

                            if (PersonalisedHealingData
                                .meditationTypeSrNo
                                .isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please select a meditation"),
                                ),
                              );
                              return;
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const IssuesStepScreen(),
                              ),
                            );
                          },
                          child: _meditationCard(item.image, item.title),
                        );
                      },
                    ),
            ),

            SizedBox(height: 12.h),

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

            SizedBox(height: 20.h),
          ],
        ),
      ),

      bottomNavigationBar: const CommonBottomNav(currentIndex: 0),
    );
  }

  /// STEP INDICATOR (✔ 2 3)
  Widget _stepIndicator() {
    return Row(
      children: [
        _completedStep(),
        _stepLine(),
        _activeStep("2"),
        _stepLine(),
        _inactiveStep("3"),
      ],
    );
  }

  Widget _completedStep() {
    return Container(
      width: 28.w,
      height: 28.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.pink, width: 2),
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
        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.pink),
      ),
    );
  }

  Widget _inactiveStep(String text) {
    return Container(
      width: 28.w,
      height: 28.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.grey),
      ),
    );
  }

  Widget _stepLine() {
    return Expanded(child: Container(height: 2, color: Colors.grey.shade300));
  }

  /// CARD
  Widget _meditationCard(String image, String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsetsGeometry.only(
                top: 12.h,
                left: 12.w,
                right: 12.w,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: Image.network(
                  "https://makemyzen.com/make_my_zen/uploads/meditation_type/$image",
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image_not_supported),
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
            child: Text(
              title,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
