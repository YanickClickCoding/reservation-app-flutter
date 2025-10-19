class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final DateTime memberSince;
  final List<String>? preferences;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatarUrl,
    required this.memberSince,
    this.preferences,
  });

  // Convertir un User en Map pour le stockage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'memberSince': memberSince.toIso8601String(),
      'preferences': preferences,
    };
  }

  // Créer un User à partir d'un Map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      avatarUrl: json['avatarUrl'],
      memberSince: DateTime.parse(json['memberSince']),
      preferences: json['preferences'] != null
          ? List<String>.from(json['preferences'])
          : null,
    );
  }

  // Créer une copie de l'utilisateur avec des valeurs modifiées
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    DateTime? memberSince,
    List<String>? preferences,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      memberSince: memberSince ?? this.memberSince,
      preferences: preferences ?? this.preferences,
    );
  }
}
