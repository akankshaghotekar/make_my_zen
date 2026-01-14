import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:make_my_zen/api/api_service.dart';
import 'package:make_my_zen/model/age_group_model.dart';
import 'package:make_my_zen/model/country_model.dart';
import 'package:make_my_zen/model/language_model.dart';
import 'package:make_my_zen/utils/animation_helper/animated_page_route.dart';
import 'package:make_my_zen/utils/animation_helper/loading_screen.dart';
import 'package:make_my_zen/utils/app_colors.dart';
import 'package:make_my_zen/utils/common/common_bottom_nav.dart';
import 'package:make_my_zen/utils/common/common_drawer.dart';
import 'package:make_my_zen/utils/common/common_gradient_button.dart';

class RegisterDetailsScreen extends StatefulWidget {
  final String email;
  final bool isEditProfile;
  final String? userSrNo;
  const RegisterDetailsScreen({
    super.key,
    required this.email,
    required this.isEditProfile,
    this.userSrNo,
  });

  @override
  State<RegisterDetailsScreen> createState() => _RegisterDetailsScreenState();
}

class _RegisterDetailsScreenState extends State<RegisterDetailsScreen> {
  String? gender;
  AgeGroupModel? ageGroup;
  CountryModel? country;
  LanguageModel? language;
  final TextEditingController _nameController = TextEditingController();
  bool isSubmitting = false;

  final List<String> genders = ['Male', 'Female', 'Other'];

  List<AgeGroupModel> ageGroups = [];
  List<CountryModel> countries = [];
  List<LanguageModel> languages = [];

  @override
  void initState() {
    super.initState();
    _loadDropdownData();
  }

  Future<void> _loadDropdownData() async {
    final ageRes = await ApiService.getAgeGroups();
    final countryRes = await ApiService.getCountries();
    final langRes = await ApiService.getLanguages();

    setState(() {
      ageGroups = ageRes;
      countries = countryRes;
      languages = langRes;
    });

    if (widget.isEditProfile && widget.userSrNo != null) {
      await _loadUserProfile();
    }

    setState(() => isLoading = false);
  }

  Future<void> _loadUserProfile() async {
    final res = await ApiService.getUserProfile(userSrNo: widget.userSrNo!);

    if (res['status'] != 0) return;

    final data = res['data'][0];

    setState(() {
      _nameController.text = data['name'] ?? '';
      gender = data['gender'];

      if (ageGroups.isNotEmpty) {
        ageGroup = ageGroups.firstWhere(
          (e) => e.srNo == data['age_group'],
          orElse: () => ageGroups.first,
        );
      }

      if (languages.isNotEmpty) {
        language = languages.firstWhere(
          (e) => e.srNo == data['language'],
          orElse: () => languages.first,
        );
      }

      if (countries.isNotEmpty) {
        country = countries.firstWhere(
          (e) => e.srNo == data['country'],
          orElse: () => countries.first,
        );
      }
    });
  }

  bool isLoading = true;

  Future<void> _submitRegistration() async {
    if (_nameController.text.trim().isEmpty ||
        gender == null ||
        ageGroup == null ||
        country == null ||
        language == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    setState(() => isSubmitting = true);

    /// CALL REGISTRATION API
    final regRes = await ApiService.registerUser(
      name: _nameController.text.trim(),
      email: widget.email,
      gender: gender!,
      ageGroup: ageGroup!.srNo,
      language: language!.srNo,
      country: country!.srNo,
    );

    if (regRes['status'] != 0) {
      setState(() => isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(regRes['message'] ?? 'Registration failed')),
      );
      return;
    }

    /// CALL SEND OTP API
    final otpRes = await ApiService.sendOtp(email: widget.email);

    setState(() => isSubmitting = false);

    if (otpRes['status'] == 0) {
      Navigator.pushReplacement(
        context,
        AnimatedPageRoute(page: LoadingScreen(email: widget.email)),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to send OTP")));
    }
  }

  Future<void> _updateProfile() async {
    if (_nameController.text.trim().isEmpty ||
        gender == null ||
        ageGroup == null ||
        country == null ||
        language == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    setState(() => isSubmitting = true);

    final res = await ApiService.updateUserProfile(
      userSrNo: widget.userSrNo!,
      name: _nameController.text.trim(),
      email: widget.email,
      gender: gender!,
      ageGroup: ageGroup!.srNo,
      language: language!.srNo,
      country: country!.srNo,
    );

    setState(() => isSubmitting = false);

    if (res['status'] == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['message'] ?? "Update failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,

      appBar: widget.isEditProfile
          ? PreferredSize(
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
            )
          : null,

      drawer: widget.isEditProfile
          ? CommonDrawer(onClose: () => Navigator.pop(context))
          : null,

      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    SizedBox(height: 100.h),

                    /// NAME FIELD
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        filled: true,
                        fillColor: AppColor.lightGrey,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 18.h,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    SizedBox(height: 18.h),

                    _dropdownField(
                      hint: "Select Gender",
                      value: gender,
                      items: genders,
                      onChanged: (val) => setState(() => gender = val),
                    ),

                    SizedBox(height: 14.h),

                    _dropdownField(
                      hint: "Select Age Group",
                      value: ageGroup?.ageGroup,
                      items: ageGroups.map((e) => e.ageGroup).toList(),
                      onChanged: (val) {
                        setState(() {
                          ageGroup = ageGroups.firstWhere(
                            (e) => e.ageGroup == val,
                          );
                        });
                      },
                    ),

                    SizedBox(height: 14.h),

                    _dropdownField(
                      hint: "Select Country",
                      value: country?.country,
                      items: countries.map((e) => e.country).toList(),
                      onChanged: (val) {
                        setState(() {
                          country = countries.firstWhere(
                            (e) => e.country == val,
                          );
                        });
                      },
                    ),

                    SizedBox(height: 14.h),

                    _dropdownField(
                      hint: "Select Language",
                      value: language?.language,
                      items: languages.map((e) => e.language).toList(),
                      onChanged: (val) {
                        setState(() {
                          language = languages.firstWhere(
                            (e) => e.language == val,
                          );
                        });
                      },
                    ),

                    SizedBox(height: 30.h),

                    /// SUBMIT BUTTON
                    CommonGradientButton(
                      title: isSubmitting
                          ? "Please wait..."
                          : widget.isEditProfile
                          ? "Update"
                          : "Submit",
                      onTap: isSubmitting
                          ? null
                          : widget.isEditProfile
                          ? _updateProfile
                          : _submitRegistration,
                    ),

                    SizedBox(height: 30.h),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: widget.isEditProfile
          ? const CommonBottomNav(currentIndex: 2)
          : null,
    );
  }

  Widget _dropdownField({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      dropdownColor: Colors.white,
      icon: const Icon(Icons.keyboard_arrow_down),
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
      items: items.map((e) {
        return DropdownMenuItem<String>(
          value: e,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Text(
              e,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
