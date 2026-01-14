import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:make_my_zen/api/api_service.dart';
import 'package:make_my_zen/model/commercial_plan_model.dart';
import 'package:make_my_zen/utils/app_colors.dart';
import 'package:make_my_zen/utils/common/common_drawer.dart';

class SubscriptionPlanScreen extends StatefulWidget {
  const SubscriptionPlanScreen({super.key});

  @override
  State<SubscriptionPlanScreen> createState() => _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState extends State<SubscriptionPlanScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<CommercialPlanModel> plans = [];
  Map<String, List<String>> planFeatures = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    plans = await ApiService.getCommercialPlans();

    for (final plan in plans) {
      final details = await ApiService.getCommercialDetails(
        commercialSrNo: plan.srNo,
      );

      planFeatures[plan.srNo] = details.map((e) => e.feature).toList();
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightGrey,
      drawer: CommonDrawer(onClose: () => Navigator.pop(context)),

      /// APP BAR WITH SHADOW
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
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            centerTitle: true,
            title: Image.asset(
              'assets/images/make-my-zen-logo.png',
              height: 36.h,
            ),
          ),
        ),
      ),

      /// BODY
      body: Column(
        children: [
          /// MONTHLY / YEARLY TABS
          Container(
            color: AppColor.lightGrey,
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: Colors.pink, width: 3),
              ),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              labelStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(text: "Monthly"),
                Tab(text: "Yearly"),
              ],
            ),
          ),

          /// PLANS
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_monthlyPlans(), _yearlyPlans()],
            ),
          ),
        ],
      ),
    );
  }

  /// ------------------ MONTHLY ------------------
  Widget _monthlyPlans() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: plans.map((plan) {
          return Column(
            children: [
              _planCard(
                title: plan.name,
                price: "\$${plan.monthlyRate}",
                features: planFeatures[plan.srNo] ?? [],
              ),
              SizedBox(height: 20.h),
            ],
          );
        }).toList(),
      ),
    );
  }

  /// ------------------ YEARLY ------------------
  Widget _yearlyPlans() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: plans.map((plan) {
          return Column(
            children: [
              _planCard(
                title: plan.name,
                price: "\$${plan.yearlyRate}",
                features: planFeatures[plan.srNo] ?? [],
              ),
              SizedBox(height: 20.h),
            ],
          );
        }).toList(),
      ),
    );
  }

  /// ------------------ PLAN CARD ------------------
  Widget _planCard({
    required String title,
    required String price,
    required List<String> features,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE + PRICE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
              ),
              Text(
                price,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          /// FEATURES
          ...features.map(
            (e) => Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(e, style: TextStyle(fontSize: 14.sp)),
            ),
          ),
        ],
      ),
    );
  }
}
