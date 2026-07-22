/// XP award constants. Pure values, no logic.
class XpConfig {
  XpConfig._();

  static const int memorizeAyah = 10;
  static const int reviewAyah = 5;
  static const int perfectRecitation = 15;
  static const int streakBonus = 3;
  static const int hintPenaltyLevel1 = -2;
  static const int hintPenaltyLevel2 = -5;
  static const int blockReviewBonus = 20;

  /// XP required for a given level.
  static int xpForLevel(int level) => level * 100;

  /// Calculate level from total XP.
  static int levelFromXp(int xp) {
    if (xp <= 0) return 1;
    return (xp ~/ 100) + 1;
  }

  /// Calculate XP for an ayah based on hint usage.
  static int ayahXp(int hintLevel) {
    int xp = memorizeAyah;
    if (hintLevel == 1) xp += hintPenaltyLevel1;
    if (hintLevel == 2) xp += hintPenaltyLevel2;
    return xp.clamp(0, memorizeAyah + perfectRecitation);
  }
}
