class User {
  User({
    this.id,
    this.name,
    this.password,
    this.email,
    this.createTime,
    this.updateTime,
  });
  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json['id'] as int,
        name: json['name'] as String,
        password: json['password'] as String,
        email: json['email'] as String,
        createTime: json['created_at'] as String,
        updateTime: json['updated_at'] as String,
      );
  final int id;
  final String name;
  final String password;
  final String email;
  final String createTime;
  String updateTime;

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
