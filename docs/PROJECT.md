# Talia Quran V2
## PROJECT.md

Version: 2.0
Status: Active
Last Updated: July 2026

---

# 1. Vision

## 1.1 Product Vision

Talia is an Offline-First Quran application designed to help Muslims build a sustainable relationship with the Holy Quran through reading, memorization, review, and long-term progress tracking.

The application provides a complete memorization journey powered by a structured learning engine while remaining simple enough for beginners and engaging enough for children.

The product separates the user experience into independent journeys while sharing the same memorization engine.

---

## 1.2 Mission

Enable every Muslim to memorize the Quran using a structured, measurable, and distraction-free experience that works without requiring a permanent internet connection.

---

## 1.3 Core Values

- Simplicity
- Reliability
- Offline First
- Long-term Progress
- Islamic Authenticity
- Consistency
- Maintainability

---

# 2. Product Goals

The application must provide:

- Quran Reading
- Quran Memorization
- Review Planning
- Daily Motivation
- Progress Tracking
- Parent Monitoring
- Child Journey

Every feature must directly support at least one of these goals.

---

# 3. Product Scope

## Included

- Authentication
- Guest Reading
- Quran Reader
- Memorization
- Review Engine
- Smart Coach
- Adult Journey
- Kids Journey
- Parent Dashboard
- Progress Tracking
- Achievements
- Certificates
- Azkar
- Digital Rosary

---

## Excluded

The following are outside the current product scope.

- Social Network
- Public Leaderboards
- User Chat
- Community Features
- Marketplace
- Live Classes

---

# 4. Product Principles

## Offline First

The application must continue functioning without internet access.

User progress is always saved locally before any cloud synchronization.

---

## Local First

Isar is the primary data source.

Every write operation must complete locally before synchronization.

---

## Cloud Synchronization

Supabase is responsible for:

- Authentication
- User Profiles
- Cloud Backup
- Parent Dashboard
- Remote Synchronization

Supabase is never treated as the primary runtime database.

---

## Clean Architecture

The project follows Feature-First Clean Architecture.

Presentation

↓

Domain

↓

Data

Dependencies always point inward.

The Domain layer contains no Flutter dependencies.

---

## Feature Isolation

Every feature owns its:

- Presentation
- Domain
- Data

Features communicate only through public contracts.

---

## Testability

Business logic must be testable without Flutter.

No business rule may exist exclusively inside Widgets.

---

# 5. User Types

## Guest

Permissions

- Read Quran
- Listen to Audio

Restrictions

- No memorization
- No progress
- No synchronization

---

## Registered User

Permissions

- Memorization
- Review
- Progress
- Achievements
- Backup

---

## Child

Permissions

- Kids Journey
- Gamified Progress
- Rewards

Restrictions

Parent management is external.

---

## Parent

Permissions

- Link Child
- View Progress
- View Reports
- View Certificates

Parents never modify memorization records directly.

---

# 6. Application Modules

The application consists of the following modules.

Authentication

Quran Reader

Memorization Engine

Adult Journey

Kids Journey

Parent Dashboard

Progress

Achievements

Azkar

Settings

Each module is independently maintainable.

No module may directly depend on another module's implementation.

Communication occurs through repository contracts.

---

# 7. Success Criteria

The project is considered successful when a user can:

- Create an account
- Read the Quran
- Memorize verses
- Continue interrupted sessions
- Review scheduled verses
- Track long-term progress
- Synchronize across devices
- Allow a parent to monitor a child account

# 8. User Journeys

The application provides separate user journeys while sharing the same core memorization engine.

---

## 8.1 Guest Journey

Purpose

Allow any user to access the Quran immediately without creating an account.

Flow

Splash

↓

Home

↓

Quran Reader

↓

Bookmarks (Local Only)

Guest users cannot access memorization, review, achievements, synchronization, or dashboards.

---

## 8.2 Adult Journey

Purpose

Provide a structured memorization experience using spaced repetition.

