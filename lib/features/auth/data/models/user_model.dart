import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.displayName,
    super.role,
    required super.createdAt,
  });

  factory UserModel.fromSupabaseUser(supabase.User user) {
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      displayName: user.userMetadata?['display_name'] as String?,
      role: UserRole.registered,
      createdAt: DateTime.parse(user.createdAt),
    );
  }

  factory UserModel.fromJson(DataMap json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['display_name'] as String?,
      role: UserRole.values.firstWhere(
        (r) => r.name == (json['role'] as String? ?? 'registered'),
        orElse: () => UserRole.registered,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  DataMap toJson() {
    return {
      'id': id,
      'email': email,
      'display_name': displayName,
      'role': role.name,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
