class User {

  User({
    this.id,
    required this.username,
    required this.password,
  });

  // Create User from Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
    );
  }
  final int? id;
  final String username;
  final String password;

  // Convert User to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
    };
  }
}
