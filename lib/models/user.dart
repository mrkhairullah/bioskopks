class User {
  final int? id;
  final String name;
  final String email;
  final String password;
  String? createdAt;
  String? updatedAt;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
      'created_at': createdAt ?? DateTime.now().toIso8601String(),
      'updated_at': updatedAt ?? DateTime.now().toIso8601String(),
    };
    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }
}
