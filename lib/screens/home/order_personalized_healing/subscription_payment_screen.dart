import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:make_my_zen/api/api_service.dart';
import 'package:make_my_zen/screens/home/home_screen.dart';
import 'package:make_my_zen/shared_pref/shared_pref.dart';
import 'package:make_my_zen/utils/app_colors.dart';
import 'package:make_my_zen/utils/common/common_gradient_button.dart';
import 'package:make_my_zen/utils/personalised_healing_data.dart';

class SubscriptionPaymentScreen extends StatefulWidget {
  const SubscriptionPaymentScreen({super.key});

  @override
  State<SubscriptionPaymentScreen> createState() =>
      _SubscriptionPaymentScreenState();
}

class _SubscriptionPaymentScreenState extends State<SubscriptionPaymentScreen> {
  final TextEditingController _couponController = TextEditingController();

  bool isPlacingOrder = false;

  double subtotal = 49.99;
  double discount = 0.0;

  double get finalAmount => subtotal - discount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightGrey,

      appBar: AppBar(
        backgroundColor: AppColor.white,
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
            SizedBox(height: 50.h),

            // /// TITLE
            // Center(
            //   child: Text(
            //     "Subscription amount : ${subtotal.toStringAsFixed(2)}",
            //     style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
            //   ),
            // ),

            // SizedBox(height: 24.h),

            // /// COUPON LABEL
            // Text(
            //   "Have a coupon code",
            //   style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            // ),

            // SizedBox(height: 8.h),

            // /// COUPON FIELD + APPLY
            // Row(
            //   children: [
            //     Expanded(
            //       child: TextFormField(
            //         controller: _couponController,
            //         decoration: InputDecoration(
            //           labelText: "Enter coupon code",
            //           floatingLabelBehavior: FloatingLabelBehavior.always,
            //           filled: true,
            //           fillColor: Colors.white,
            //           contentPadding: EdgeInsets.symmetric(
            //             horizontal: 14.w,
            //             vertical: 18.h,
            //           ),
            //           labelStyle: TextStyle(
            //             fontSize: 14.sp,
            //             fontWeight: FontWeight.w500,
            //             color: Colors.black,
            //           ),
            //           enabledBorder: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(14.r),
            //             borderSide: BorderSide(
            //               color: Colors.pink.shade400,
            //               width: 2,
            //             ),
            //           ),
            //           focusedBorder: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(14.r),
            //             borderSide: BorderSide(
            //               color: Colors.pink.shade400,
            //               width: 2,
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //     SizedBox(width: 10.w),
            //     SizedBox(
            //       height: 52.h,
            //       child: ElevatedButton(
            //         onPressed: _applyCoupon,
            //         style: ElevatedButton.styleFrom(
            //           backgroundColor: Colors.grey.shade300,
            //           elevation: 0,
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(12.r),
            //           ),
            //         ),
            //         child: Text(
            //           "Apply",
            //           style: TextStyle(
            //             color: Colors.black87,
            //             fontWeight: FontWeight.w600,
            //             fontSize: 14.sp,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),

            // SizedBox(height: 24.h),

            // /// AMOUNT CARD
            // Container(
            //   width: double.infinity,
            //   padding: EdgeInsets.all(16.w),
            //   decoration: BoxDecoration(
            //     color: Colors.pink.shade50,
            //     borderRadius: BorderRadius.circular(16.r),
            //   ),
            //   child: Column(
            //     children: [
            //       _amountRow("Subtotal", subtotal),
            //       SizedBox(height: 12.h),
            //       _amountRow("Discount", discount),
            //       Divider(height: 24.h, thickness: 1),
            //       _amountRow("Final Amount", finalAmount, isBold: true),
            //     ],
            //   ),
            // ),
            // const Spacer(),

            /// PAY BUTTON
            CommonGradientButton(
              title: "Submit For Personalized Meditation",
              onTap: isPlacingOrder ? null : _placeOrder,
            ),

            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  /// ROW
  Widget _amountRow(String label, double value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        Text(
          value.toStringAsFixed(2),
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// APPLY COUPON (Dummy)
  void _applyCoupon() {
    if (_couponController.text.trim().isNotEmpty) {
      setState(() {
        discount = 10.0; // demo discount
      });
    }
  }

  // /// MAKE PAYMENT
  // void _makePayment() {

  //   debugPrint("Proceed to payment: $finalAmount");
  // }

  /// Place order
  void _placeOrder() async {
    if (isPlacingOrder) return;

    setState(() {
      isPlacingOrder = true;
    });

    if (PersonalisedHealingData.name.isEmpty ||
        PersonalisedHealingData.meditationTypeSrNo.isEmpty ||
        PersonalisedHealingData.issueSrNo.isEmpty ||
        PersonalisedHealingData.desiredStateSrNo.isEmpty ||
        PersonalisedHealingData.voice.isEmpty ||
        PersonalisedHealingData.visualizationSrNo.isEmpty) {
      setState(() {
        isPlacingOrder = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all steps")),
      );
      return;
    }

    final userSrno = await SharedPrefHelper.getUserSrNo();
    if (userSrno == null) return;
    final res = await ApiService.addPersonalisedHealing(
      userSrNo: userSrno,
      name: PersonalisedHealingData.name,
      meditationTypeSrNo: PersonalisedHealingData.meditationTypeSrNo,
      issueSrNo: PersonalisedHealingData.issueSrNo,
      desiredStateSrNo: PersonalisedHealingData.desiredStateSrNo,
      voice: PersonalisedHealingData.voice,
      visualizationSrNo: PersonalisedHealingData.visualizationSrNo,
    );

    if (res != null && res.status == 0) {
      debugPrint("Order placed successfully");
      debugPrint("Order SRNO: ${res.orderSrNo}");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Submit successfully")));

      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      });
    } else {
      setState(() {
        isPlacingOrder = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(res?.message ?? "failed")));
    }
  }
}
