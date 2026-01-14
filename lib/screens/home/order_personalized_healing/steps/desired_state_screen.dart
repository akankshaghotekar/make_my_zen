import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:make_my_zen/api/api_service.dart';
import 'package:make_my_zen/model/desired_state_model.dart';
import 'package:make_my_zen/screens/home/order_personalized_healing/steps/select_gender_screen.dart';
import 'package:make_my_zen/utils/app_colors.dart';
import 'package:make_my_zen/utils/common/common_bottom_nav.dart';
import 'package:make_my_zen/utils/common/common_gradient_button.dart';
import 'package:make_my_zen/utils/personalised_healing_data.dart';

class DesiredStateScreen extends StatefulWidget {
  const DesiredStateScreen({super.key});

  @override
  State<DesiredStateScreen> createState() => _DesiredStateScreenState();
}

class _DesiredStateScreenState extends State<DesiredStateScreen> {
  List<DesiredStateModel> desiredStates = [];
  Map<String, bool> selectedStates = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDesiredStates();
  }

  Future<void> _loadDesiredStates() async {
    final res = await ApiService.getDesiredStates();

    setState(() {
      desiredStates = res;

      /// initialize selection map
      for (var item in res) {
        selectedStates[item.name] = false;
      }

      isLoading = false;
    });
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
            /// STEP INDICATOR
            _stepIndicator(),

            SizedBox(height: 24.h),

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

            SizedBox(height: 20.h),

            /// CHECKBOX GRID
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 12.h,
                      childAspectRatio: 4,
                      children: desiredStates.map((state) {
                        return _stateTile(state.name);
                      }).toList(),
                    ),
            ),

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
              onTap: () {
                final selected = selectedStates.entries
                    .where((e) => e.value)
                    .map((e) => e.key)
                    .toList();

                if (selected.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please select at least one desired state"),
                    ),
                  );
                  return;
                }

                PersonalisedHealingData.desiredStateSrNo = selected.join(",");

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SelectGenderScreen()),
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
        _activeStep("4"),
        _stepLine(),
        _inactiveStep("5"),
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
        style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),
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
      child: Text(text, style: const TextStyle(color: Colors.grey)),
    );
  }

  Widget _stepLine() {
    return Expanded(child: Container(height: 2, color: Colors.grey.shade300));
  }

  /// STATE TILE
  Widget _stateTile(String title) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedStates[title] = !selectedStates[title]!;
        });
      },
      child: Row(
        children: [
          Checkbox(
            value: selectedStates[title],
            activeColor: Colors.pink,
            onChanged: (val) {
              setState(() {
                selectedStates[title] = val!;
              });
            },
          ),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
