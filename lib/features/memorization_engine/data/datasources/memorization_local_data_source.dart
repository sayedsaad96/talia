import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:talia/core/error/exceptions.dart';
import 'package:talia/features/memorization_engine/data/models/memorization_record_model.dart';
import 'package:talia/features/memorization_engine/data/models/review_result_model.dart';
import 'package:talia/features/memorization_engine/data/models/review_schedule_model.dart';
import 'package:talia/features/memorization_engine/data/models/session_model.dart';
import 'package:talia/features/memorization_engine/data/models/streak_model.dart';
import 'package:talia/features/memorization_engine/domain/entities/badge_entity.dart';

abstract class MemorizationLocalDataSource {
  Future<void> saveSession(SessionModel session);
  Future<SessionModel?> getActiveSession(String userId);
  Future<List<SessionModel>> getCompletedSessions(String userId);
  Future<void> saveRecord(MemorizationRecordModel record);
  Future<List<MemorizationRecordModel>> getRecords(String userId);
  Future<MemorizationRecordModel?> getRecord(
      String userId, int surah, int ayah);
  Future<void> updateRecord(MemorizationRecordModel record);
  Future<void> saveSchedule(ReviewScheduleModel schedule);
  Future<List<ReviewScheduleModel>> getSchedules(String userId);
  Future<void> updateSchedule(ReviewScheduleModel schedule);
  Future<void> saveResult(ReviewResultModel result);
  Future<StreakModel> getStreak(String userId);
  Future<void> saveStreak(String userId, StreakModel streak);
  Future<List<BadgeEntity>> getBadges(String userId);
  Future<void> saveBadge(String userId, BadgeEntity badge);
}

class MemorizationLocalDataSourceImpl implements MemorizationLocalDataSource {
  String _sessionsKey(String userId) => 'mem_sessions_$userId';
  String _recordsKey(String userId) => 'mem_records_$userId';
  String _schedulesKey(String userId) => 'mem_schedules_$userId';
  String _resultsKey(String userId) => 'mem_results_$userId';
  String _streakKey(String userId) => 'mem_streak_$userId';
  String _badgesKey(String userId) => 'mem_badges_$userId';

  // ── Sessions ──────────────────────────────────────────────

