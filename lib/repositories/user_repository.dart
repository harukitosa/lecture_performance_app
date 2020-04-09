import 'dart:async';
import 'package:lecture_performance_app/db/models/User.dart';

abstract class IUserRepository {
  Future<int> insertUser(User user);
  Future<User> getUser(int id);
  Future<List<User>> getAllUsers();
  Future<void> deleteUser(int id);
  Future<void> updateUser(User user);
}
