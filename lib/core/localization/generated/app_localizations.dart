import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'Talia'**
  String get appName;

  /// Home tab label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Quran tab label
  ///
  /// In en, this message translates to:
  /// **'Quran'**
  String get quran;

  /// Memorization tab label
  ///
  /// In en, this message translates to:
  /// **'Memorization'**
  String get memorization;

  /// Progress tab label
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// Settings tab label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Register button text
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Logout button text
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Guest mode button text
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Cancel action
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Save action
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Retry action
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// OK action
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Error title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Success title
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Loading indicator text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Offline message
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// Dark mode toggle label
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Arabic language name
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// English language name
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Azkar section label
  ///
  /// In en, this message translates to:
  /// **'Azkar'**
  String get azkar;

  /// Digital rosary section label
  ///
  /// In en, this message translates to:
  /// **'Digital Rosary'**
  String get digitalRosary;

  /// Review section label
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// Parent dashboard label
  ///
  /// In en, this message translates to:
  /// **'Parent Dashboard'**
  String get parentDashboard;

  /// Kids journey label
  ///
  /// In en, this message translates to:
  /// **'Kids Journey'**
  String get kidsJourney;

  /// Adult journey label
  ///
  /// In en, this message translates to:
  /// **'Adult Journey'**
  String get adultJourney;

  /// Login page greeting
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// Register page title
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// Forgot password link text
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Reset password dialog title
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// Forgot password description
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a link to reset your password.'**
  String get enterEmailToReset;

  /// Send password reset button
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// Reset password success message
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent to your email'**
  String get resetPasswordSent;

  /// Email validation error
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// Email format validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get invalidEmail;

  /// Password validation error
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// Password length validation error
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// Confirm password validation error
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Login success message
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get loginSuccess;

  /// Registration success message
  ///
  /// In en, this message translates to:
  /// **'Account created successfully'**
  String get registerSuccess;

  /// Logout success message
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully'**
  String get logoutSuccess;

  /// Divider text between login and guest
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get orContinueWith;

  /// Link to login page from register
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// Link to register page from login
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// Onboarding final button
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// Skip onboarding button
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Next onboarding slide button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Display name field label
  ///
  /// In en, this message translates to:
  /// **'Display Name (Optional)'**
  String get displayName;

  /// Onboarding slide 1 title
  ///
  /// In en, this message translates to:
  /// **'Read the Holy Quran'**
  String get onboardingTitle1;

  /// Onboarding slide 1 description
  ///
  /// In en, this message translates to:
  /// **'Access the complete Quran with beautiful Uthmani script and audio recitation anytime, anywhere.'**
  String get onboardingDesc1;

  /// Onboarding slide 2 title
  ///
  /// In en, this message translates to:
  /// **'Memorize with Guidance'**
  String get onboardingTitle2;

  /// Onboarding slide 2 description
  ///
  /// In en, this message translates to:
  /// **'A structured memorization journey with smart coaching, spaced repetition, and step-by-step learning.'**
  String get onboardingDesc2;

  /// Onboarding slide 3 title
  ///
  /// In en, this message translates to:
  /// **'Track Your Progress'**
  String get onboardingTitle3;

  /// Onboarding slide 3 description
  ///
  /// In en, this message translates to:
  /// **'Monitor your memorization, reviews, streaks, and achievements with beautiful statistics.'**
  String get onboardingDesc3;

  /// Surah list page title
  ///
  /// In en, this message translates to:
  /// **'Surah List'**
  String get surahList;

  /// Quran section title
  ///
  /// In en, this message translates to:
  /// **'The Holy Quran'**
  String get theHolyQuran;

  /// Continue reading button
  ///
  /// In en, this message translates to:
  /// **'Continue Reading'**
  String get continueReading;

  /// First time reading prompt
  ///
  /// In en, this message translates to:
  /// **'Start Reading Quran'**
  String get startReading;

  /// Search page placeholder
  ///
  /// In en, this message translates to:
  /// **'Search the Holy Quran'**
  String get searchQuran;

  /// Empty search results
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// Empty bookmarks message
  ///
  /// In en, this message translates to:
  /// **'No bookmarks yet'**
  String get noBookmarks;

  /// Bookmarks page title
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookmarksTitle;

  /// Mushaf reading mode
  ///
  /// In en, this message translates to:
  /// **'Mushaf Mode'**
  String get mushafMode;

  /// Surah reading mode
  ///
  /// In en, this message translates to:
  /// **'Surah Mode'**
  String get surahMode;

  /// Tajweed enabled
  ///
  /// In en, this message translates to:
  /// **'Tajweed On'**
  String get tajweedOn;

  /// Tajweed disabled
  ///
  /// In en, this message translates to:
  /// **'Tajweed Off'**
  String get tajweedOff;

  /// Ayah label
  ///
  /// In en, this message translates to:
  /// **'Ayah'**
  String get ayah;

  /// Page label
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get page;

  /// Juz label
  ///
  /// In en, this message translates to:
  /// **'Juz'**
  String get juz;

  /// Makki revelation label
  ///
  /// In en, this message translates to:
  /// **'Makki'**
  String get makkiSurah;

  /// Madani revelation label
  ///
  /// In en, this message translates to:
  /// **'Madani'**
  String get madaniSurah;

  /// Verses label
  ///
  /// In en, this message translates to:
  /// **'verses'**
  String get verses;

  /// Morning greeting
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// Afternoon greeting
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoon;

  /// Evening greeting
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// Font loading progress message
  ///
  /// In en, this message translates to:
  /// **'Loading Quran fonts...'**
  String get loadingFonts;

  /// Add bookmark action
  ///
  /// In en, this message translates to:
  /// **'Add Bookmark'**
  String get addBookmark;

  /// Remove bookmark action
  ///
  /// In en, this message translates to:
  /// **'Remove Bookmark'**
  String get removeBookmark;

  /// Bookmark added success
  ///
  /// In en, this message translates to:
  /// **'Bookmark saved'**
  String get bookmarkAdded;

  /// Bookmark removed success
  ///
  /// In en, this message translates to:
  /// **'Bookmark removed'**
  String get bookmarkRemoved;

  /// Start memorizing action
  ///
  /// In en, this message translates to:
  /// **'Start Memorizing'**
  String get startMemorizing;

  /// Continue session action
  ///
  /// In en, this message translates to:
  /// **'Continue Session'**
  String get continueSession;

  /// Weak ayahs label
  ///
  /// In en, this message translates to:
  /// **'Weak Ayahs'**
  String get weakAyahs;

  /// Due reviews label
  ///
  /// In en, this message translates to:
  /// **'Due Reviews'**
  String get dueReviews;

  /// Daily memorization label
  ///
  /// In en, this message translates to:
  /// **'Daily Memorization'**
  String get dailyMemorization;

  /// Quran reading label
  ///
  /// In en, this message translates to:
  /// **'Quran Reading'**
  String get quranReading;

  /// Session title
  ///
  /// In en, this message translates to:
  /// **'Memorization Session'**
  String get memorizationSession;

  /// Start session action
  ///
  /// In en, this message translates to:
  /// **'Start Session'**
  String get startSession;

  /// Select surah label
  ///
  /// In en, this message translates to:
  /// **'Select Surah'**
  String get selectSurah;

  /// Start ayah label
  ///
  /// In en, this message translates to:
  /// **'Start Ayah'**
  String get startAyah;

  /// End ayah label
  ///
  /// In en, this message translates to:
  /// **'End Ayah'**
  String get endAyah;

  /// Session setup validation message
  ///
  /// In en, this message translates to:
  /// **'Choose a valid ayah range for this surah.'**
  String get invalidAyahRange;

  /// Learning stage label
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get stageLearning;

  /// Memorizing stage label
  ///
  /// In en, this message translates to:
  /// **'Memorizing'**
  String get stageMemorizing;

  /// Reciting stage label
  ///
  /// In en, this message translates to:
  /// **'Reciting'**
  String get stageReciting;

  /// Remediation stage label
  ///
  /// In en, this message translates to:
  /// **'Remediation'**
  String get stageRemediation;

  /// Block review stage label
  ///
  /// In en, this message translates to:
  /// **'Block Review'**
  String get stageBlockReview;

  /// Completed stage label
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get stageCompleted;

  /// Learned confirmation action
  ///
  /// In en, this message translates to:
  /// **'I\'ve learned this'**
  String get iveLearnedThis;

  /// Ready to recite action
  ///
  /// In en, this message translates to:
  /// **'Ready to recite'**
  String get readyToRecite;

  /// Show hint action
  ///
  /// In en, this message translates to:
  /// **'Show Hint'**
  String get showHint;

  /// Hide hint action
  ///
  /// In en, this message translates to:
  /// **'Hide Hint'**
  String get hideHint;

  /// Start recording action
  ///
  /// In en, this message translates to:
  /// **'Start Recording'**
  String get startRecording;

  /// Recited correctly action
  ///
  /// In en, this message translates to:
  /// **'I recited correctly'**
  String get iRecitedCorrectly;

  /// No description provided for @kidsWorldMap.
  ///
  /// In en, this message translates to:
  /// **'World Map'**
  String get kidsWorldMap;

  /// No description provided for @kidsMissions.
  ///
  /// In en, this message translates to:
  /// **'Missions'**
  String get kidsMissions;

  /// No description provided for @kidsStartMission.
  ///
  /// In en, this message translates to:
  /// **'Start Mission'**
  String get kidsStartMission;

  /// No description provided for @kidsLevel.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String kidsLevel(int level);

  /// No description provided for @kidsZone.
  ///
  /// In en, this message translates to:
  /// **'Zone {juz}'**
  String kidsZone(int juz);

  /// No description provided for @kidsIknowIt.
  ///
  /// In en, this message translates to:
  /// **'I know it!'**
  String get kidsIknowIt;

  /// No description provided for @kidsHelpMe.
  ///
  /// In en, this message translates to:
  /// **'Help me!'**
  String get kidsHelpMe;

  /// No description provided for @kidsGreatJob.
  ///
  /// In en, this message translates to:
  /// **'Great Job!'**
  String get kidsGreatJob;

  /// No description provided for @kidsRewardUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Reward Unlocked!'**
  String get kidsRewardUnlocked;

  /// No description provided for @kidsBackToMap.
  ///
  /// In en, this message translates to:
  /// **'Back to Map'**
  String get kidsBackToMap;

  /// Need help action
  ///
  /// In en, this message translates to:
  /// **'I need help'**
  String get iNeedHelp;

  /// Forgot review quality
  ///
  /// In en, this message translates to:
  /// **'Forgot'**
  String get reviewQualityForgot;

  /// Hard review quality
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get reviewQualityHard;

  /// Good review quality
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get reviewQualityGood;

  /// Easy review quality
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get reviewQualityEasy;

  /// XP earned label
  ///
  /// In en, this message translates to:
  /// **'XP Earned'**
  String get xpEarned;

  /// Session complete title
  ///
  /// In en, this message translates to:
  /// **'Session Complete'**
  String get sessionComplete;

  /// Back to home action
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// Ayahs memorized label
  ///
  /// In en, this message translates to:
  /// **'Ayahs Memorized'**
  String get ayahsMemorized;

  /// New badges unlocked label
  ///
  /// In en, this message translates to:
  /// **'New Badges Unlocked'**
  String get newBadges;

  /// Smart coach label
  ///
  /// In en, this message translates to:
  /// **'Smart Coach'**
  String get smartCoach;

  /// Practice action
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get practice;

  /// Level label
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// Streak label
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get streak;

  /// Days label
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @progressDashboard.
  ///
  /// In en, this message translates to:
  /// **'Progress Dashboard'**
  String get progressDashboard;

  /// No description provided for @totalMemorized.
  ///
  /// In en, this message translates to:
  /// **'Total Memorized'**
  String get totalMemorized;

  /// No description provided for @weeklyActivity.
  ///
  /// In en, this message translates to:
  /// **'Weekly Activity'**
  String get weeklyActivity;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @certificates.
  ///
  /// In en, this message translates to:
  /// **'Certificates'**
  String get certificates;

  /// No description provided for @badgeUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get badgeUnlocked;

  /// No description provided for @badgeLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get badgeLocked;

  /// No description provided for @longestStreak.
  ///
  /// In en, this message translates to:
  /// **'Longest Streak'**
  String get longestStreak;

  /// No description provided for @completionRate.
  ///
  /// In en, this message translates to:
  /// **'Completion Rate'**
  String get completionRate;

  /// No description provided for @xpToNextLevel.
  ///
  /// In en, this message translates to:
  /// **'XP to next level'**
  String get xpToNextLevel;

  /// No description provided for @activityHeatmap.
  ///
  /// In en, this message translates to:
  /// **'Activity Heatmap'**
  String get activityHeatmap;

  /// No description provided for @noActivity.
  ///
  /// In en, this message translates to:
  /// **'No activity yet'**
  String get noActivity;

  /// No description provided for @allBadges.
  ///
  /// In en, this message translates to:
  /// **'All Badges'**
  String get allBadges;

  /// No description provided for @certificate.
  ///
  /// In en, this message translates to:
  /// **'Certificate'**
  String get certificate;

  /// No description provided for @viewCertificate.
  ///
  /// In en, this message translates to:
  /// **'View Certificate'**
  String get viewCertificate;

  /// No description provided for @allGood.
  ///
  /// In en, this message translates to:
  /// **'All good!'**
  String get allGood;

  /// No description provided for @needsReview.
  ///
  /// In en, this message translates to:
  /// **'Needs review'**
  String get needsReview;

  /// No description provided for @totalReviews.
  ///
  /// In en, this message translates to:
  /// **'Total Reviews'**
  String get totalReviews;

  /// No description provided for @bookmarks.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookmarks;

  /// No description provided for @kids.
  ///
  /// In en, this message translates to:
  /// **'Kids'**
  String get kids;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