Flow

Home

↓

Smart Coach

↓

Daily Plan

↓

Memorization Session

↓

Progress Update

↓

Review Scheduling

↓

Completion

The Home screen always presents the highest priority action available.

Priority order:

1. Continue Session
2. Weak Ayahs
3. Due Reviews
4. Daily Memorization
5. Quran Reading

---

## 8.3 Child Journey

Purpose

Provide a simplified and motivating memorization experience.

The child experience shares the same memorization engine but replaces the interface with a gamified journey.

Main components

- World Map
- Missions
- Rewards
- XP
- Levels
- Characters

The child should never interact with complex statistics or scheduling.

---

## 8.4 Parent Journey

Purpose

Allow guardians to monitor progress.

Flow

Login

↓

Parent Dashboard

↓

Child Selection

↓

Progress

↓

Reports

↓

Certificates

Parents have read-only access to memorization data.

---

# 9. Quran Reader

Purpose

Provide a complete Quran reading experience independent from memorization.

---

## Features

- Uthmani Quran
- Audio Playback
- Bookmarks
- Last Read Position
- Search
- Font Size
- Theme Support

---

## Reading Rules

Reading progress is stored independently from memorization progress.

Bookmarks are available offline.

Audio may be cached locally after first playback.

---

# 10. Memorization Engine

The Memorization Engine is the core of the application.

Every memorization journey depends on this engine.

The engine contains business logic only.

No UI code exists inside the engine.

---

## Session Lifecycle

Every memorization session follows the same lifecycle.

Created

↓

Learning

↓

Memorizing

↓

Reciting

↓

Remediation (if required)

↓

Block Review

↓

Completed

The order of these states is fixed.

The UI cannot bypass or reorder them.

---

## Learning Stage

Purpose

Introduce the verse.

Capabilities

- Show verse
- Play audio
- Repeat audio

No evaluation occurs.

---

## Memorizing Stage

Purpose

Help the user prepare before recitation.

Hints

Level 0

No Hint

Level 1

First Word

Level 2

Entire Verse

Using hints reduces the memorization quality score.

---

## Reciting Stage

Purpose

Evaluate memorization.

Rules

- Verse is hidden.
- User starts recording.
- Speech is converted to text.
- Text is normalized.
- Similarity is calculated.
- Session continues only if evaluation succeeds.

---

## Remediation Stage

Purpose

Correct mistakes immediately.

Only failed verses return to remediation.

Previously successful verses remain completed.

---

## Block Review

Purpose

Evaluate the entire memorized block.

Rules

No hints are allowed.

Failed verses return to remediation.

Successful verses remain completed.

Children under the configured age may skip this stage.

---

## Completion

At the end of every session:

- Progress is stored locally.
- Review schedule is updated.
- XP is awarded.
- Statistics are refreshed.
- Synchronization is queued.

The session then becomes immutable.

---

# 11. Smart Coach

Purpose

Help the user decide what should be done next.

The Smart Coach never creates memorization data.

Its responsibility is recommendation only.

---

## Recommendation Priority

Priority 1

Continue interrupted session.

Priority 2

Weak verses requiring remediation.

Priority 3

Scheduled reviews.

Priority 4

Daily memorization.

Priority 5

General Quran reading.

Only one recommendation is presented as the primary action.

---

## Coach Inputs

The Smart Coach reads:

- Memorization records
- Review schedule
- Session state
- Progress history

The coach never writes data directly.

# 12. Progress System

Purpose

Track long-term memorization progress and provide meaningful feedback to the user.

The Progress System visualizes progress only.

It never changes memorization records.

---

## Progress Components

- Memorized Ayahs
- Reviewed Ayahs
- Weak Ayahs
- Current Streak
- Longest Streak
- Daily Activity
- XP
- Achievements
- Certificates

---

## Progress Rules

Progress is updated only after a session is completed.

Cancelled sessions never affect progress.

