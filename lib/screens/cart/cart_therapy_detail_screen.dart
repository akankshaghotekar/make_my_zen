import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:make_my_zen/api/api_service.dart';
import 'package:make_my_zen/model/personalised_healing_detail_model.dart';
import 'package:make_my_zen/screens/meditation_detail/meditation_player_screen.dart';
import 'package:make_my_zen/utils/animation_helper/animated_page_route.dart';
import 'package:make_my_zen/utils/app_colors.dart';
import 'package:make_my_zen/utils/common/common_drawer.dart';

class CartTherapyDetailScreen extends StatefulWidget {
  final String orderSrNo;
  final String title;
  final String image;

  const CartTherapyDetailScreen({
    super.key,
    required this.orderSrNo,
    required this.title,
    required this.image,
  });

  @override
  State<CartTherapyDetailScreen> createState() =>
      _CartTherapyDetailScreenState();
}

class _CartTherapyDetailScreenState extends State<CartTherapyDetailScreen> {
  bool isLoading = true;
  PersonalisedHealingDetailModel? detail;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    final res = await ApiService.getPersonalisedHealingDetail(
      orderSrNo: widget.orderSrNo,
    );

    if (res.isNotEmpty) {
      detail = res.first;
    }

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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            centerTitle: true,
            title: Image.asset(
              'assets/images/make_my_zen_app_icon.png',
              height: 36.h,
            ),
          ),
        ),
      ),

      /// BODY
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : detail == null
          ? const Center(child: Text("No data found"))
          : Padding(
              padding: EdgeInsets.all(16.w),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    AnimatedPageRoute(
                      page: MeditationPlayerScreen(
                        title: detail!.meditationType,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Row(
                    children: [
                      /// IMAGE (DEFAULT LOGO HANDLED)
                      Container(
                        width: 52.w,
                        height: 52.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.pink, width: 2),
                          image: DecorationImage(
                            image: detail!.fileName == null
                                ? const AssetImage(
                                    'assets/images/make_my_zen_app_icon.png',
                                  )
                                : AssetImage(widget.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      SizedBox(width: 12.w),

                      /// TITLE
                      Expanded(
                        child: Text(
                          detail!.meditationType,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
