import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:make_my_zen/model/add_personalised_healing_response_model.dart';
import 'package:make_my_zen/model/age_group_model.dart';
import 'package:make_my_zen/model/blessing_model.dart';
import 'package:make_my_zen/model/commercial_detail_model.dart';
import 'package:make_my_zen/model/commercial_plan_model.dart';
import 'package:make_my_zen/model/country_model.dart';
import 'package:make_my_zen/model/desired_state_model.dart';
import 'package:make_my_zen/model/favorite_combo_model.dart';
import 'package:make_my_zen/model/favourite_response_model.dart';
import 'package:make_my_zen/model/healing_modality_detail_model.dart';
import 'package:make_my_zen/model/healing_modality_model.dart';
import 'package:make_my_zen/model/issue_model.dart';
import 'package:make_my_zen/model/language_model.dart';
import 'package:make_my_zen/model/login_response_model.dart';
import 'package:make_my_zen/model/meditation_combo_detail_model.dart';
import 'package:make_my_zen/model/meditation_combo_meditation_model.dart';
import 'package:make_my_zen/model/meditation_combo_model.dart';
import 'package:make_my_zen/model/meditation_type_model.dart';
import 'package:make_my_zen/model/personalised_healing_detail_model.dart';
import 'package:make_my_zen/model/personalised_healing_model.dart';
import 'package:make_my_zen/model/user_profile_model.dart';
import 'package:make_my_zen/model/visualization_model.dart';

import 'api_config.dart';

