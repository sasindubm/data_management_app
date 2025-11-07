import '../models/user.dart';
import '../repositories/user_repository.dart';
import '../utils/crypto_helper.dart';

class AuthService {
  final UserRepository _userRepo = UserRepository();

  Future<String?> registerUser(String username, String password) async {
    final exists = await _userRepo.usernameExists(username);
    if (exists) return 'Username already exists.';

    final hashedPassword = CryptoHelper.hashPassword(password);
    final user = User(username: username, password: hashedPassword);
    final userId = await _userRepo.insertUser(user);

    return userId > 0 ? null : 'Failed to create account.';
  }

  Future<User?> loginUser(String username, String password) async {
    final user = await _userRepo.getUserByUsername(username);
    if (user == null) return null;

    final hashedPassword = CryptoHelper.hashPassword(password);
    if (user.password == hashedPassword) {
      return user;
    }
    return null;
  }

  Future<bool> changePassword(int userId, String oldPassword, String newPassword) async {
    final user = await _userRepo.getUserById(userId);
    if (user == null) return false;

    final hashedOldPassword = CryptoHelper.hashPassword(oldPassword);
    if (user.password != hashedOldPassword) return false;

    final hashedNewPassword = CryptoHelper.hashPassword(newPassword);
    final updatedUser = User(
      userId: user.userId,
      username: user.username,
      password: hashedNewPassword,
    );

    final rowsAffected = await _userRepo.updateUser(updatedUser);
    return rowsAffected > 0;
  }


}
