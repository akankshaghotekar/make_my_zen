import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:make_my_zen/api/api_service.dart';
import 'package:make_my_zen/model/personalised_healing_model.dart';
import 'package:make_my_zen/screens/cart/cart_therapy_detail_screen.dart';
import 'package:make_my_zen/shared_pref/shared_pref.dart';
import 'package:make_my_zen/utils/app_colors.dart';
import 'package:make_my_zen/utils/common/common_bottom_nav.dart';
import 'package:make_my_zen/utils/common/common_drawer.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isLoading = true;
  List<PersonalisedHealingModel> healings = [];

  @override
  void initState() {
    super.initState();
    _loadHealings();
  }

  Future<void> _loadHealings() async {
    final user = await SharedPrefHelper.getUser();
    if (user == null) {
      setState(() => isLoading = false);
      return;
    }

    healings = await ApiService.getPersonalisedHealing(userSrNo: user.userSrNo);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      drawer: CommonDrawer(onClose: () => Navigator.pop(context)),

      /// APP BAR (UNCHANGED)
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : healings.isEmpty
          ? Center(
              child: Text(
                "No Personalized Healing found",
                style: TextStyle(fontSize: 16.sp, color: Colors.grey),
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              itemCount: healings.length,
              separatorBuilder: (_, __) =>
                  Divider(thickness: 1, color: Colors.grey.shade300),
              itemBuilder: (context, index) {
                final item = healings[index];

                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CartTherapyDetailScreen(
                            orderSrNo: item.orderSrNo,
                            title: item.meditationType,
                            image: "assets/images/meditation-series.png",
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.meditationType,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                "Date : ${item.orderDate}",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "Status : ${item.healerStatus}",
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

      /// BOTTOM NAV (UNCHANGED)
      bottomNavigationBar: const CommonBottomNav(currentIndex: 3),
    );
  }
}
