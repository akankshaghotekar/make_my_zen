import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:make_my_zen/screens/home/order_personalized_healing/steps/preffered_name_screen.dart';
import 'package:make_my_zen/screens/purchased_subscription/subscription_plan_screen.dart';
import 'package:make_my_zen/utils/app_colors.dart';
import 'package:make_my_zen/utils/common/common_drawer.dart';
import 'package:make_my_zen/utils/common/common_gradient_button.dart';

class PurchasedSubscriptionScreen extends StatefulWidget {
  const PurchasedSubscriptionScreen({super.key});

  @override
  State<PurchasedSubscriptionScreen> createState() =>
      _PurchasedSubscriptionScreenState();
}

class _PurchasedSubscriptionScreenState
    extends State<PurchasedSubscriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      drawer: CommonDrawer(onClose: () => Navigator.pop(context)),

      /// APP BAR WITH SHADOW (same as Home)
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
            title: Text(
              "Purchased Subscription",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                height: 1.5,
              ),
            ),
          ),
        ),
      ),

      /// BODY (EMPTY STATE)
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 40.h),
            Text(
              "You have not Order a Personalized Meditation\n!!! Do Order One",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                height: 1.5,
              ),
            ),

            SizedBox(height: 24.h),

            /// ORDER BUTTON
            CommonGradientButton(
              title: "Purchase Subscription",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SubscriptionPlanScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