Failed recitations update only the affected verses.

Reading progress is independent from memorization progress.

---

## Statistics

The application provides statistics including:

- Total Memorized Ayahs
- Total Reviews
- Completion Percentage
- Daily Activity
- Weekly Activity
- Monthly Activity

Statistics are generated from memorization records.

No duplicate statistics tables should exist.

---

# 13. Review Engine

Purpose

Schedule future reviews using spaced repetition.

The Review Engine is independent from the user interface.

The Smart Coach consumes its output.

---

## Responsibilities

- Calculate next review date.
- Track review history.
- Detect overdue reviews.
- Detect weak verses.
- Update review intervals.

---

## Review Lifecycle

New Memorization

↓

Successful Review

↓

Interval Increase

↓

Next Review Scheduled

↓

Review Completed

↓

Repeat

---

## Review Rules

Every successful review increases confidence.

Failed reviews decrease confidence.

Future review dates are recalculated after every review.

Review scheduling is handled only by the Review Engine.

No other module modifies review dates.

---

# 14. Gamification

Purpose

Increase motivation without affecting memorization quality.

Gamification rewards consistency.

It never changes evaluation rules.

---

## Components

- XP
- Levels
- Badges
- Achievements
- Daily Goals
- Rewards

---

## XP

XP is awarded when:

- Completing memorization.
- Completing reviews.
- Maintaining streaks.

XP is reduced when hints are used according to the memorization rules.

---

## Streak

A streak increases when the user successfully completes at least one memorization or review session during the day.

Missing a required day resets the current streak.

The longest streak is preserved.

---

## Badges

Badges are unlocked when predefined milestones are reached.

Examples

- First Memorized Block
- First Week
- Thirty Day Streak
- Complete Juz

Badges are permanent.

---

## Certificates

Certificates represent completed memorization milestones.

Certificates are generated from memorization records.

They are available for viewing and sharing after generation.

---

# 15. Azkar

Purpose

Provide daily remembrance alongside Quran usage.

---

## Sections

- Morning Azkar
- Evening Azkar
- Sleep
- Wake Up
- Prayer
- General Azkar

---

## Rules

Azkar works offline.

Completion of Azkar does not affect memorization statistics.

---

# 16. Digital Rosary

Purpose

Provide a simple digital tasbeeh.

---

## Features

- Counter
- Daily Goal
- Progress Ring
- Haptic Feedback

---

## Rules

Counter value is stored locally.

Resetting the counter never affects historical statistics.

---

# 17. Notifications

Purpose

Encourage consistency.

---

## Notification Types

- Daily Reminder
- Review Reminder
- Continue Session
- Achievement
- Streak Reminder

---

## Rules

Notifications remind the user.

They never modify user progress.

All notifications can be disabled from Settings.

---

# 18. Offline First

Offline support is a core product requirement.

The application must continue functioning without internet whenever possible.

---

## Local Storage

Local storage is responsible for:

- Memorization
- Reviews
- Sessions
- Progress
- Settings
- Bookmarks

Every write operation completes locally before synchronization.

---

## Synchronization

Synchronization occurs in the background.

Synchronization must never block the user interface.

Synchronization retries automatically after connectivity returns.

---

## Session Recovery

If the application closes unexpectedly:

- Session state is restored.
- Progress already completed is preserved.
- The user may continue from the last completed step.

No completed work should be lost due to interruption.

# 19. Technical Architecture

## Architecture Overview

Talia follows a strict Feature-First Clean Architecture.

Every feature is independent and organized into three layers.

Presentation

↓

Domain

↓

Data

Dependencies always point toward the Domain layer.

The Domain layer must never depend on Flutter or infrastructure.

---

## Presentation Layer

Responsibilities

- Pages
- Widgets
- Cubits
- UI State
- Navigation
- User Interaction

The Presentation layer contains no business rules.

Business logic must always be delegated to Use Cases or the Memorization Engine.

---

## Domain Layer

