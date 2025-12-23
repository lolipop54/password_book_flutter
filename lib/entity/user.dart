class User {
  final int? id;
  final String username;
  final String passwordHash;
  final String salt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    this.id,
    required this.salt,
    required this.username,
    required this.passwordHash,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'salt': salt,
      'password_hash': passwordHash,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      salt: map['salt'],
      passwordHash: map['password_hash'],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : null,
    );
  }

  User copyWith({
    int? id,
    String? username,
    String? passwordHash,
    String? salt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      salt: salt ?? this.salt,
      passwordHash: passwordHash ?? this.passwordHash,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
