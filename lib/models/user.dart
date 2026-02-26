import 'package:uuid/uuid.dart';

enum UserTheme { male, female }

class User {
  final String id;
  final String name;
  final UserTheme theme;
  final String? pairingCode;
  final String? partnerId;
  final String? avatar;
  final DateTime createdAt;

  User({
    String? id,
    required this.name,
    required this.theme,
    this.pairingCode,
    this.partnerId,
    this.avatar,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  // Copy with
  User copyWith({
    String? id,
    String? name,
    UserTheme? theme,
    String? pairingCode,
    String? partnerId,
    String? avatar,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      theme: theme ?? this.theme,
      pairingCode: pairingCode ?? this.pairingCode,
      partnerId: partnerId ?? this.partnerId,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'theme': theme.name,
      'pairingCode': pairingCode,
      'partnerId': partnerId,
      'avatar': avatar,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // From JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      theme: UserTheme.values.byName(json['theme'] as String),
      pairingCode: json['pairingCode'] as String?,
      partnerId: json['partnerId'] as String?,
      avatar: json['avatar'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  String toString() => 'User(id: $id, name: $name, theme: $theme)';
}
