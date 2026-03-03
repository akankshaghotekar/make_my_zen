import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:make_my_zen/api/api_service.dart';
import 'package:make_my_zen/model/blessing_model.dart';
import 'package:make_my_zen/model/healing_modality_model.dart';
import 'package:make_my_zen/model/meditation_combo_model.dart';
import 'package:make_my_zen/screens/home/order_personalized_healing/steps/preffered_name_screen.dart';
import 'package:make_my_zen/screens/meditation_detail/meditation_detail_screen.dart';
import 'package:make_my_zen/screens/meditation_detail/meditation_series_detail_screen.dart';
import 'package:make_my_zen/shared_pref/shared_pref.dart';
import 'package:make_my_zen/utils/animation_helper/animated_page_route.dart';
import 'package:make_my_zen/utils/app_colors.dart';
import 'package:make_my_zen/utils/common/common_bottom_nav.dart';
import 'package:make_my_zen/utils/common/common_drawer.dart';
import 'package:make_my_zen/utils/common/common_gradient_button.dart';
import 'package:make_my_zen/utils/common/favorites_store.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Map<String, bool> _localFavourite = {};

  BlessingModel? blessing;
  bool isBlessingLoading = true;

  List<HealingModalityModel> healingModalities = [];
  bool isHealingLoading = true;

  List<MeditationComboModel> meditationCombos = [];
  bool isComboLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadHomeData();
    });
  }

  Future<void> _loadHomeData() async {
    _loadHealingModalities();
    _loadMeditationCombos();
    _loadBlessing();
  }

  Future<void> _loadMeditationCombos() async {
    final userSrNo = await SharedPrefHelper.getUserSrNo();
    if (userSrNo == null) return;

    await Future.delayed(const Duration(milliseconds: 100));
    final cached = await SharedPrefHelper.getCachedCombos();
    if (cached != null && mounted) {
      setState(() {
        meditationCombos = cached;
        for (final combo in cached) {
          _localFavourite[combo.srNo] = combo.isFavourite;
        }
        isComboLoading = false;
      });
    }

    final res = await ApiService.getComboHealings(userSrNo);

    if (!mounted) return;

    await SharedPrefHelper.saveCachedCombos(res);

    setState(() {
      meditationCombos = res;
      for (final combo in res) {
        _localFavourite[combo.srNo] = combo.isFavourite;
      }
      isComboLoading = false;
    });
  }

  Future<void> _loadHealingModalities() async {
    final cached = await SharedPrefHelper.getCachedHealingModalities();
    if (cached != null && mounted) {
      setState(() {
        healingModalities = cached;
        isHealingLoading = false;
      });
    }

    final res = await ApiService.getHealingModalities();

    if (!mounted) return;

    setState(() {
      healingModalities = res;
      isHealingLoading = false;
    });
  }

  Future<void> _loadBlessing() async {
    final list = await ApiService.getBlessings();

    if (list.isNotEmpty) {
      setState(() {
        blessing = list.first;
        isBlessingLoading = false;
      });
    } else {
      setState(() => isBlessingLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      drawer: CommonDrawer(onClose: () => Navigator.pop(context)),

      /// CUSTOM APP BAR WITH SHADOW
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
              builder: (context) {
                return IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: const Icon(Icons.menu, color: Colors.black),
                );
              },
            ),

            centerTitle: true,
            title: Image.asset(
              'assets/images/make-my-zen-logo.png',
              height: 36.h,
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 120.h),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),

            _sectionTitle("Blessings of the Day"),

            SizedBox(height: 12.h),

            /// BLESSINGS CARD
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14.r),
                    child: Image.asset(
                      'assets/images/home-img.png',
                      height: 200.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  isBlessingLoading
                      ? const SizedBox.shrink()
                      : Text(
                          blessing?.blessingName ?? "",
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ],
              ),
            ),

            SizedBox(height: 14.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CommonGradientButton(
                title: "Get Your Personalized Healing",
                onTap: () {
                  Navigator.push(
                    context,
                    AnimatedPageRoute(page: const PreferredNameScreen()),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(color: Colors.grey.shade300, thickness: 2.5.w),
            ),

            /// WAYS TO MEDITATE
            _centerTitle("Ways to Meditate"),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 12.w),
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColor.lightGrey,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: SizedBox(
                height: 235.h,
                child: RepaintBoundary(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    cacheExtent: 300,
                    addRepaintBoundaries: true,
                    addAutomaticKeepAlives: true,
                    padding: EdgeInsets.fromLTRB(12.w, 4.h, 12.w, 10.h),

                    children: isHealingLoading
                        ? List.generate(3, (_) => _skeletonCard())
                        : healingModalities.map((item) {
                            return Padding(
                              padding: EdgeInsets.only(right: 12.w),
                              child: _simpleMeditateCard(
                                context: context,
                                image:
                                    "https://makemyzen.com/make_my_zen/uploads/healing_modalities/${item.image}",
                                title: item.name,
                                healingModalitiesSrNo: item.srNo,
                              ),
                            );
                          }).toList(),
                  ),
                ),
              ),
            ),

            /// MEDITATION SERIES
            _centerTitle("Meditation Series"),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 12.w),
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColor.lightGrey,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: SizedBox(
                height: 250.h,
                child: RepaintBoundary(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    cacheExtent: 300,
                    addRepaintBoundaries: true,
                    addAutomaticKeepAlives: true,
                    padding: EdgeInsets.fromLTRB(12.w, 4.h, 12.w, 10.h),
                    children: isComboLoading
                        ? List.generate(
                            3,
                            (_) => _skeletonCard(width: 220, height: 250),
                          )
                        : meditationCombos.map((item) {
                            return Padding(
                              padding: EdgeInsets.only(right: 12.w),
                              child: _simpleSeriesCard(
                                context: context,
                                combo: item,
                              ),
                            );
                          }).toList(),
                  ),
                ),
              ),
            ),

            SizedBox(height: 26.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CommonGradientButton(
                title: "Get Your Personalized Healing",
                onTap: () {
                  Navigator.push(
                    context,
                    AnimatedPageRoute(page: const PreferredNameScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      /// FLOATING BOTTOM NAV
      bottomNavigationBar: const CommonBottomNav(currentIndex: 0),
    );
  }

  /// TITLES
  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Text(
        title,
        style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _centerTitle(String title) {
    return Center(
      child: Text(
        title,
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _simpleMeditateCard({
    required BuildContext context,
    required String image,
    required String title,
    required String healingModalitiesSrNo,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          AnimatedPageRoute(
            page: MeditationDetailScreen(
              healingModalitiesSrNo: healingModalitiesSrNo,
            ),
          ),
        );
      },
      child: Container(
        width: 200.w,
        decoration: BoxDecoration(
          color: AppColor.white,
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
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              child: CachedNetworkImage(
                imageUrl: image,
                height: 150.h,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: Colors.grey.shade300),
                errorWidget: (_, __, ___) =>
                    const Icon(Icons.broken_image, size: 40),
                memCacheHeight: 300,
                memCacheWidth: 400,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Text(
                title,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _simpleSeriesCard({
    required BuildContext context,
    required MeditationComboModel combo,
  }) {
    final isLiked = _localFavourite[combo.srNo] ?? combo.isFavourite;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          AnimatedPageRoute(
            page: MeditationSeriesDetailScreen(
              title: combo.name,
              image:
                  "https://makemyzen.com/make_my_zen/uploads/meditation_combo/${combo.image}",
              comboSrNo: combo.srNo,
              commercials: combo.commercials,
            ),
          ),
        );
      },
      child: Container(
        width: 220.w,
        decoration: BoxDecoration(
          color: AppColor.white,
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
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.r),
                  ),
                  child: CachedNetworkImage(
                    imageUrl:
                        "https://makemyzen.com/make_my_zen/uploads/meditation_combo/${combo.image}",
                    height: 130.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        Container(color: Colors.grey.shade300),
                    errorWidget: (_, __, ___) =>
                        const Icon(Icons.broken_image, size: 40),
                    memCacheHeight: 300,
                  ),
                ),
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: GestureDetector(
                    onTap: () async {
                      final userSrNo = await SharedPrefHelper.getUserSrNo();
                      if (userSrNo == null) return;

                      setState(() {
                        _localFavourite[combo.srNo] = !isLiked;
                      });

                      try {
                        if (!isLiked) {
                          await ApiService.addComboFavourite(
                            userSrNo: userSrNo,
                            meditationComboSrNo: combo.srNo,
                          );
                        } else {
                          await ApiService.removeComboFavourite(
                            userSrNo: userSrNo,
                            meditationComboSrNo: combo.srNo,
                          );
                        }
                      } catch (e) {
                        setState(() {
                          _localFavourite[combo.srNo] = isLiked;
                        });
                      }
                    },

                    child: Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        size: 18.sp,
                        color: isLiked ? AppColor.pink : Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Text(
                combo.name,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
              ),
            ),

            const Spacer(),

            Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Container(
                width: 100.w,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: Colors.purple.shade200,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12.r),
                    bottomRight: Radius.circular(12.r),
                  ),
                ),
                child: Text(
                  combo.commercials,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _skeletonCard({double width = 200, double height = 235}) {
    return Container(
      width: width.w,
      margin: EdgeInsets.only(right: 12.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(16.r),
      ),
    );
  }
}
