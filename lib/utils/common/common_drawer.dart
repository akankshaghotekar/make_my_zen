import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:make_my_zen/screens/about/about_us_screen.dart';
import 'package:make_my_zen/screens/cart/cart_screen.dart';
import 'package:make_my_zen/screens/home/home_screen.dart';
import 'package:make_my_zen/screens/login/login_screen.dart';
import 'package:make_my_zen/screens/purchased_subscription/purchased_subscription_screen.dart';
import 'package:make_my_zen/screens/reach_us/reach_us_screen.dart';
import 'package:make_my_zen/screens/register_screen/register_screen.dart';
import 'package:make_my_zen/shared_pref/shared_pref.dart';
import 'package:make_my_zen/utils/app_colors.dart';

class CommonDrawer extends StatelessWidget {
  final VoidCallback onClose;

  const CommonDrawer({super.key, required this.onClose});

  Future<void> _navigate(BuildContext context, String menu) async {
    Navigator.pop(context); // close drawer

    Widget? page;

    switch (menu) {
      case "Home":
        page = const HomeScreen();
        break;

      case "About us":
        page = const AboutUsScreen();
        break;

      // case "Purchased Subscriptions":
      //   page = const PurchasedSubscriptionScreen();
      //   break;

      case "Your Personalized Healing":
        page = const CartScreen();
        break;

      case "Edit Profile":
        final user = await SharedPrefHelper.getUser();

        if (user != null) {
          page = RegisterDetailsScreen(
            email: user.email,
            isEditProfile: true,
            userSrNo: user.userSrNo,
          );
        }
        break;

      case "Reach us":
        page = const ReachUsScreen();
        break;

      case "Logout":
        await SharedPrefHelper.logout();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (_) => false,
        );
        return;
    }

    if (page != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => page!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColor.white,
      child: SafeArea(
        child: Column(
          children: [
            /// HEADER
            SizedBox(
              height: 120.h,
              child: Stack(
                children: [
                  /// CLOSE ICON (TOP RIGHT)
                  Positioned(
                    right: 12.w,
                    child: GestureDetector(
                      onTap: onClose,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 1.5),
                        ),
                        child: const Icon(Icons.close, size: 24),
                      ),
                    ),
                  ),

                  /// CENTER LOGO
                  Center(
                    child: Image.asset(
                      'assets/images/make-my-zen-logo.png',
                      height: 80.h,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            _drawerItem(context, "Home"),
            _divider(),
            _drawerItem(context, "About us"),
            _divider(),
            // _drawerItem(context, "Purchased Subscriptions"),
            // _divider(),
            _drawerItem(context, "Your Personalized Healing"),
            _divider(),
            _drawerItem(context, "Edit Profile"),
            _divider(),
            _drawerItem(context, "Reach us"),
            _divider(),

            const Spacer(),

            /// LOGOUT
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: InkWell(
                onTap: () => _navigate(context, "Logout"),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Logout",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  /// DRAWER ITEM
  Widget _drawerItem(BuildContext context, String title) {
    return InkWell(
      onTap: () => _navigate(context, title),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(height: 1, thickness: 1, color: Colors.grey.shade300);
  }
}
