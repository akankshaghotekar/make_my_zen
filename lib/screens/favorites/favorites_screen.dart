import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:make_my_zen/api/api_service.dart';
import 'package:make_my_zen/model/favorite_combo_model.dart';
import 'package:make_my_zen/shared_pref/shared_pref.dart';

import 'package:make_my_zen/utils/app_colors.dart';
import 'package:make_my_zen/utils/common/common_bottom_nav.dart';
import 'package:make_my_zen/utils/common/common_drawer.dart';
import 'package:make_my_zen/utils/common/favorites_store.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<FavoriteComboModel> favorites = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final user = await SharedPrefHelper.getUser();

    if (user == null) {
      setState(() => isLoading = false);
      return;
    }

    final res = await ApiService.getFavoriteCombos(userSrNo: user.userSrNo);

    setState(() {
      favorites = res;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      drawer: CommonDrawer(onClose: () => Navigator.pop(context)),

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
          : favorites.isEmpty
          ? Center(
              child: Text(
                "No favorites yet",
                style: TextStyle(fontSize: 16.sp, color: Colors.grey),
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              itemCount: favorites.length,
              separatorBuilder: (_, __) =>
                  Divider(thickness: 1, color: Colors.grey.shade300),
              itemBuilder: (context, index) {
                final item = favorites[index];

                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  child: Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                );
              },
            ),

      bottomNavigationBar: const CommonBottomNav(currentIndex: 1),
    );
  }
}