Responsibilities

- Entities
- Value Objects
- Repository Contracts
- Use Cases
- Business Rules

Rules

- Pure Dart only.
- No Flutter imports.
- No Supabase imports.
- No Isar imports.
- No BuildContext.
- No UI dependencies.

The Domain layer represents the source of business truth.

---

## Data Layer

Responsibilities

- Repository Implementations
- Local Data Sources
- Remote Data Sources
- Models
- DTO Mapping

The Data layer implements the repository contracts defined in the Domain layer.

---

# 20. Project Structure

The project follows Feature-First organization.

```text
lib/

core/

features/

auth/

quran/

memorization_engine/

adult_journey/

kids_journey/

parent_dashboard/

progress/

azkar/

settings/
```

Each feature contains:

```text
presentation/

domain/

data/
```

Shared code belongs only inside the `core` directory.

No feature may directly access another feature's internal implementation.

---

# 21. State Management

The project uses:

Flutter Bloc

Cubit only

No alternative state management solution is used.

---

## Cubit Responsibilities

Cubits coordinate the user interface.

Cubits:

- receive user events
- execute use cases
- emit UI states

Cubits never contain business rules.

---

## Cubit Lifecycle

Every Cubit is responsible for cleaning allocated resources.

This includes:

- Stream subscriptions
- Audio players
- Speech recognition
- Timers

All resources must be released inside `close()`.

---

# 22. Dependency Injection

Dependency Injection is implemented using GetIt.

Registration is performed manually.

No code generation is used.

Every dependency is registered from a single composition root.

---

## Registration Order

Configuration

↓

Core Services

↓

Data Sources

↓

Repositories

↓

Use Cases

↓

Cubits

Dependencies are registered only once.

---

# 23. Navigation

Navigation is implemented using GoRouter.

---

## Public Routes

Accessible without authentication.

Examples

- Splash
- Login
- Register
- Quran Reader

---

## Protected Routes

Require authentication.

Examples

- Memorization
- Dashboard
- Progress
- Parent Dashboard
- Settings

Unauthorized users are redirected before entering protected areas.

---

# 24. Local Database

The local database is implemented using Isar.

Isar is the primary runtime database.

---

## Responsibilities

Store:

- Memorization Records
- Review Records
- Session State
- Progress
- Bookmarks
- Settings

All user progress is written locally before synchronization.

---

## Local Rules

Reading operations should use local storage whenever possible.

The application should remain fully usable without internet.

---

# 25. Cloud Backend

Supabase provides cloud services.

Responsibilities

- Authentication
- User Profiles
- Cloud Synchronization
- Parent Data
- File Storage

Supabase is not treated as the runtime source of truth.

---

## Synchronization Principles

Synchronization operates independently from the user interface.

The user should never wait for cloud operations to finish.

Synchronization failures never delete local progress.

---

# 26. Security

Authentication is required before accessing memorization features.

Guest Mode is restricted to Quran reading.

Protected data is available only to its owner.

Parent access is limited to linked child accounts.

All cloud access follows Row Level Security policies.

---

# 27. Error Handling

Every operation returns a predictable result.

Unexpected failures should:

- preserve user progress
- display meaningful feedback
- allow retry when possible

Application crashes must never corrupt memorization records.

---

# 28. Logging

Logging exists only for debugging and diagnostics.

Logs must never expose:

- passwords
- authentication tokens
- personal user data
- private memorization content

Production logging should remain minimal.

# 29. Coding Standards

The following standards apply to the entire project.

Every contributor must follow these rules.

---

## General Principles

- Write readable code before clever code.
- Prefer composition over inheritance.
- Keep classes focused on a single responsibility.
- Avoid unnecessary abstractions.
- Prefer immutable objects whenever possible.

---

## Naming Conventions

### Classes

Use PascalCase.

Examples

- MemorizationSession
- ReviewEngine
- SessionRepository

---

### Variables

Use camelCase.

Examples

