class ApiConfig {
  static const String baseUrl = "https://makemyzen.com/make_my_zen/ws/";

  static String get sendOtpUrl => "${baseUrl}sendotp.php";
  static String get loginUrl => "${baseUrl}login.php";
  static String get getAgeGroupUrl => "${baseUrl}getAgeGroup.php";
  static String get getCountryUrl => "${baseUrl}getCountry.php";
  static String get getLanguageUrl => "${baseUrl}getLanguage.php";
  static String get userRegistrationUrl => "${baseUrl}userRegistration.php";
  static String get getBlessingsUrl => "${baseUrl}getblessings.php";
  static String get getVisualizationUrl => "${baseUrl}getVisulization.php";
  static String get getDesiredStateUrl => "${baseUrl}getDesiredState.php";
  static String get getMeditationTypeUrl => "${baseUrl}getMeditationType.php";
  static String get getFavoriteCombosUrl =>
      "${baseUrl}getComboHealingsFavourite.php";
  static String get getCommercialsUrl => "${baseUrl}getCommercials.php";

  static String get getCommercialDetailsUrl =>
      "${baseUrl}getCommercials_details.php";
  static String get getPersonalisedHealingUrl =>
      "${baseUrl}getPersonalisedHealing.php";
  static String get personalisedHealingDetailUrl =>
      "${baseUrl}getPersonalisedHealing_detail.php";
  static String get addComboFavourite =>
      "${baseUrl}addComboHealingsFavourite.php";

  static String get removeComboFavourite => "${baseUrl}combo_unfavourite.php";
  static String get getIssuesUrl => "${baseUrl}getIssues.php";
  static String get getHealingModalitiesUrl =>
      "${baseUrl}getHealingModalities.php";
  static String get getHealingModalitiesDetailUrl =>
      "${baseUrl}getHealingModalities_detail.php";

  static String get getComboHealingDetailUrl =>
      "${baseUrl}getComboHealings_detail.php";
  static String get getComboHealingMeditationsUrl =>
      "${baseUrl}getComboHealings_detail_meditation.php";
  static String get addPersonalisedHealingUrl =>
      "${baseUrl}addPersonalisedHealing.php";
}
