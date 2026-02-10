import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/signup_controller.dart';
import '../models/ministry.dart';
import '../models/sector.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  List<Ministry> _ministries = [];
  List<Sector> _sectors = [];
  Ministry? _selectedMinistry;
  Sector? _selectedSector;

  final SignupController _signupController = SignupController();

  @override
  void initState() {
    super.initState();
    _loadMinistryAndSector();
  }

  Future<void> _loadMinistryAndSector() async {
    final ministries = await _signupController.getMinistries();
    final sectors = await _signupController.getSectors();
    setState(() {
      _ministries = (ministries).cast<Ministry>();
      _sectors = (sectors).cast<Sector>();
    });
  }

  void _handleSignUp() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    _signupController.handleSignUp(
      context: context,
      username: _usernameController.text.trim(),
      password: _passwordController.text,
      ministryId: _selectedMinistry?.ministryId,
      sectorId: _selectedSector?.sectorId,
      onError: (message) {
        setState(() {
          _isLoading = false;
          _errorMessage = message;
        });
      },
      onSuccess: () {
        setState(() {
          _isLoading = false;
        });
        _usernameController.clear();
        _passwordController.clear();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.data_usage, size: 50, color: Colors.blue),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        'CivicData Core',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Sign Up Here',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    hintText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                  style: GoogleFonts.jetBrainsMono(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  style: GoogleFonts.jetBrainsMono(),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<Ministry>(
                  value: _selectedMinistry,
                  hint: Text(
                    'Select Ministry',
                    style: GoogleFonts.jetBrainsMono(),
                  ),
                  items: _ministries
                      .map((ministry) => DropdownMenuItem(
                            value: ministry,
                            child: Text(
                              ministry.ministryName,
                              style: GoogleFonts.jetBrainsMono(),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedMinistry = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<Sector>(
                  value: _selectedSector,
                  hint: Text(
                    'Select Sector',
                    style: GoogleFonts.jetBrainsMono(),
                  ),
                  items: _sectors
                      .map((sector) => DropdownMenuItem(
                            value: sector,
                            child: Text(
                              sector.sectorName,
                              style: GoogleFonts.jetBrainsMono(),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSector = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    style: GoogleFonts.jetBrainsMono(color: Colors.red),
                  ),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSignUp,
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Sign Up',
                            style: GoogleFonts.jetBrainsMono(fontSize: 16),
                          ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Already have an account? Sign In',
                    style: GoogleFonts.jetBrainsMono(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
