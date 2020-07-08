import 'package:lecture_performance_app/repositories/user_repository.dart';
import '../db/models/User.dart';

class UserService {
  UserService(this.userRepository);

  final IUserRepository userRepository;

  Future<int> createUser(String name, String password, String email) async {
    final user = User(name: name, password: password, email: email);
    final id = await userRepository.insertUser(user);
    return id;
  }

  Future<User> getUserData(int id) async {
    return userRepository.getUser(id);
  }
}
