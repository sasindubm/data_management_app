import 'package:flutter/material.dart';
import '../services/auth_services.dart';
import '../utils/validators.dart';
import '../widgets/dialogs.dart';
import '../repositories/ministry_repository.dart';
import '../repositories/sector_repository.dart';

class SignupController {
  final AuthService _authService = AuthService();
  final MinistryRepository _ministryRepo = MinistryRepository();
  final SectorRepository _sectorRepo = SectorRepository();

  Future<void> handleSignUp({
    required BuildContext context,
    required String username,
    required String password,
    required int? ministryId,
    required int? sectorId,
    required Function(String?) onError,
    required Function() onSuccess,
  }) async {
    final usernameError = Validators.validateUsername(username);
    final passwordError = Validators.validatePassword(password);

    if (usernameError != null || passwordError != null) {
      onError(usernameError ?? passwordError);
      return;
    }

    final result = await _authService.registerUser(
      username,
      password,
      ministryId: ministryId,
      sectorId: sectorId,
    );

    if (result == null) {
      onSuccess();
      showSuccessDialog(context, 'Account created successfully!');
    } else {
      onError(result);
    }
  }

  Future<List<dynamic>> getMinistries() async {
    return await _ministryRepo.getAllMinistries();
  }

  Future<List<dynamic>> getSectors() async {
    return await _sectorRepo.getAllSectors();
  }
}
