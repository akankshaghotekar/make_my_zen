import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:make_my_zen/api/api_service.dart';
import 'package:make_my_zen/model/meditation_combo_detail_model.dart';
import 'package:make_my_zen/model/meditation_combo_meditation_model.dart';
import 'package:make_my_zen/screens/meditation_detail/meditation_player_screen.dart';
import 'package:make_my_zen/shared_pref/shared_pref.dart';
import 'package:make_my_zen/utils/app_colors.dart';

class MeditationSeriesDetailScreen extends StatefulWidget {
  final String title;
  final String image;
  final String comboSrNo;
  final String commercials;

  const MeditationSeriesDetailScreen({
    super.key,
    required this.title,
    required this.image,
    required this.comboSrNo,
    required this.commercials,
  });

  @override
  State<MeditationSeriesDetailScreen> createState() =>
      _MeditationSeriesDetailScreenState();
}

class _MeditationSeriesDetailScreenState
    extends State<MeditationSeriesDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  MeditationComboDetailModel? comboDetail;
  bool isLoading = true;

  List<MeditationComboMeditationModel> meditations = [];
  bool isMeditationLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadComboDetail();
    _loadMeditations();
  }

  Future<void> _loadMeditations() async {
    final userSrNo = await SharedPrefHelper.getUserSrNo();
    if (userSrNo == null) return;

    final res = await ApiService.getComboHealingMeditations(
      userSrNo: userSrNo,
      meditationComboSrNo: widget.comboSrNo,
    );

    if (!mounted) return;

    setState(() {
      meditations = res;
      isMeditationLoading = false;
    });
  }

  Future<void> _loadComboDetail() async {
    final userSrNo = await SharedPrefHelper.getUserSrNo();
    if (userSrNo == null) return;

    final res = await ApiService.getComboHealingDetail(
      userSrNo: userSrNo,
      meditationComboSrNo: widget.comboSrNo,
    );

    if (!mounted) return;

    setState(() {
      comboDetail = res;
      isLoading = false;
    });
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

      body: Column(
        children: [
          /// IMAGE
          Image.network(
            widget.image,
            height: 260.h,
            width: double.infinity,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.image_not_supported, size: 40),
          ),

          SizedBox(height: 12.h),

          /// TITLE
          Text(
            widget.title,
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w700),
          ),

          SizedBox(height: 6.h),

          /// FREE TAG
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.pink.shade100,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              widget.commercials,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),

          SizedBox(height: 16.h),

          /// TABS
          TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                color: Colors.pink,
                width: 3, // thickness
              ),
            ),
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: "Details"),
              Tab(text: "Meditations"),
            ],
          ),

          /// TAB CONTENT
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                /// DETAILS TAB (SCROLLABLE)
                SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Html(
                    data: comboDetail?.description ?? "",
                    style: {
                      "body": Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                        fontSize: FontSize(16.sp),
                        lineHeight: LineHeight(1.6),
                        color: Colors.black,
                      ),
                      "p": Style(margin: Margins.only(bottom: 12)),
                      "strong": Style(fontWeight: FontWeight.w700),
                      "h1": Style(
                        fontSize: FontSize(20.sp),
                        fontWeight: FontWeight.bold,
                      ),
                      "h2": Style(
                        fontSize: FontSize(18.sp),
                        fontWeight: FontWeight.bold,
                      ),
                      "h3": Style(
                        fontSize: FontSize(17.sp),
                        fontWeight: FontWeight.bold,
                      ),
                    },
                  ),
                ),

                /// MEDITATIONS TAB
                ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  itemCount: isMeditationLoading ? 0 : meditations.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final item = meditations[index];

                    return ListTile(
                      title: Text(item.name, style: TextStyle(fontSize: 16.sp)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MeditationPlayerScreen(
                              title: item.name,
                              audioUrl:
                                  "https://makemyzen.com/make_my_zen/uploads/meditation/${item.audio}",
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