- currentSession
- reviewDate
- memorizedAyahs

---

### Methods

Method names should describe actions.

Examples

- startSession()
- completeReview()
- scheduleNextReview()

Avoid ambiguous names.

Examples

- doTask()
- process()
- execute()

unless the meaning is obvious from the context.

---

### Files

Use snake_case.

Examples

memorization_session.dart

review_engine.dart

session_repository.dart

---

### Widgets

Widgets should end with:

Page

Screen

Card

Tile

Dialog

Button

Section

Examples

HomePage

ReviewCard

SessionDialog

---

### Cubits

Cubit names always end with Cubit.

Examples

HomeCubit

ReviewCubit

SettingsCubit

---

### States

State classes always end with State.

Examples

HomeState

ReviewState

LoginState

---

### Repositories

Repository interfaces belong to Domain.

Repository implementations belong to Data.

Naming

SessionRepository

SessionRepositoryImpl

---

# 30. Feature Development Rules

Every feature follows the same implementation order.

1. Requirements

↓

2. Domain

↓

3. Data

↓

4. Presentation

↓

5. Testing

↓

6. Integration

A feature is never started from the UI.

Business logic must exist before presentation.

---

## Feature Structure

Every feature contains:

presentation/

domain/

data/

If a feature does not require one of these layers, the folder still exists for consistency.

---

## Shared Code

Shared utilities belong only inside core.

Feature-specific utilities remain inside their owning feature.

No feature may become a dumping ground for unrelated utilities.

---

# 31. Testing Strategy

Testing is mandatory.

Every business rule should be verifiable through automated tests.

---

## Test Levels

Unit Tests

Widget Tests

Integration Tests

---

## Unit Tests

Unit tests validate:

- Use Cases
- Session Engine
- Review Engine
- Smart Coach
- Repository Logic

No Flutter dependency should exist inside Unit Tests.

---

## Widget Tests

Widget tests validate:

- UI Rendering
- User Interaction
- State Changes

Business rules should not be duplicated inside Widget Tests.

---

## Integration Tests

Integration tests validate:

- Authentication Flow
- Memorization Flow
- Review Flow
- Synchronization
- Parent Dashboard

---

## Test Requirements

A feature is not complete until its critical behavior is covered by tests.

---

# 32. Definition of Done

A task is considered complete only when all of the following conditions are satisfied.

- Code implemented.
- Code reviewed.
- No critical issues.
- Tests pass.
- Documentation updated.
- Feature integrated.
- Offline behavior verified.
- Synchronization verified.
- Acceptance criteria satisfied.

Incomplete work must never be marked as finished.

---

# 33. Development Roadmap

Development follows a dependency-first approach.

No phase begins before its prerequisites are complete.

---

## Phase 0

Foundation

Deliverables

- Project Setup
- Dependency Injection
- Routing
- Theme
- Localization
- Logging
- Error Handling
- Feature Flags

---

## Phase 1

Authentication

Deliverables

- Splash
- Onboarding
- Login
- Registration
- Guest Mode
- Route Protection

---

## Phase 2

Quran Reader

Deliverables

- Mushaf
- Audio
- Search
- Bookmarks
- Reading Progress

---

## Phase 3

Memorization Engine

Deliverables

- Session Engine
- Learning
- Memorizing
- Reciting
- Remediation
- Block Review
- Completion

---

## Phase 4

Adult Journey

Deliverables

- Home Dashboard
- Smart Coach
- Daily Plan
- Continue Session
- Weak Ayahs

---

## Phase 5

Kids Journey

Deliverables

- World Map
- Missions
- Rewards
- Levels
- Progress

---

## Phase 6

Progress

Deliverables

- Statistics
- Heatmap
- Streak
- Achievements
- Certificates

---

## Phase 7

Parent Dashboard

Deliverables

- Child Linking
- Progress
- Reports
- Certificates

---

## Phase 8

Synchronization

Deliverables

