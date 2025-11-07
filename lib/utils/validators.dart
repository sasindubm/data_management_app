class Validators {
  static String? validateUsername(String username) {
    if (username.isEmpty) return 'Username cannot be empty.';
    if (username.length < 3) return 'Username must be at least 3 characters.';
    if (username.length > 20) return 'Username must be less than 20 characters.';
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) return 'Password cannot be empty.';
    if (password.length < 6) return 'Password must be at least 6 characters.';
    return null;
  }

  static String? validateProjectName(String name) {
    if (name.isEmpty) return 'Project name cannot be empty.';
    if (name.length < 3) return 'Project name must be at least 3 characters.';
    if (name.length > 50) return 'Project name must be less than 50 characters.';
    return null;
  }

  static String? validateProjectTitle(String title) {
    if (title.isEmpty) return 'Project title cannot be empty.';
    if (title.length < 3) return 'Project title must be at least 3 characters.';
    if (title.length > 100) return 'Project title must be less than 100 characters.';
    return null;
  }

  static String? validateProjectDescription(String description) {
    if (description.isEmpty) return 'Project description cannot be empty.';
    if (description.length < 10) return 'Project description must be at least 10 characters.';
    if (description.length > 500) return 'Project description must be less than 500 characters.';
    return null;
  }

  static String? validateProjectStatus(String status) {
    const validStatuses = ['Not Started', 'In Progress', 'Completed', 'On Hold'];
    if (!validStatuses.contains(status)) return 'Invalid project status.';
    return null;
  }

  static String? validateSectorId(int sectorId) {
    if (sectorId <= 0) return 'Invalid sector ID.';
    return null;
  }

  static String? validateUserId(int userId) {
    if (userId <= 0) return 'Invalid user ID.';
    return null;
  }

  static String? validateStartedDate(DateTime startedDate) {
    if (startedDate.isAfter(DateTime.now())) return 'Started date cannot be in the future.';
    return null;
  }

  static String? validateFinishedDate(DateTime? finishedDate, DateTime startedDate) {
    if (finishedDate != null && finishedDate.isBefore(startedDate)) {
      return 'Finished date cannot be before started date.';
    }
    return null;
  }

  
}
