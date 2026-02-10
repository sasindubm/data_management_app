import 'package:data_management_app/models/user.dart';

import '../repositories/user_repository.dart';
import '../utils/crypto_helper.dart';

class LoginController {
  final UserRepository _userRepo = UserRepository();

  Future<User?> login(String username, String password) async {
    final user = await _userRepo.getUserByUsername(username);
    if (user == null) return null;

    final hashedInput = CryptoHelper.hashPassword(password);
    if (user.password != hashedInput) return null;

    return user; // Login successful
  }
}
