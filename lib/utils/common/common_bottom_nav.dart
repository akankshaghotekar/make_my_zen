import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:make_my_zen/screens/cart/cart_screen.dart';
import 'package:make_my_zen/screens/favorites/favorites_screen.dart';
import 'package:make_my_zen/screens/home/home_screen.dart';
import 'package:make_my_zen/screens/register_screen/register_screen.dart';
import 'package:make_my_zen/shared_pref/shared_pref.dart';
import 'package:make_my_zen/utils/app_colors.dart';

class CommonBottomNav extends StatelessWidget {
  final int currentIndex;

  const CommonBottomNav({super.key, required this.currentIndex});

  Future<void> _onTap(BuildContext context, int index) async {
    if (index == currentIndex && index != 0) return;

    if (index == 0) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    }

    Widget? page;

    switch (index) {
      // case 0:
      //   page = const HomeScreen();
      //   break;

      case 1:
        page = const FavoritesScreen();
        break;

      case 2:
        final user = await SharedPrefHelper.getUser();

        if (user != null) {
          page = RegisterDetailsScreen(
            email: user.email,
            isEditProfile: true,
            userSrNo: user.userSrNo,
          );
        }
        break;

      case 3:
        page = const CartScreen();
        break;
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
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Container(
        height: 64.h,
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(context, Icons.home, 0),
            _navItem(context, Icons.favorite_border, 1),
            _navItem(context, Icons.person_outline, 2),
            _navItem(context, Icons.shopping_bag_outlined, 3),
          ],
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, int index) {
    final bool isActive = index == currentIndex;

    return GestureDetector(
      onTap: () => _onTap(context, index),
      child: Icon(
        icon,
        size: 28.sp,
        color: isActive ? Colors.black : Colors.grey,
      ),
    );
  }
}
