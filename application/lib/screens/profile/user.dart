import 'dart:convert';

class User {
  final String imagePath;
  final String name;
  final String email;
  final String about;
  User({
    required this.imagePath,
    required this.name,
    required this.email,
    required this.about,
  });

  User copyWith({
    String? imagePath,
    String? name,
    String? email,
    String? about,
  }) {
    return User(
      imagePath: imagePath ?? this.imagePath,
      name: name ?? this.name,
      email: email ?? this.email,
      about: about ?? this.about,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imagePath': imagePath,
      'name': name,
      'email': email,
      'about': about,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      imagePath: map['imagePath'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      about: map['about'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(imagePath: $imagePath, name: $name, email: $email, about: $about)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is User &&
      other.imagePath == imagePath &&
      other.name == name &&
      other.email == email &&
      other.about == about;
  }

  @override
  int get hashCode {
    return imagePath.hashCode ^
      name.hashCode ^
      email.hashCode ^
      about.hashCode;
  }
}
