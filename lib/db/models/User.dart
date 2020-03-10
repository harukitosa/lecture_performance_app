class User {

  final int id;
  final String name;
  final String password;
  final String email;
  final String createTime;
  String updateTime;
  String deleteTime;

  User({
    this.id,
    this.name,
    this.password,
    this.email,
    this.createTime,
    this.updateTime,
    this.deleteTime,
  });

  factory User.fromMap(Map<String, dynamic> json) => new User(
      id: json["id"],
      name: json["name"],
      password: json["password"],
      email: json["email"],
      createTime: json["createTime"],
      updateTime: json["updateTime"],
      deleteTime: json["deleteTime"],
  );

  Map<String, dynamic> toMapNew() {
    return {
      'name': name,
      'password': password,
      'email': email,
      'createTime': createTime,
      'updateTime': updateTime,
      'delteTime': deleteTime,
    };
  }
}