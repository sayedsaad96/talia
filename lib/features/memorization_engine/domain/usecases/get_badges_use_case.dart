import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/memorization_engine/domain/entities/badge_entity.dart';
import 'package:talia/features/memorization_engine/domain/repositories/review_repository.dart';

class GetBadgesUseCase {
  final ReviewRepository _reviewRepository;
  const GetBadgesUseCase(this._reviewRepository);

  ResultFuture<List<BadgeEntity>> call(String userId) =>
      _reviewRepository.getBadges(userId);
}
