import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/project_controller.dart';
import '../models/project.dart';

class NewProjectScreen extends StatefulWidget {
  const NewProjectScreen({super.key});
  @override
  State<NewProjectScreen> createState() => _NewProjectScreenState();
}

class _NewProjectScreenState extends State<NewProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _projectLocationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  String? _selectedMinistry;
  String? _selectedFundSource;
  String? _selectedStatus;
  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    _projectLocationController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(title: const Text('New Project')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create a new Project here!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _projectNameController,
                          decoration: const InputDecoration(
                            labelText: 'Project Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a project name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _projectLocationController,
                          decoration: const InputDecoration(
                            labelText: 'Project Location',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a project location';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 4,
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: DropdownMenu(
                            dropdownMenuEntries: const [
                              DropdownMenuEntry(
                                  value: '1', label: 'Chief Ministry'),
                              DropdownMenuEntry(
                                  value: '2', label: 'Agricultural Ministry'),
                              DropdownMenuEntry(
                                  value: '3', label: 'Fishery Ministry'),
                              DropdownMenuEntry(
                                  value: '4', label: 'Sports Ministry'),
                              DropdownMenuEntry(
                                  value: '5', label: 'Education Ministry'),
                            ],
                            label: const Text('Ministry'),
                            textAlign: TextAlign.start,
                            onSelected: (value) {
                              setState(() {
                                _selectedMinistry = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: DropdownMenu(
                            dropdownMenuEntries: const [
                              DropdownMenuEntry(value: 'cbg', label: 'CBG'),
                              DropdownMenuEntry(value: 'psdg', label: 'PSDG'),
                              DropdownMenuEntry(
                                  value: 'maintainance', label: 'Maintainance'),
                            ],
                            label: const Text('Fund Source'),
                            textAlign: TextAlign.start,
                            onSelected: (value) {
                              setState(() {
                                _selectedFundSource = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: DropdownMenu(
                            dropdownMenuEntries: const [
                              DropdownMenuEntry(
                                  value: 'new', label: 'New Project'),
                              DropdownMenuEntry(
                                  value: 'canceled', label: 'Canceled Project'),
                              DropdownMenuEntry(
                                  value: 'completed',
                                  label: 'Completed Project'),
                            ],
                            label: const Text('Project Status'),
                            textAlign: TextAlign.start,
                            onSelected: (value) {
                              setState(() {
                                _selectedStatus = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _startDateController,
                          decoration: const InputDecoration(
                            labelText: 'Started Date',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          readOnly: true,
                          onTap: () =>
                              _selectDate(context, _startDateController),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a start date';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _endDateController,
                          decoration: const InputDecoration(
                            labelText: 'Finished Date',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                            helperText: 'Leave empty for New Projects',
                          ),
                          readOnly: true,
                          onTap: () => _selectDate(context, _endDateController),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final newProject = Project(
                                projectName: _projectNameController.text,
                                projectLocation: _projectLocationController.text,
                                projectDescription: _descriptionController.text,
                                projectStatus: _selectedStatus ?? 'new',
                                ministryId: int.parse(_selectedMinistry ?? '1'),
                                fundSource: _selectedFundSource ?? 'cbg',
                                userId: userId,
                                startedDate:
                                    DateTime.parse(_startDateController.text),
                                finishedDate: _endDateController.text.isNotEmpty
                                    ? DateTime.parse(_endDateController.text)
                                    : null,
                              );
                              final controller = ProjectController();
                              await controller.createProject(newProject);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Project Created Successfully')),
                              );
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Create Project'),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
