import 'package:lecture_performance_app/repositories/user_repository.dart';
import '../db/models/User.dart';

class UserService {
  final IUserRepository userRepository;
  UserService(this.userRepository);

  Future<int> createUser(String name, String password, String email) async {
    var user = new User(name: name, password: password, email: email);
    var id = await userRepository.insertUser(user);
    return id;
  }

  Future<User> getUserData(int id) async {
    return userRepository.getUser(id);
  }
}
