import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:make_my_zen/api/api_service.dart';
import 'package:make_my_zen/model/visualization_model.dart';
import 'package:make_my_zen/screens/home/order_personalized_healing/subscription_payment_screen.dart';
import 'package:make_my_zen/utils/animation_helper/animated_page_route.dart';
import 'package:make_my_zen/utils/app_colors.dart';
import 'package:make_my_zen/utils/common/common_bottom_nav.dart';
import 'package:make_my_zen/utils/personalised_healing_data.dart';

class VisualizationStepScreen extends StatefulWidget {
  final String gender;
  const VisualizationStepScreen({super.key, required this.gender});

  @override
  State<VisualizationStepScreen> createState() =>
      _VisualizationStepScreenState();
}

class _VisualizationStepScreenState extends State<VisualizationStepScreen> {
  List<VisualizationModel> visualizations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVisualizations();
  }

  Future<void> _loadVisualizations() async {
    final res = await ApiService.getVisualizations();

    setState(() {
      visualizations = res;
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
            /// STEP INDICATOR (6)
            _stepIndicator(),

            SizedBox(height: 28.h),

            /// TITLE
            Text(
              "Visualization",
              style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w800),
            ),

            SizedBox(height: 6.h),

            Text(
              "Please select graphic",
              style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
            ),

            SizedBox(height: 24.h),

            /// GRID
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      itemCount: visualizations.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 18.h,
                        childAspectRatio: 0.9,
                      ),
                      itemBuilder: (_, index) {
                        final item = visualizations[index];

                        return _visualCard(
                          context,
                          srNo: item.srNo,
                          image: item.image,
                          title: item.name,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: const CommonBottomNav(currentIndex: 0),
    );
  }

  /// STEP INDICATOR
  Widget _stepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _completedStep(),
        _stepLine(),
        _completedStep(),
        _stepLine(),
        _completedStep(),
        _stepLine(),
        _completedStep(),
        _stepLine(),
        _completedStep(),
        _stepLine(),
        _activeStep("6"),
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

  /// VISUAL CARD
  Widget _visualCard(
    BuildContext context, {
    required String srNo,
    required String image,
    required String title,
  }) {
    return GestureDetector(
      onTap: () {
        PersonalisedHealingData.visualizationSrNo = srNo;

        if (PersonalisedHealingData.visualizationSrNo.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please select a visualization")),
          );
          return;
        }

        Navigator.push(
          context,
          AnimatedPageRoute(page: const SubscriptionPaymentScreen()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                child: CachedNetworkImage(
                  imageUrl:
                      "https://makemyzen.com/make_my_zen/uploads/visulization/$image",
                  width: double.infinity,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 300),

                  /// Loader while image loads
                  placeholder: (context, url) => Container(
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.pink,
                    ),
                  ),

                  /// Error case
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
