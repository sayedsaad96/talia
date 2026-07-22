import 'package:equatable/equatable.dart';

enum UserRole { guest, registered, child, parent }

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final UserRole role;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.role = UserRole.registered,
    required this.createdAt,
  });

  /// Creates a guest user instance (no real account).
  static UserEntity guest() => UserEntity(
        id: 'guest',
        email: '',
        role: UserRole.guest,
        createdAt: DateTime.fromMillisecondsSinceEpoch(0),
      );

  bool get isGuest => role == UserRole.guest;
  bool get isRegistered => role == UserRole.registered;
  bool get isChild => role == UserRole.child;
  bool get isParent => role == UserRole.parent;

  @override
  List<Object?> get props => [id, email, displayName, role, createdAt];
}
