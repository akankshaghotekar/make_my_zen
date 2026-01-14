import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:make_my_zen/api/api_service.dart';
import 'package:make_my_zen/model/issue_model.dart';
import 'package:make_my_zen/screens/home/order_personalized_healing/steps/desired_state_screen.dart';
import 'package:make_my_zen/utils/app_colors.dart';
import 'package:make_my_zen/utils/common/common_bottom_nav.dart';
import 'package:make_my_zen/utils/common/common_gradient_button.dart';
import 'package:make_my_zen/utils/personalised_healing_data.dart';

class IssuesStepScreen extends StatefulWidget {
  const IssuesStepScreen({super.key});

  @override
  State<IssuesStepScreen> createState() => _IssuesStepScreenState();
}

class _IssuesStepScreenState extends State<IssuesStepScreen> {
  List<IssueModel> issueList = [];
  final Map<String, bool> selectedIssues = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadIssues();
  }

  Future<void> _loadIssues() async {
    final res = await ApiService.getIssues();

    if (!mounted) return;

    setState(() {
      issueList = res;
      for (var issue in issueList) {
        selectedIssues[issue.name] = false;
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
            /// STEP INDICATOR (✔ ✔ 3 4)
            _stepIndicator(),

            SizedBox(height: 24.h),

            Text(
              "Issues",
              style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w800),
            ),

            SizedBox(height: 6.h),

            Text(
              "Select all issues that apply",
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
                      children: issueList.map((issue) {
                        return _issueTile(issue.name);
                      }).toList(),
                    ),
            ),

            /// COMMENT BOX
            TextFormField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Comment",
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.all(14.w),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: 20.h),

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
                final selected = selectedIssues.entries
                    .where((e) => e.value)
                    .map((e) => e.key)
                    .toList();

                if (selected.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please select at least one issue"),
                    ),
                  );
                  return;
                }

                PersonalisedHealingData.issueSrNo = selected.join(",");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DesiredStateScreen()),
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
        _activeStep("3"),
        _stepLine(),
        _inactiveStep("4"),
      ],
    );
  }

  Widget _completedStep() {
    return Container(
      width: 28.w,
      height: 28.w,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.pink),
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

  /// ISSUE TILE
  Widget _issueTile(String title) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedIssues[title] = !(selectedIssues[title] ?? false);
        });
      },
      child: Row(
        children: [
          Checkbox(
            value: selectedIssues[title] ?? false,
            activeColor: Colors.pink,
            onChanged: (val) {
              setState(() {
                selectedIssues[title] = val!;
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
