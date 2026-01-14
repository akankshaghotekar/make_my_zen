import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:make_my_zen/utils/app_colors.dart';
import 'package:make_my_zen/utils/common/common_drawer.dart';
import 'package:make_my_zen/utils/common/common_gradient_button.dart';

class ReachUsScreen extends StatefulWidget {
  const ReachUsScreen({super.key});

  @override
  State<ReachUsScreen> createState() => _ReachUsScreenState();
}

class _ReachUsScreenState extends State<ReachUsScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      drawer: CommonDrawer(onClose: () => Navigator.pop(context)),

      /// APP BAR WITH SHADOW (same as Home/About Us)
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
            title: Text(
              "Reach us",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            centerTitle: false,
          ),
        ),
      ),

      /// BODY
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20.h),

            /// MESSAGE BOX
            Container(
              height: 140.h,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColor.lightGrey,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: TextField(
                controller: _messageController,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: "Type your message here",
                  hintStyle: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.grey.shade600,
                  ),
                  border: InputBorder.none,
                ),
                style: TextStyle(fontSize: 15.sp),
              ),
            ),

            SizedBox(height: 24.h),

            /// SEND BUTTON (Gradient – same as app)
            CommonGradientButton(
              title: "Send Message",
              onTap: () {
                if (_messageController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter a message")),
                  );
                  return;
                }

                // TODO: API call later
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Message sent successfully")),
                );

                _messageController.clear();
              },
            ),
          ],
        ),
      ),
    );
  }
}
