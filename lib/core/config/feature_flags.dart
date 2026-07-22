class FeatureFlags {
  FeatureFlags._();

  /// Enables the kids journey feature and related UI elements
  static const bool enableKidsJourney = false;

  /// Enables the parent dashboard for tracking kids' progress
  static const bool enableParentDashboard = false;

  /// Enables the Azkar (supplications) feature
  static const bool enableAzkar = true;

  /// Enables the Digital Rosary (Tasbeeh) feature
  static const bool enableDigitalRosary = true;

  /// Enables cloud sync for user data (bookmarks, progress, etc.)
  static const bool enableCloudSync = false;

  /// Enables audio playback for Quran recitations
  static const bool enableAudioPlayback = true;
}
