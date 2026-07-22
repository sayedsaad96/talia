# PLAN.md — Talia Quran v2 Master Reference

> **Purpose**: A single authoritative document for any developer or AI model to understand the full project state, reproduce all completed work, and continue building the remaining phases at the same quality level.
>
> **Last Updated**: July 21, 2026 — After Phase 6 completion.

---

## Table of Contents

1. [Project Identity](#1-project-identity)
2. [Architecture & Conventions](#2-architecture--conventions)
3. [Technology Stack](#3-technology-stack)
4. [Core Infrastructure](#4-core-infrastructure)
5. [Phase 0 — Foundation ✅](#5-phase-0--foundation-)
6. [Phase 1 — Authentication ✅](#6-phase-1--authentication-)
7. [Phase 2 — Quran Reader ✅](#7-phase-2--quran-reader-)
8. [Phase 3 — Memorization Engine ✅](#8-phase-3--memorization-engine-)
9. [Phase 4 — Adult Journey ✅](#9-phase-4--adult-journey-)
10. [Phase 5 — Kids Journey ✅](#10-phase-5--kids-journey-)
11. [Phase 6 — Progress & Achievements ✅](#11-phase-6--progress--achievements-)
12. [Phase 7 — Parent Dashboard 🔲](#12-phase-7--parent-dashboard-)
13. [Phase 8 — Synchronization 🔲](#13-phase-8--synchronization-)
14. [Phase 9 — Production & Polish 🔲](#14-phase-9--production--polish-)
15. [Known Issues & Tech Debt](#15-known-issues--tech-debt)
16. [Key Decision Log](#16-key-decision-log)

---

## 1. Project Identity

| Field | Value |
|---|---|
| **Name** | Talia / تاليا |
| **Version** | 2.0.0+1 |
| **Type** | Flutter mobile app (Android + iOS) |
| **Vision** | Offline-first Quran memorization with structured learning, gamification, and parental oversight |
| **Languages** | English + Arabic (bidirectional) |
| **Source of Truth** | `docs/PROJECT.md` (1,954 lines, product spec) |
| **Root Path** | `d:\Flutter\talia` |

---

## 2. Architecture & Conventions

### 2.1 Feature-First Clean Architecture

```
lib/
├── core/               # Shared infrastructure (theme, routing, DI, errors, localization)
├── features/
│   ├── auth/           # Phase 1
│   ├── quran/          # Phase 2
│   ├── memorization_engine/  # Phase 3 (Domain + Data only — no presentation)
│   ├── adult_journey/  # Phase 4
│   ├── kids_journey/   # Phase 5
│   ├── progress/       # Phase 6
│   ├── parent_dashboard/ # Phase 7 (scaffolded, not implemented)
│   ├── azkar/          # Phase 9 (scaffolded, not implemented)
│   └── settings/       # Phase 9 (scaffolded, not implemented)
└── main.dart
```

Each feature contains up to 3 layers:

```
feature/
├── domain/       # Entities, Repository contracts, Use Cases, Engines (ZERO Flutter imports)
├── data/         # Repository implementations, Data Sources, Models
└── presentation/ # Cubits, States, Pages, Widgets
```

### 2.2 Dependency Direction

```
Presentation → Domain ← Data
```

- **Domain** has ZERO Flutter/package imports (only `dart:core`, `equatable`, `dartz`, and internal `talia/core/` imports).
- **Data** implements Domain contracts.
- **Presentation** consumes Domain via Use Cases.

### 2.3 Shared Types (used everywhere)

File: `lib/core/utils/typedefs.dart`
```dart
typedef ResultFuture<T> = Future<Either<Failure, T>>;
typedef ResultStream<T> = Stream<Either<Failure, T>>;
typedef DataMap = Map<String, dynamic>;
```

File: `lib/core/error/failures.dart`
```dart
sealed class Failure extends Equatable { final String message; final int? statusCode; }
final class ServerFailure extends Failure { ... }
final class CacheFailure extends Failure { ... }
final class NetworkFailure extends Failure { ... }
final class AuthFailure extends Failure { ... }
final class UnexpectedFailure extends Failure { ... }
```

File: `lib/core/error/exceptions.dart`
```dart
class ServerException implements Exception { final String message; final int? statusCode; }
class CacheException implements Exception { final String message; final int? statusCode; }
class NetworkException implements Exception { final String message; }
class AuthException implements Exception { final String message; final int? statusCode; }
```

### 2.4 Naming Conventions

| Element | Convention | Example |
|---|---|---|
| Files | `snake_case.dart` | `session_engine.dart` |
| Classes | `PascalCase` | `SessionEngine` |
| Variables | `camelCase` | `currentSession` |
| Cubits | `*Cubit` | `HomeCubit` |
| States | `*State` | `HomeState` |
| Entities | `*Entity` | `SessionEntity` |
| Models | `*Model` extends `*Entity` | `SessionModel` |
| Use Cases | `*UseCase` | `StartSessionUseCase` |
| Repositories | `*Repository` (abstract) / `*RepositoryImpl` | `SessionRepository` |
| Pages | `*Page` | `SmartHomePage` |
| Widgets | `*Card`, `*Display`, `*Bar`, etc. | `StatCard` |

### 2.5 State Management

- **flutter_bloc** (Cubit only, no Bloc events)
- Cubits are **factories** in GetIt (new instance per screen), except `AuthCubit` which is a **lazySingleton** (global auth state).

### 2.6 Localization

- ARB files: `lib/core/localization/arb/app_en.arb`, `app_ar.arb`
- Config: `l10n.yaml` at project root
- Generated: `lib/core/localization/generated/` (auto-generated, don't edit)
- Regenerate: `flutter gen-l10n`
- Access: `AppLocalizations.of(context)` (aliased as `l10n`)

---

## 3. Technology Stack

### pubspec.yaml dependencies

| Category | Package | Version |
|---|---|---|
| State | `flutter_bloc` | ^8.1.0 |
| Equality | `equatable` | ^2.0.0 |
| DI | `get_it` | ^8.0.0 |
| Routing | `go_router` | ^15.0.0 |
| Local DB | `isar` | ^3.1.0+1 (declared, not yet used — `shared_preferences` interim) |
| Cloud | `supabase_flutter` | ^2.0.0 |
| FP | `dartz` | ^0.10.1 |
| Network | `connectivity_plus` | ^6.0.0 |
| Config | `flutter_dotenv` | ^5.2.0 |
| Localization | `intl` | any |
| Logging | `logger` | ^2.5.0 |
| Quran | `qcf_quran_plus` | ^0.0.8 |
| Scroll | `scrollable_positioned_list` | ^0.3.8 |
| Prefs | `shared_preferences` | ^2.2.0 |
| Audio | `just_audio` | ^0.9.0, `audio_session` ^0.1.21 |

> **IMPORTANT — Isar vs SharedPreferences**: The project declares `isar` in pubspec but currently uses `shared_preferences` as the interim local storage. The `isar_generator` package conflicts with the current Dart SDK. Migration to Isar is deferred to a later phase. All data sources use `shared_preferences` with JSON encoding for now.

---

## 4. Core Infrastructure

### 4.1 Theme

| File | Purpose |
|---|---|
| `lib/core/theme/app_colors.dart` | Light + Dark color palettes (teal primary `#0D7377`, gold secondary `#C9A44C`) |
| `lib/core/theme/app_spacing.dart` | Spacing constants (`xs`=4, `sm`=8, `md`=16, `lg`=24, `xl`=32, `xxl`=48) + border radii |
| `lib/core/theme/app_theme.dart` | `ThemeData` builder for light/dark modes |
| `lib/core/theme/app_text_theme.dart` | Typography definitions |

### 4.2 Routing

| File | Purpose |
|---|---|
| `lib/core/router/route_names.dart` | All route name constants and path constants |
| `lib/core/router/app_router.dart` | `GoRouter` configuration with all route definitions |
| `lib/core/router/auth_guard.dart` | Route protection redirect logic |

### 4.3 Dependency Injection

| File | Purpose |
|---|---|
| `lib/core/di/injection_container.dart` | Single composition root — ~310 lines, registers ALL dependencies |

Registration order: Config → Supabase → Core → DataSources → Repositories → UseCases → Cubits

### 4.4 Config & Logging

| File | Purpose |
|---|---|
| `lib/core/config/app_config.dart` | Loads `.env` file, exposes `supabaseUrl` and `supabaseAnonKey` |
| `lib/core/logging/app_logger.dart` | Wrapper around `logger` package |
| `.env` | Environment variables (Supabase credentials) |

---

## 5. Phase 0 — Foundation ✅

**Status**: COMPLETE

**What was built**:
- Flutter project scaffold
- Core directory structure (`core/`, `features/`)
- Theme system (light + dark palettes)
- Localization (EN + AR, `l10n.yaml`, generated L10n)
- Routing (`go_router` with auth guard)
- Dependency Injection (`get_it` composition root)
- Error handling (`Failure` sealed hierarchy, `Exception` classes)
- Logging (`AppLogger`)
- Configuration (`flutter_dotenv` + `.env`)
- Type aliases (`ResultFuture`, `DataMap`)

**Files created**: ~15 core infrastructure files.

---

## 6. Phase 1 — Authentication ✅

**Status**: COMPLETE

**What was built**:
- Supabase email+password authentication
- Login, Register, Forgot Password flows
- Guest mode (Quran reading only, no memorization)
- `AuthCubit` (lazySingleton) for global auth state
- Route protection via `auth_guard.dart`
- Onboarding page

### File Inventory

```
features/auth/
├── data/
│   ├── datasources/auth_remote_data_source.dart
│   └── repositories/auth_repository_impl.dart
├── domain/
│   ├── entities/user_entity.dart
│   ├── repositories/auth_repository.dart
│   └── usecases/
│       ├── forgot_password_use_case.dart
│       ├── get_current_user_use_case.dart
│       ├── login_use_case.dart
│       ├── logout_use_case.dart
│       ├── register_use_case.dart
│       └── watch_auth_state_use_case.dart
└── presentation/
    ├── cubit/
    │   ├── auth_cubit.dart / auth_state.dart
    │   ├── login_cubit.dart / login_state.dart
    │   └── register_cubit.dart / register_state.dart
    └── pages/
        ├── splash_page.dart
        ├── onboarding_page.dart
        ├── login_page.dart
        └── register_page.dart
```

### Key Design Decisions
- **Auth method**: Email+password only (for now).
- **Forgot password**: Uses Supabase's built-in `resetPasswordForEmail` — free and simple.
- **AuthCubit** is a `lazySingleton` because auth state is global.
- **Guest mode** skips auth, but routes to protected pages are blocked by `auth_guard`.

---

## 7. Phase 2 — Quran Reader ✅

**Status**: COMPLETE

**What was built**:
- Full Quran reader using `qcf_quran_plus` package
- Mushaf (page) mode + Surah list (scroll) mode
- Tajweed toggle
- Font size adjustment
- Dark mode support
- Search by surah name
- Bookmarks (save/delete, with local `shared_preferences` storage)
- Last read position (auto-save/restore)
- Surah list page (114 surahs with metadata)

### File Inventory

```
features/quran/
├── data/
│   ├── datasources/quran_local_data_source.dart  # Uses qcf_quran_plus + shared_preferences
│   ├── models/
│   │   ├── surah_model.dart
│   │   ├── bookmark_model.dart
│   │   └── reading_progress_model.dart
│   └── repositories/quran_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── surah_entity.dart
│   │   ├── bookmark_entity.dart
│   │   └── reading_progress_entity.dart
│   ├── repositories/quran_repository.dart
│   └── usecases/
│       ├── get_all_surahs_use_case.dart
│       ├── save_bookmark_use_case.dart
│       ├── get_bookmarks_use_case.dart
│       ├── delete_bookmark_use_case.dart
│       ├── save_reading_progress_use_case.dart
│       └── get_reading_progress_use_case.dart
└── presentation/
    ├── cubit/
    │   ├── quran_cubit.dart
    │   ├── reader_cubit.dart / reader_state.dart
    │   ├── bookmark_cubit.dart
    │   └── search_cubit.dart
    ├── pages/
    │   ├── quran_reader_page.dart   # Main reader (Mushaf + Surah list modes)
    │   ├── surah_list_page.dart     # 114 surahs grid
    │   ├── search_page.dart         # Search by name
    │   └── bookmarks_page.dart      # Saved bookmarks list
    └── widgets/
        └── reader_controls_bar.dart # Toggle tajweed, mode, font size, bookmark
```

### Key API: `qcf_quran_plus` package

```dart
// Available functions from the package:
getSurahNameArabic(int surahNumber)        // الفاتحة
getSurahNameEnglish(int surahNumber)        // Al-Faatiha
getVerseCount(int surahNumber)             // 7
getPlaceOfRevelation(int surahNumber)      // Makkah / Madinah
getJuzNumber(int surahNumber, int ayah)    // 1-30
getPageNumber(int surahNumber, int ayah)   // 1-604
// Also provides QuranPageView and QuranSurahListView widgets for rendering
```

---

## 8. Phase 3 — Memorization Engine ✅

**Status**: COMPLETE

> **IMPORTANT**: The memorization engine is **Domain + Data ONLY**. It has NO presentation layer. Its cubits live in `adult_journey/` and `kids_journey/`.

**What was built**:
- 6-stage session lifecycle: `Created → Learning → Memorizing → Reciting → Remediation → Block Review → Completed`
- SM-2 spaced repetition review scheduling
- Smart Coach recommendation engine
- XP/Level/Badge gamification system
- Progress calculation from memorization records
- All three repositories (Session, Memorization, Review) with `shared_preferences` data sources

### File Inventory

```
features/memorization_engine/
├── data/
│   ├── datasources/memorization_local_data_source.dart
│   ├── models/
│   │   ├── session_model.dart
│   │   ├── memorization_record_model.dart
│   │   ├── ayah_progress_model.dart
│   │   ├── review_schedule_model.dart
│   │   ├── review_result_model.dart
│   │   ├── streak_model.dart
│   │   └── badge_model.dart
│   └── repositories/
│       ├── session_repository_impl.dart
│       ├── memorization_repository_impl.dart
│       └── review_repository_impl.dart
├── domain/
│   ├── engine/
│   │   ├── session_engine.dart       # 6-stage lifecycle logic
│   │   ├── review_engine.dart        # SM-2 spaced repetition
│   │   ├── smart_coach.dart          # Recommendation priority engine
│   │   └── progress_calculator.dart  # Stats aggregation
│   ├── entities/
│   │   ├── session_entity.dart         # SessionStage enum + SessionEntity
│   │   ├── ayah_progress_entity.dart   # AyahStatus enum + AyahProgressEntity
│   │   ├── memorization_record_entity.dart  # Permanent record per memorized ayah
│   │   ├── review_schedule_entity.dart # SM-2 schedule per ayah
│   │   ├── review_result_entity.dart   # ReviewQuality enum + result
│   │   ├── streak_entity.dart          # Current + longest streak
│   │   ├── progress_entity.dart        # Aggregated progress stats
│   │   ├── badge_entity.dart           # BadgeType enum + unlock state
│   │   ├── recommendation_entity.dart  # Smart Coach output
│   │   └── xp_config.dart             # XP constants and calculations
│   ├── repositories/
│   │   ├── session_repository.dart
│   │   ├── memorization_repository.dart
│   │   └── review_repository.dart
│   └── usecases/
│       ├── start_session_use_case.dart
│       ├── advance_session_use_case.dart
│       ├── evaluate_recitation_use_case.dart
│       ├── complete_session_use_case.dart
│       ├── get_active_session_use_case.dart
│       ├── get_progress_use_case.dart
│       ├── get_badges_use_case.dart
│       ├── get_due_reviews_use_case.dart
│       ├── get_recommendations_use_case.dart
│       └── submit_review_use_case.dart
```

### Core Entity Reference

**SessionEntity**:
```dart
enum SessionStage { created, learning, memorizing, reciting, remediation, blockReview, completed }
// Fields: id, userId, surahNumber, startAyah, endAyah, stage, createdAt, completedAt, ayahProgress (List<AyahProgressEntity>), xpEarned
```

**AyahProgressEntity**:
```dart
enum AyahStatus { notStarted, learning, memorizing, recited, passed, failed, remediated }
// Fields: surahNumber, ayahNumber, status, hintLevel, attempts, similarityScore, lastAttemptAt
```

**MemorizationRecordEntity**: Permanent record created when an ayah is memorized.
```dart
// Fields: id, userId, surahNumber, ayahNumber, qualityScore, totalAttempts, memorizedAt, lastReviewedAt, reviewCount, confidence
// isWeak = confidence < 0.4 | isStrong = confidence >= 0.8
```

**ReviewScheduleEntity**: SM-2 parameters per ayah.
```dart
// Fields: id, memorRecordId, surahNumber, ayahNumber, nextReviewDate, intervalDays, easeFactor, consecutiveCorrect
```

**ProgressEntity**: Aggregated stats.
```dart
// Fields: totalMemorizedAyahs, totalReviewedAyahs, weakAyahsCount, currentStreak, longestStreak, totalXp, level, lastActivityDate, completionPercentage
// totalQuranAyahs = 6236
```

**XpConfig**:
```dart
// memorizeAyah=10, reviewAyah=5, perfectRecitation=15, streakBonus=3
// hintPenaltyLevel1=-2, hintPenaltyLevel2=-5, blockReviewBonus=20
// xpForLevel(level) = level * 100
// levelFromXp(xp) = (xp ~/ 100) + 1
```

**BadgeEntity**:
```dart
enum BadgeType { firstBlock, firstWeek, thirtyDayStreak, completeJuz, hundredAyahs, fiveHundredAyahs, thousandAyahs }
```

### Engine Logic

**SessionEngine** (`session_engine.dart`):
- `initializeSession()` → Creates `AyahProgressEntity` for each ayah, transitions to `learning`
- `advanceStage()` → Fixed stage order, checks `isStageComplete()` before advancing
- `completeLearnStep()`, `completeMemorizeStep()`, `evaluateRecitation()` → Per-ayah updates
- `completeSession()` → Calculates XP, marks completed, timestamp
- Recitation pass threshold: `similarityScore >= 0.7`

**ReviewEngine** (`review_engine.dart`):
- SM-2 algorithm: Adjusts `easeFactor` (1.3–3.0), `intervalDays`, `consecutiveCorrect`
- `calculateNextReview()` — Core SM-2 formula
- `getDueReviews()`, `getOverdueReviews()`, `getWeakAyahs()`
- `createInitialSchedule()` — First review = 1 day after memorization

**SmartCoach** (`smart_coach.dart`):
- Priority: 1. Continue Session → 2. Weak Ayahs → 3. Due Reviews → 4. Daily Memorization → 5. Quran Reading

---

## 9. Phase 4 — Adult Journey ✅

**Status**: COMPLETE

**What was built**:
- Smart Home Dashboard with Smart Coach recommendation card
- Session setup (surah/ayah range picker)
- Active session page (6-stage flow UI)
- Session completion page (XP earned, badges)
- Review page (spaced repetition review with quality ratings)
- Weak ayahs page (confidence < 0.4 drilldown)
- Quick action row (Quran, Review, Bookmarks, Kids, Progress)

### File Inventory

```
features/adult_journey/
└── presentation/
    ├── cubit/
    │   ├── home_cubit.dart / home_state.dart
    │   ├── session_cubit.dart / session_state.dart
    │   └── review_cubit.dart / review_state.dart
    ├── pages/
    │   ├── smart_home_page.dart       # Main dashboard
    │   ├── session_setup_page.dart    # Pick surah + ayah range
    │   ├── session_page.dart          # Active 6-stage memorization
    │   ├── session_complete_page.dart # Post-session summary
    │   ├── review_page.dart           # Due reviews w/ quality rating
    │   └── weak_ayahs_page.dart       # Low-confidence ayah review
    └── widgets/
        ├── progress_summary_card.dart
        ├── coach_action_card.dart
        └── ayah_display_card.dart
```

### Key State: `SessionState`
```dart
enum SessionCubitStatus { initial, loading, active, completing, completed, error }
// Fields: status, session (SessionEntity?), currentAyahIndex, errorMessage
```

---

## 10. Phase 5 — Kids Journey ✅

**Status**: COMPLETE

> The Kids Journey is **presentation-only**. It reuses the exact same `memorization_engine` Domain/Data layers and `SessionCubit` from the Adult Journey. The difference is purely visual — gamified UI, simplified controls.

**What was built**:
- World Map (horizontal scroll of Juz zones)
- Mission Page (surahs within a Juz as mission cards)
- Kids Session Page (wraps `SessionCubit` with child-friendly UI)
- Reward Page (confetti animation, star rating, badge reveal)
- Custom widgets (LevelBadge, StarRating, WorldZoneCard, MissionCard, ConfettiAnimation)

### File Inventory

```
features/kids_journey/
└── presentation/
    ├── cubit/
    │   ├── kids_home_cubit.dart
    │   └── kids_home_state.dart
    ├── pages/
    │   ├── kids_home_page.dart     # World Map
    │   ├── kids_mission_page.dart  # Surah missions per Juz
    │   ├── kids_session_page.dart  # Simplified session (wraps SessionCubit)
    │   └── kids_reward_page.dart   # Confetti + stars + badge
    └── widgets/
        ├── level_badge.dart
        ├── star_rating.dart
        ├── world_zone_card.dart
        ├── mission_card.dart
        └── confetti_animation.dart  # Pure Canvas CustomPainter
```

---

## 11. Phase 6 — Progress & Achievements ✅

**Status**: COMPLETE

> No new Domain or Data code was needed. All data comes from existing `GetProgressUseCase`, `GetBadgesUseCase`, and `MemorizationRepository.getRecords()`.

**What was built**:
- Full-screen scrollable Progress Dashboard
- Stats Grid (2x3: memorized, reviewed, completion %, weak ayahs)
- Streak Visualization (animated flame with `ScaleTransition`)
- Activity Heatmap (12-week GitHub-style `CustomPainter` grid)
- Badge Gallery (7 badge types, unlocked=color, locked=greyscale)
- XP Progress Bar (animated `TweenAnimationBuilder` fill)
- Route and DI wired up, placeholder removed

### File Inventory

```
features/progress/
└── presentation/
    ├── cubit/
    │   ├── progress_cubit.dart
    │   └── progress_state.dart
    ├── pages/
    │   └── progress_page.dart
    └── widgets/
        ├── stat_card.dart
        ├── activity_heatmap.dart    # CustomPainter heatmap
        ├── streak_display.dart      # Animated flame
        ├── badge_card.dart          # Unlocked/locked badge display
        └── xp_progress_bar.dart     # Animated XP fill bar
```

---

## 12. Phase 7 — Parent Dashboard 🔲

**Status**: NOT STARTED

### Objective
Allow a parent to link child accounts, view their memorization progress, weekly reports, and certificates.

### Required Deliverables

1. **Child Linking Flow**: Parent enters child's email/code → Supabase links accounts.
2. **Parent Home**: List of linked children with summary stats.
3. **Child Detail**: Full progress view (reuse `ProgressPage` widgets for a child's data).
4. **Weekly Report**: Summary card showing this week's activity, streak, and memorized ayah count.
5. **Certificate View**: Visual certificates for completed Juz milestones.

### Implementation Blueprint

#### Domain Layer (new)
```
features/parent_dashboard/domain/
├── entities/
│   ├── child_profile_entity.dart      # id, name, email, linkedAt, avatarUrl
│   └── weekly_report_entity.dart      # weekStart, ayahsMemorized, reviewsCompleted, streakDays, xpEarned
├── repositories/
│   └── parent_repository.dart         # Abstract: linkChild, getLinkedChildren, getChildProgress, getWeeklyReport
└── usecases/
    ├── link_child_use_case.dart
    ├── get_linked_children_use_case.dart
    ├── get_child_progress_use_case.dart
    └── get_weekly_report_use_case.dart
```

#### Data Layer (new)
```
features/parent_dashboard/data/
├── datasources/parent_remote_data_source.dart  # Supabase queries
├── models/
│   ├── child_profile_model.dart
│   └── weekly_report_model.dart
└── repositories/parent_repository_impl.dart
```

#### Presentation Layer (new)
```
features/parent_dashboard/presentation/
├── cubit/
│   ├── parent_cubit.dart
│   └── parent_state.dart
├── pages/
│   ├── parent_home_page.dart      # List of children
│   ├── child_detail_page.dart     # Reuse ProgressPage widgets
│   └── weekly_report_page.dart    # Weekly summary
└── widgets/
    ├── child_card.dart
    ├── report_summary_card.dart
    └── certificate_card.dart
```

#### Supabase Schema (required)
```sql
-- Table: parent_child_links
CREATE TABLE parent_child_links (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  parent_id UUID REFERENCES auth.users(id),
  child_id UUID REFERENCES auth.users(id),
  linked_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(parent_id, child_id)
);

-- RLS: Parents can only see their own linked children
ALTER TABLE parent_child_links ENABLE ROW LEVEL SECURITY;
CREATE POLICY "parents_own_links" ON parent_child_links
  FOR SELECT USING (auth.uid() = parent_id);
```

#### Routing
- `/parent-dashboard` → `ParentHomePage`
- `/parent-dashboard/child/:childId` → `ChildDetailPage`
- `/parent-dashboard/child/:childId/report` → `WeeklyReportPage`

---

## 13. Phase 8 — Synchronization 🔲

**Status**: NOT STARTED

### Objective
Background sync of all local data to Supabase for multi-device access and parent monitoring.

### Required Deliverables

1. **Sync Queue**: Local queue of pending writes. Each mutation (session complete, review submit, etc.) enqueues a sync item.
2. **Background Sync Service**: Runs on connectivity restoration. Processes queue in FIFO order.
3. **Conflict Resolution**: Last-write-wins with timestamp comparison.
4. **Offline Recovery**: App can lose connection mid-sync and resume cleanly.

### Implementation Blueprint

#### New files
```
lib/core/sync/
├── sync_service.dart         # Background sync orchestrator
├── sync_queue.dart           # Persistent queue (shared_preferences or Isar)
├── sync_item.dart            # Entity: table, operation, payload, createdAt
└── conflict_resolver.dart    # Last-write-wins strategy
```

#### Supabase Tables (required)
```sql
-- Memorization records (cloud mirror)
CREATE TABLE memorization_records (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id),
  surah_number INT NOT NULL,
  ayah_number INT NOT NULL,
  quality_score FLOAT,
  total_attempts INT,
  memorized_at TIMESTAMPTZ,
  last_reviewed_at TIMESTAMPTZ,
  review_count INT DEFAULT 0,
  confidence FLOAT DEFAULT 1.0,
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Review schedules (cloud mirror)
CREATE TABLE review_schedules ( ... );

-- Sessions (cloud mirror)
CREATE TABLE sessions ( ... );

-- Streaks (cloud mirror)
CREATE TABLE streaks ( ... );
```

#### Integration Points
- `CompleteSessionUseCase` → enqueue sync after local save
- `SubmitReviewUseCase` → enqueue sync after local save
- `connectivity_plus` → listen for connectivity changes → trigger sync
- Each repository method should be wrapped with a "sync-after-write" hook

---

## 14. Phase 9 — Production & Polish 🔲

**Status**: NOT STARTED

### Required Deliverables

#### 9.1 Azkar Feature
```
features/azkar/
├── domain/entities/azkar_entity.dart
├── data/datasources/azkar_local_data_source.dart  # Hardcoded JSON data
└── presentation/
    ├── cubit/azkar_cubit.dart
    ├── pages/azkar_page.dart (categories: morning, evening, sleep, wake, prayer, general)
    └── widgets/azkar_card.dart (counter + done indicator)
```

#### 9.2 Digital Rosary
```
features/settings/  # or features/rosary/
└── presentation/pages/digital_rosary_page.dart
    # Simple counter + daily goal + progress ring + haptic feedback
```

#### 9.3 Settings Page
```
features/settings/
└── presentation/
    ├── cubit/settings_cubit.dart
    ├── pages/settings_page.dart
    └── widgets/ (theme toggle, language selector, notification prefs, about)
```

#### 9.4 Notifications
- `flutter_local_notifications` for daily reminders, review reminders, streak alerts
- Settings-controlled (can be disabled)

#### 9.5 Certificate PDF Generation
- Generate PDF certificates for completed Juz using `pdf` package
- Share via `share_plus`

#### 9.6 Performance & Security
- Isar migration (if `isar_generator` conflict resolved)
- Asset optimization
- Release build configuration
- Store assets (icons, screenshots, descriptions)

#### 9.7 Audio Playback (Full Implementation)
- Integrate `just_audio` for ayah-by-ayah recitation in both Reader and Session pages
- Cache audio locally after first download

---

## 15. Known Issues & Tech Debt

| ID | Severity | Description | Phase |
|---|---|---|---|
| **TD-01** | Medium | `isar_generator` conflicts with Dart SDK. Using `shared_preferences` as interim storage. Migration deferred. | P3 |
| **TD-02** | Low | `withOpacity` deprecation warnings in several kids/progress widgets. Should use `.withValues(alpha: x)` instead. **FIXED**. | P5/P6 |
| **TD-03** | Low | `prefer_initializing_formals` info lints on `KidsHomeCubit`. **FIXED**. | P5 |
| **TD-04** | Low | `XpConfig.calculateXpForLevel()` referenced in `xp_progress_bar.dart` does not exist. **FIXED**. | P6 |
| **TD-05** | Medium | Several hardcoded English strings in widgets (e.g., "All good!", "Needs review", "Total Reviews", "Bookmarks", "Kids"). **FIXED**. | P4-P6 |
| **TD-06** | Low | Audio playback buttons exist in UI but are not wired to `just_audio`. Placeholder only. | P2/P5 |
| **TD-07** | Low | Speech-to-text for recitation evaluation not implemented. Currently uses manual pass/fail buttons. | P3/P4 |
| **TD-08** | Medium | No unit tests have been written yet. Testing is deferred but critical before production. | All |

---

## 16. Key Decision Log

| Date | Decision | Rationale |
|---|---|---|
| July 2026 | Use `shared_preferences` instead of `isar` for interim storage | `isar_generator` conflicts with current Dart SDK. All data sources use JSON encoding. |
| July 2026 | Auth: email+password only | User directive: "just email+password for now" |
| July 2026 | Forgot password: Supabase built-in `resetPasswordForEmail` | User directive: "easy and free way" |
| July 2026 | Use `qcf_quran_plus` for Quran data | User directive: "use qcf_quran_plus package for quran data" |
| July 2026 | Kids Journey = presentation-only modification | Reuses `memorization_engine` Domain/Data; only the UI wrapper differs |
| July 2026 | Progress Dashboard = presentation-only | All computation from existing use cases |
| July 2026 | Feature-first Clean Architecture with Domain having zero Flutter deps | Core architectural principle from `PROJECT.md` |
| July 2026 | `AuthCubit` = lazySingleton, all other cubits = factory | Auth state is global; screen cubits get fresh instances |
| July 2026 | Certificates: Visual-only in Phase 6, PDF generation in Phase 9 | Incremental delivery |

---

> **For the next developer/model**: Start with Phase 7 (Parent Dashboard). It requires new Supabase tables and is the first phase with a truly remote data source (parent reads child data from cloud). Then Phase 8 (Sync) enables multi-device. Phase 9 is polish and store-readiness.
