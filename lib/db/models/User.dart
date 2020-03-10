class User {

  final int id;
  final String name;
  final String password;
  final String email;
  final String createTime;
  String updateTime;

  User({
    this.id,
    this.name,
    this.password,
    this.email,
    this.createTime,
    this.updateTime,
  });

  factory User.fromMap(Map<String, dynamic> json) => new User(
      id: json["id"],
      name: json["name"],
      password: json["password"],
      email: json["email"],
      createTime: json["created_at"],
      updateTime: json["updated_at"],
  );

  Map<String, dynamic> toMapNew() {
    return {
      'name': name,
      'password': password,
      'email': email,
      'created_at': createTime,
      'updated_at': updateTime,
    };
  }
}