- Background Sync
- Retry Queue
- Conflict Handling
- Offline Recovery

---

## Phase 9

Production

Deliverables

- Performance
- Security
- Release Build
- Store Assets
- Final Testing

# 34. Current Sprint

The Current Sprint section always represents the work that is actively being developed.

Only one sprint may be active at a time.

Completed work is moved to the Changelog.

Future work remains in the Roadmap.

---

## Active Sprint

Phase 0 — Foundation

### Objectives

- Create project structure.
- Configure dependencies.
- Configure routing.
- Configure localization.
- Configure themes.
- Configure dependency injection.
- Configure logging.
- Configure error handling.

---

## Sprint Deliverables

The sprint is complete when:

- The application launches successfully.
- Navigation works.
- Localization works.
- Theme switching works.
- Dependency Injection is configured.
- Build succeeds without errors.

---

# 35. Acceptance Criteria

Acceptance Criteria define the expected behavior of every feature.

A feature is complete only when every acceptance criterion is satisfied.

---

## Authentication

The user can:

- Register.
- Login.
- Logout.
- Restore previous session.
- Continue as Guest.

Protected routes remain inaccessible without authentication.

---

## Quran Reader

The user can:

- Open any Surah.
- Navigate pages.
- Listen to recitation.
- Save bookmarks.
- Resume reading.

The reader functions without internet after required local resources are available.

---

## Memorization

The user can:

- Start a session.
- Complete a session.
- Resume interrupted sessions.
- Finish block reviews.
- Receive review scheduling.

Progress is saved automatically.

---

## Smart Coach

The Smart Coach always recommends the highest priority action.

Recommendations update after every completed session.

---

## Progress

Statistics accurately reflect memorization history.

Progress updates automatically after successful sessions.

---

## Parent Dashboard

Parents view only linked child accounts.

Progress displayed matches synchronized memorization records.

---

# 36. Performance Requirements

The application should remain responsive during normal use.

The interface should not block while waiting for synchronization.

Heavy processing should execute outside the UI thread whenever practical.

Large lists should support efficient rendering.

The application should avoid unnecessary database reads.

---

# 37. Accessibility

The application should remain usable for a wide range of users.

Requirements

- Support large font sizes.
- Maintain sufficient visual contrast.
- Provide clear navigation.
- Use descriptive labels.
- Avoid relying only on color to communicate information.

---

# 38. Localization

The application supports multiple languages.

Initial languages

- Arabic
- English

All user-facing text must be localized.

No hardcoded interface text is permitted.

---

# 39. Configuration

Environment-specific values must remain outside business logic.

Configuration includes:

- API URLs
- Feature Flags
- Build Flavor Settings
- Debug Options

Business rules must never depend directly on environment configuration.

---

# 40. Versioning

Every production release increments the application version.

Documentation should record significant architectural or product changes.

---

# 41. Changelog

This section records completed work.

Entries are appended in chronological order.

Each entry includes:

- Date
- Version
- Summary

---

# 42. Open Decisions

This section contains decisions intentionally left unresolved.

Only unresolved items belong here.

Once a decision is finalized, it is moved into the appropriate section of this document and removed from Open Decisions.

At the time of writing, no unresolved decisions have been intentionally documented from the source documents.

---

# 43. Document Governance

PROJECT.md is the authoritative project document.

All development decisions must be reflected here.

No additional PRD, SOP, Technical Guide, or Architecture document should become the primary reference while this document is maintained.

When requirements change:

1. Update PROJECT.md.
2. Update implementation.
3. Update tests.

Documentation and implementation should remain synchronized.

---

# 44. Final Principles

The project follows these principles throughout its lifecycle:

- Offline First.
- Local First.
- Clean Architecture.
- Feature-First Organization.
- Separation of Concerns.
- Testable Business Logic.
- Predictable State Management.
- Incremental Development.
- Production Readiness.

Every architectural or product decision should reinforce these principles.

---

# End of Document

