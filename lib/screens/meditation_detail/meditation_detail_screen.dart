import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:make_my_zen/api/api_service.dart';
import 'package:make_my_zen/model/healing_modality_detail_model.dart';
import 'package:make_my_zen/model/healing_modality_model.dart';
import 'package:make_my_zen/utils/app_colors.dart';

class MeditationDetailScreen extends StatefulWidget {
  final String healingModalitiesSrNo;

  const MeditationDetailScreen({
    super.key,
    required this.healingModalitiesSrNo,
  });

  @override
  State<MeditationDetailScreen> createState() => _MeditationDetailScreenState();
}

class _MeditationDetailScreenState extends State<MeditationDetailScreen> {
  final ScrollController _descriptionScrollController = ScrollController();

  HealingModalityDetailModel? detail;
  bool isLoading = true;

  late String currentSrNo;
  List<HealingModalityModel> otherModalities = [];

  @override
  void initState() {
    super.initState();
    currentSrNo = widget.healingModalitiesSrNo;
    _loadDetail();
    _loadOtherModalities();
  }

  @override
  void dispose() {
    _descriptionScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadDetail() async {
    setState(() => isLoading = true);

    final res = await ApiService.getHealingModalityDetail(currentSrNo);
    if (!mounted) return;

    setState(() {
      detail = res;
      isLoading = false;
    });
  }

  Future<void> _loadOtherModalities() async {
    final res = await ApiService.getHealingModalities();
    if (!mounted) return;
    setState(() => otherModalities = res);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,

      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Image.asset('assets/images/make-my-zen-logo.png', height: 36.h),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TOP SECTION WITH FADE
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: _topSection(key: ValueKey(currentSrNo)),
            ),

            /// OTHER SECTION (FIXED)
            _otherSection(),
            SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }

  /// TOP SECTION (IMAGE + DESCRIPTION)
  Widget _topSection({required Key key}) {
    if (isLoading || detail == null) {
      return Column(
        key: key,
        children: [
          Container(
            height: 260.h,
            width: double.infinity,
            color: Colors.grey.shade200,
            child: const Center(child: CircularProgressIndicator()),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 22.h,
                  width: 200.w,
                  color: Colors.grey.shade300,
                ),
                SizedBox(height: 12.h),
                Container(height: 120.h, color: Colors.grey.shade300),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(
          "https://makemyzen.com/make_my_zen/uploads/healing_modalities/${detail!.image}",
          height: 260.h,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                detail!.name,
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                height: 250.h,
                child: Scrollbar(
                  controller: _descriptionScrollController,
                  thumbVisibility: false,
                  radius: Radius.circular(8.r),
                  thickness: 4,
                  child: SingleChildScrollView(
                    controller: _descriptionScrollController,

                    child: Html(
                      data: detail!.description,
                      style: {
                        "p": Style(
                          fontSize: FontSize(14.sp),
                          color: Colors.grey.shade700,
                          lineHeight: LineHeight(1.6),
                        ),
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// OTHER SECTION
  Widget _otherSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            "Other",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 200.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: otherModalities.length,
            itemBuilder: (_, i) {
              final item = otherModalities[i];
              return GestureDetector(
                onTap: () {
                  if (item.srNo == currentSrNo) return;

                  setState(() {
                    currentSrNo = item.srNo;
                  });

                  _loadDetail();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _loopCard(item),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// LOOP CARD
  Widget _loopCard(HealingModalityModel item) {
    return Container(
      width: 160.w,
      margin: EdgeInsets.only(left: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            "https://makemyzen.com/make_my_zen/uploads/healing_modalities/${item.image}",
            height: 110.h,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Text(
              item.name,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