  @override
  Future<void> saveSession(SessionModel session) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessions = await _getAllSessions(session.userId);
      sessions.removeWhere((s) => s.id == session.id);
      sessions.add(session);
      await prefs.setStringList(
        _sessionsKey(session.userId),
        sessions.map((s) => jsonEncode(s.toJson())).toList(),
      );
    } catch (e) {
      throw CacheException(message: 'Failed to save session: $e');
    }
  }

  @override
  Future<SessionModel?> getActiveSession(String userId) async {
    final sessions = await _getAllSessions(userId);
    try {
      return sessions.firstWhere((s) => s.isActive);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<SessionModel>> getCompletedSessions(String userId) async {
    final sessions = await _getAllSessions(userId);
    return sessions.where((s) => s.isCompleted).toList();
  }

  Future<List<SessionModel>> _getAllSessions(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = prefs.getStringList(_sessionsKey(userId)) ?? [];
      return encoded
          .map((e) =>
              SessionModel.fromJson(jsonDecode(e) as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException(message: 'Failed to load sessions: $e');
    }
  }

  // ── Memorization Records ──────────────────────────────────

  @override
  Future<void> saveRecord(MemorizationRecordModel record) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final records = await _getAllRecords(record.userId);
      records.removeWhere((r) => r.id == record.id);
      records.add(record);
      await prefs.setStringList(
        _recordsKey(record.userId),
        records.map((r) => jsonEncode(r.toJson())).toList(),
      );
    } catch (e) {
      throw CacheException(message: 'Failed to save record: $e');
    }
  }

  @override
  Future<List<MemorizationRecordModel>> getRecords(String userId) async {
    return _getAllRecords(userId);
  }

  @override
  Future<MemorizationRecordModel?> getRecord(
      String userId, int surah, int ayah) async {
    final records = await _getAllRecords(userId);
    try {
      return records.firstWhere(
          (r) => r.surahNumber == surah && r.ayahNumber == ayah);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> updateRecord(MemorizationRecordModel record) async {
    await saveRecord(record);
  }

  Future<List<MemorizationRecordModel>> _getAllRecords(
      String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = prefs.getStringList(_recordsKey(userId)) ?? [];
      return encoded
          .map((e) => MemorizationRecordModel.fromJson(
              jsonDecode(e) as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException(message: 'Failed to load records: $e');
    }
  }

  // ── Review Schedules ──────────────────────────────────────

  @override
  Future<void> saveSchedule(ReviewScheduleModel schedule) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final schedules = await _getAllSchedules(schedule.userId);
      schedules.removeWhere((s) => s.id == schedule.id);
      schedules.add(schedule);
      await prefs.setStringList(
        _schedulesKey(schedule.userId),
        schedules.map((s) => jsonEncode(s.toJson())).toList(),
      );
    } catch (e) {
      throw CacheException(message: 'Failed to save schedule: $e');
    }
  }

  @override
  Future<List<ReviewScheduleModel>> getSchedules(String userId) async {
    return _getAllSchedules(userId);
  }

  @override
  Future<void> updateSchedule(ReviewScheduleModel schedule) async {
    await saveSchedule(schedule);
  }

  Future<List<ReviewScheduleModel>> _getAllSchedules(
      String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = prefs.getStringList(_schedulesKey(userId)) ?? [];
      return encoded
          .map((e) => ReviewScheduleModel.fromJson(
              jsonDecode(e) as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException(message: 'Failed to load schedules: $e');
    }
  }

  // ── Review Results ────────────────────────────────────────

  @override
  Future<void> saveResult(ReviewResultModel result) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existing = prefs.getStringList(_resultsKey(result.userId)) ?? [];
      existing.add(jsonEncode(result.toJson()));
      await prefs.setStringList(_resultsKey(result.userId), existing);
    } catch (e) {
      throw CacheException(message: 'Failed to save review result: $e');
    }
  }

  // ── Streak ────────────────────────────────────────────────

  @override
  Future<StreakModel> getStreak(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = prefs.getString(_streakKey(userId));
      if (encoded == null) return const StreakModel();
      return StreakModel.fromJson(
          jsonDecode(encoded) as Map<String, dynamic>);
    } catch (e) {
      throw CacheException(message: 'Failed to load streak: $e');
    }
  }

  @override
  Future<void> saveStreak(String userId, StreakModel streak) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_streakKey(userId), jsonEncode(streak.toJson()));
    } catch (e) {
      throw CacheException(message: 'Failed to save streak: $e');
    }
  }

  // ── Badges ────────────────────────────────────────────────

  @override
  Future<List<BadgeEntity>> getBadges(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = prefs.getStringList(_badgesKey(userId));
      if (encoded == null || encoded.isEmpty) {
        return BadgeType.values
            .map((type) => BadgeEntity(
                  type: type,
                  name: _badgeName(type),
                  description: _badgeDescription(type),
                ))
            .toList();
      }
      return encoded.map((e) {
        final json = jsonDecode(e) as Map<String, dynamic>;
        final type = BadgeType.values.firstWhere(
          (t) => t.name == (json['type'] as String),
          orElse: () => BadgeType.firstBlock,
        );
        return BadgeEntity(
          type: type,
          name: json['name'] as String,
          description: json['description'] as String,
          isUnlocked: (json['is_unlocked'] as bool?) ?? false,
          unlockedAt: json['unlocked_at'] != null
              ? DateTime.parse(json['unlocked_at'] as String)
              : null,
        );
      }).toList();
    } catch (e) {
      throw CacheException(message: 'Failed to load badges: $e');
    }
  }

  @override
  Future<void> saveBadge(String userId, BadgeEntity badge) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final badges = await getBadges(userId);
      final updatedBadges =
          badges.map((b) => b.type == badge.type ? badge : b).toList();
      final encoded = updatedBadges
          .map((b) => jsonEncode({
                'type': b.type.name,
                'name': b.name,
                'description': b.description,
                'is_unlocked': b.isUnlocked,
                'unlocked_at': b.unlockedAt?.toIso8601String(),
              }))
          .toList();
      await prefs.setStringList(_badgesKey(userId), encoded);
    } catch (e) {
      throw CacheException(message: 'Failed to save badge: $e');
    }
  }

  // ── Helpers ───────────────────────────────────────────────

  String _badgeName(BadgeType type) {
    switch (type) {
      case BadgeType.firstBlock:
        return 'First Block';
      case BadgeType.firstWeek:
        return 'First Week';
      case BadgeType.thirtyDayStreak:
        return '30 Day Streak';
      case BadgeType.completeJuz:
        return 'Complete Juz';
      case BadgeType.hundredAyahs:
        return '100 Ayahs';
      case BadgeType.fiveHundredAyahs:
        return '500 Ayahs';
      case BadgeType.thousandAyahs:
        return '1000 Ayahs';
    }
  }

  String _badgeDescription(BadgeType type) {
    switch (type) {
      case BadgeType.firstBlock:
        return 'Memorize your first block of verses';
      case BadgeType.firstWeek:
        return 'Maintain a 7-day streak';
      case BadgeType.thirtyDayStreak:
        return 'Maintain a 30-day streak';
      case BadgeType.completeJuz:
        return 'Memorize a complete Juz';
      case BadgeType.hundredAyahs:
        return 'Memorize 100 ayahs';
      case BadgeType.fiveHundredAyahs:
        return 'Memorize 500 ayahs';
      case BadgeType.thousandAyahs:
        return 'Memorize 1000 ayahs';
    }
  }
}