class ApiService {
  /// GENERIC POST
  static Future<Map<String, dynamic>> _postRequest(
    String url,
    Map<String, String> params,
  ) async {
    try {
      final response = await http.post(Uri.parse(url), body: params);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'status': 1, 'message': 'Server error'};
      }
    } catch (e) {
      return {'status': 1, 'message': 'Network error'};
    }
  }

  /// SEND OTP
  static Future<Map<String, dynamic>> sendOtp({required String email}) async {
    return await _postRequest(ApiConfig.sendOtpUrl, {'email': email});
  }

  /// LOGIN
  static Future<LoginResponseModel?> login({
    required String email,
    required String otp,
  }) async {
    final res = await _postRequest(ApiConfig.loginUrl, {
      'email': email,
      'otp_entered': otp,
    });

    if (res['status'] == 0 && res['data'] != null) {
      return LoginResponseModel.fromJson(res);
    }

    return null;
  }

  /// USER REGISTRATION
  static Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String gender,
    required String ageGroup,
    required String language,
    required String country,
  }) async {
    return await _postRequest(ApiConfig.userRegistrationUrl, {
      'name': name,
      'email': email,
      'gender': gender,
      'age_group': ageGroup,
      'language': language,
      'country': country,
    });
  }

  /// AGE GROUP
  static Future<List<AgeGroupModel>> getAgeGroups() async {
    final res = await _postRequest(ApiConfig.getAgeGroupUrl, {});

    if (res['status'] == 0 && res['data'] != null) {
      return (res['data'] as List)
          .map((e) => AgeGroupModel.fromJson(e))
          .toList();
    }
    return [];
  }

  /// COUNTRY
  static Future<List<CountryModel>> getCountries() async {
    final res = await _postRequest(ApiConfig.getCountryUrl, {});

    if (res['status'] == 0 && res['data'] != null) {
      return (res['data'] as List)
          .map((e) => CountryModel.fromJson(e))
          .toList();
    }
    return [];
  }

  /// LANGUAGE
  static Future<List<LanguageModel>> getLanguages() async {
    final res = await _postRequest(ApiConfig.getLanguageUrl, {});

    if (res['status'] == 0 && res['data'] != null) {
      return (res['data'] as List)
          .map((e) => LanguageModel.fromJson(e))
          .toList();
    }
    return [];
  }

  static Future<Map<String, dynamic>> getUserProfile({
    required String userSrNo,
  }) async {
    return await _postRequest("${ApiConfig.baseUrl}getuserprofile.php", {
      'usersrno': userSrNo,
    });
  }

  static Future<Map<String, dynamic>> updateUserProfile({
    required String userSrNo,
    required String name,
    required String email,
    required String gender,
    required String ageGroup,
    required String language,
    required String country,
  }) async {
    final response = await http.post(
      Uri.parse("https://makemyzen.com/make_my_zen/ws/updateuserprofile.php"),
      body: {
        "usersrno": userSrNo,
        "name": name,
        "email": email,
        "gender": gender,
        "age_group": ageGroup,
        "language": language,
        "country": country,
      },
    );

    return json.decode(response.body);
  }

  static Future<List<BlessingModel>> getBlessings() async {
    final res = await _postRequest(ApiConfig.getBlessingsUrl, {});

    if (res['status'] == 0 && res['data'] != null) {
      return (res['data'] as List)
          .map((e) => BlessingModel.fromJson(e))
          .toList();
    }

    return [];
  }

  static Future<List<VisualizationModel>> getVisualizations() async {
    final res = await _postRequest(ApiConfig.getVisualizationUrl, {});

    if (res['status'] == 0 && res['data'] != null) {
      return (res['data'] as List)
          .map((e) => VisualizationModel.fromJson(e))
          .toList();
    }

    return [];
  }

  /// DESIRED STATE
  static Future<List<DesiredStateModel>> getDesiredStates() async {
    final res = await _postRequest(ApiConfig.getDesiredStateUrl, {});

    if (res['status'] == 0 && res['data'] != null) {
      return (res['data'] as List)
          .map((e) => DesiredStateModel.fromJson(e))
          .toList();
    }

    return [];
  }

  /// MEDITATION TYPE
  static Future<List<MeditationTypeModel>> getMeditationTypes() async {
    final res = await _postRequest(ApiConfig.getMeditationTypeUrl, {});

    if (res['status'] == 0 && res['data'] != null) {
      return (res['data'] as List)
          .map((e) => MeditationTypeModel.fromJson(e))
          .toList();
    }

    return [];
  }

  /// FAVORITE COMBO HEALINGS
  static Future<List<FavoriteComboModel>> getFavoriteCombos({
    required String userSrNo,
  }) async {
    final res = await _postRequest(ApiConfig.getFavoriteCombosUrl, {
      'usersrno': userSrNo,
    });

    if (res['status'] == 0 && res['data'] != null) {
      return (res['data'] as List)
          .map((e) => FavoriteComboModel.fromJson(e))
          .toList();
    }

    return [];
  }

  /// GET COMMERCIAL PLANS
  static Future<List<CommercialPlanModel>> getCommercialPlans() async {
    final res = await _postRequest(ApiConfig.getCommercialsUrl, {});

    if (res['status'] == 0 && res['data'] != null) {
      return (res['data'] as List)
          .map((e) => CommercialPlanModel.fromJson(e))
          .toList();
    }
    return [];
  }

  /// GET COMMERCIAL DETAILS
  static Future<List<CommercialDetailModel>> getCommercialDetails({
    required String commercialSrNo,
  }) async {
    final res = await _postRequest(ApiConfig.getCommercialDetailsUrl, {
      'commercials_srno': commercialSrNo,
    });

    if (res['status'] == 0 && res['data'] != null) {
      return (res['data'] as List)
          .map((e) => CommercialDetailModel.fromJson(e))
          .toList();
    }
    return [];
  }

  /// GET PERSONALISED HEALING
  static Future<List<PersonalisedHealingModel>> getPersonalisedHealing({
    required String userSrNo,
  }) async {
    final res = await _postRequest(ApiConfig.getPersonalisedHealingUrl, {
      'usersrno': userSrNo,
    });

    if (res['status'] == 0 && res['data'] != null) {
      return (res['data'] as List)
          .map((e) => PersonalisedHealingModel.fromJson(e))
          .toList();
    }
    return [];
  }

  /// PERSONALISED HEALING DETAIL
  static Future<List<PersonalisedHealingDetailModel>>
  getPersonalisedHealingDetail({required String orderSrNo}) async {
    final res = await _postRequest(ApiConfig.personalisedHealingDetailUrl, {
      'ordersrno': orderSrNo,
    });

    if (res['status'] == 0 && res['data'] != null) {
      return (res['data'] as List)
          .map((e) => PersonalisedHealingDetailModel.fromJson(e))
          .toList();
    }

    return [];
  }

  /// ADD TO FAVOURITE
  static Future<FavouriteResponseModel?> addComboFavourite({
    required String userSrNo,
    required String meditationComboSrNo,
  }) async {
    final res = await _postRequest(ApiConfig.addComboFavourite, {
      'usersrno': userSrNo,
      'meditation_combo_srno': meditationComboSrNo,
    });

    if (res['status'] != null) {
      return FavouriteResponseModel.fromJson(res);
    }
    return null;
  }

  /// REMOVE FROM FAVOURITE
  static Future<FavouriteResponseModel?> removeComboFavourite({
    required String userSrNo,
    required String meditationComboSrNo,
  }) async {
    final res = await _postRequest(ApiConfig.removeComboFavourite, {
      'usersrno': userSrNo,
      'meditation_combo_srno': meditationComboSrNo,
    });

    if (res['status'] != null) {
      return FavouriteResponseModel.fromJson(res);
    }
    return null;
  }

  /// ISSUES
  static Future<List<IssueModel>> getIssues() async {
    final res = await _postRequest(ApiConfig.getIssuesUrl, {});

    if (res['status'] == 0 && res['data'] != null) {
      return (res['data'] as List).map((e) => IssueModel.fromJson(e)).toList();
    }
    return [];
  }

  /// HEALING MODALITIES
  static Future<List<HealingModalityModel>> getHealingModalities() async {
    final res = await _postRequest(ApiConfig.getHealingModalitiesUrl, {});

    if (res['status'] == 0 && res['data'] != null) {
      return (res['data'] as List)
          .map((e) => HealingModalityModel.fromJson(e))
          .toList();
    }
    return [];
  }

  /// HEALING MODALITY DETAIL
  static Future<HealingModalityDetailModel?> getHealingModalityDetail(
    String srNo,
  ) async {
    final response = await http.post(
      Uri.parse(
        "https://makemyzen.com/make_my_zen/ws/getHealingModalities_detail.php",
      ),
      body: {"healing_modalities_srno": srNo},
    );

    final data = jsonDecode(response.body);

    if (data['status'] == 0 && data['data_count'] > 0) {
      return HealingModalityDetailModel.fromJson(data['data'][0]);
    }
    return null;
  }

  static Future<List<MeditationComboModel>> getComboHealings(
    String userSrNo,
  ) async {
    final response = await http.post(
      Uri.parse(
        "https://makemyzen.com/make_my_zen/ws/getComboHealingsAkanksha.php",
      ),
      body: {"usersrno": userSrNo},
    );

    final data = jsonDecode(response.body);

    if (data['status'] == 0) {
      return (data['data'] as List)
          .map((e) => MeditationComboModel.fromJson(e))
          .toList();
    }
    return [];
  }

  static Future<MeditationComboDetailModel?> getComboHealingDetail({
    required String userSrNo,
    required String meditationComboSrNo,
  }) async {
    final res = await _postRequest(ApiConfig.getComboHealingDetailUrl, {
      "usersrno": userSrNo,
      "meditation_combo_srno": meditationComboSrNo,
    });

    if (res['status'] == 0 &&
        res['data'] != null &&
        res['data'] is List &&
        res['data'].isNotEmpty) {
      return MeditationComboDetailModel.fromJson(res['data'][0]);
    }

    return null;
  }

  static Future<List<MeditationComboMeditationModel>>
  getComboHealingMeditations({
    required String userSrNo,
    required String meditationComboSrNo,
  }) async {
    final res = await _postRequest(ApiConfig.getComboHealingMeditationsUrl, {
      "usersrno": userSrNo,
      "meditation_combo_srno": meditationComboSrNo,
    });

    if (res['status'] == 0 && res['data'] != null) {
      return (res['data'] as List)
          .map((e) => MeditationComboMeditationModel.fromJson(e))
          .toList();
    }

    return [];
  }

  /// ADD PERSONALISED HEALING (FINAL ORDER)
  static Future<AddPersonalisedHealingResponseModel?> addPersonalisedHealing({
    required String userSrNo,
    required String name,
    required String meditationTypeSrNo,
    required String issueSrNo,
    required String desiredStateSrNo,
    required String voice,
    required String visualizationSrNo,
  }) async {
    final res = await _postRequest(ApiConfig.addPersonalisedHealingUrl, {
      "usersrno": userSrNo,
      "name": name,
      "meditation_type_srno": meditationTypeSrNo,
      "issue_srno": issueSrNo,
      "desired_state_srno": desiredStateSrNo,
      "voice": voice,
      "visulization_srno": visualizationSrNo,
    });

    if (res['status'] != null) {
      return AddPersonalisedHealingResponseModel.fromJson(res);
    }
    return null;
  }
}
