import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'login_screen.dart';
import '../widgets/wifi_status_icon.dart';
import '../repositories/project_repository.dart';
import '../repositories/form_repository.dart';
import '../repositories/response_repository.dart';
import '../repositories/user_repository.dart';
import '../repositories/ministry_repository.dart';
import '../repositories/sector_repository.dart';
import '../models/form.dart' as form_model;
import '../models/response.dart';

class HomeScreen extends StatefulWidget {
  final int userId;
  final String username;
  const HomeScreen({super.key, required this.userId, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Map<String, dynamic>> _cards;
  late ProjectRepository _projectRepo;
  late FormRepository _formRepo;
  late ResponseRepository _responseRepo;
  late UserRepository _userRepo;
  late MinistryRepository _ministryRepo;
  late SectorRepository _sectorRepo;

  List<form_model.Form> _recentForms = [];
  List<Response> _pendingUploads = [];
  String _ministryName = '';
  String _sectorName = '';

  String get username => widget.username;

  @override
  void initState() {
    super.initState();
    _projectRepo = ProjectRepository();
    _formRepo = FormRepository();
    _responseRepo = ResponseRepository();
    _userRepo = UserRepository();
    _ministryRepo = MinistryRepository();
    _sectorRepo = SectorRepository();

    _cards = [
      {
        'icon': Icons.folder,
        'label': 'Total Projects',
        'count': 0,
        'onclick': () {
          Navigator.pushNamed(context, '/project', arguments: widget.userId);
        }
      },
      {
        'icon': Icons.file_copy,
        'label': 'Total Forms',
        'count': 0,
        'onclick': () {
          Navigator.pushNamed(context, '/form');
        }
      },
      {
        'icon': Icons.bar_chart,
        'label': 'Total Responses',
        'count': 0,
        'onclick': () {
          Navigator.pushNamed(context, '/res');
        }
      },
      {
        'icon': Icons.drafts,
        'label': 'Drafts',
        'count': 0,
        'onclick': () {
          Navigator.pushNamed(context, '/draft');
        }
      },
    ];
    _loadDashboardData();
  }

  void updateCardCount(String label, int count) {
    setState(() {
      final index = _cards.indexWhere((card) => card['label'] == label);
      if (index != -1) {
        _cards[index]['count'] = count;
      }
    });
  }

  Future<void> _loadDashboardData() async {
    try {
      // Load user info to get ministry and sector
      final user = await _userRepo.getUserById(widget.userId);
      if (user != null) {
        if (user.ministryId != null) {
          final ministry =
              await _ministryRepo.getMinistryById(user.ministryId!);
          if (ministry != null) {
            setState(() {
              _ministryName = ministry.ministryName;
            });
          }
        }
        if (user.sectorId != null) {
          final sector = await _sectorRepo.getSectorById(user.sectorId!);
          if (sector != null) {
            setState(() {
              _sectorName = sector.sectorName;
            });
          }
        }
      }

      // Load projects and update card count
      final projects = await _projectRepo.getProjectsByUserId(widget.userId);
      updateCardCount('Total Projects', projects.length);

      // Load all forms and update card count
      final forms = await _formRepo.getAllForms();
      updateCardCount('Total Forms', forms.length);

      // Load recent forms (limit to 3)
      setState(() {
        _recentForms = forms.take(3).toList();
      });

      // Load responses and update card count
      final responses = await _responseRepo.getAllResponses();
      updateCardCount('Total Responses', responses.length);

      // Load pending uploads (responses by user)
      final userResponses =
          await _responseRepo.getResponsesByUserId(widget.userId);
      setState(() {
        _pendingUploads = userResponses.take(3).toList();
      });
    } catch (e) {
      debugPrint('Error loading dashboard data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        children: [
          SpeedDialChild(
            child: Icon(Icons.description),
            label: 'Create Form',
            onTap: () {
              Navigator.pushNamed(context, '/new-form');
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.work),
            label: 'Create Project',
            onTap: () {
              Navigator.pushNamed(context, '/new-project',
                  arguments: widget.userId);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.data_usage, size: 30, color: Colors.blue),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'CivicData Core',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  WifiStatusIcon(),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () async {
                      final selected = await showMenu<String>(
                        context: context,
                        position: RelativeRect.fromLTRB(
                            1000, 80, 0, 0), // Adjust position as needed
                        items: [
                          const PopupMenuItem<String>(
                            value: 'login',
                            child: Text('Logout'),
                          ),
                        ],
                      );

                      if (selected == 'login') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      }
                    },
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blueGrey,
                      child: Icon(Icons.person, size: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, ${widget.username}!',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_ministryName.isNotEmpty)
                      Text(
                        'Ministry: $_ministryName',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    if (_sectorName.isNotEmpty)
                      Text(
                        'Sector: $_sectorName',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: _cards.map((card) {
                  return InkWell(
                    onTap: card['onclick'] as VoidCallback,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(card['icon'], size: 20, color: Colors.blue),
                            const SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                '${card['label']} (${card['count']})',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: card['count'] == 0
                                      ? Colors.red
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Recent Forms',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (_recentForms.isEmpty)
                              Center(
                                child: Text(
                                  'No forms available',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            else
                              ..._recentForms.map((form) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Form #${form.formId}\nProject #${form.projectId}',
                                              style: GoogleFonts.jetBrainsMono(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Icon(
                                            Icons.play_arrow,
                                            size: 30,
                                            color: Colors.green,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pending Uploads',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (_pendingUploads.isEmpty)
                              Center(
                                child: Text(
                                  'No pending uploads',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            else
                              ..._pendingUploads.map((response) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Response #${response.responseId}\nForm #${response.formId}',
                                              style: GoogleFonts.jetBrainsMono(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            response.responseStatus ??
                                                'Pending',
                                            style: GoogleFonts.jetBrainsMono(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Icon(
                                            Icons.upload,
                                            size: 30,
                                            color: Colors.red,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
