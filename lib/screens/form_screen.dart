import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/response_controller.dart';
import '../models/form.dart' as form_model;
import 'response_collection_screen.dart';
import 'edit_form_screen.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  late ResponseController _responseController;
  List<form_model.Form> _forms = [];
  Map<int, int> _responseCountMap = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _responseController = ResponseController();
    _loadForms();
  }

  Future<void> _loadForms() async {
    try {
      final forms = await _responseController.getAllForms();
      final countMap = <int, int>{};

      // Get response count for each form
      for (final form in forms) {
        final count =
            await _responseController.getResponseCountForForm(form.formId ?? 0);
        countMap[form.formId ?? 0] = count;
      }

      if (mounted) {
        setState(() {
          _forms = forms;
          _responseCountMap = countMap;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading forms: $e')),
        );
      }
    }
  }

  Future<void> _deleteForm(int formId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Form?'),
        content: Text('This will delete the form and all its questions.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm ?? false) {
      if (!mounted) return;

      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Deleting...'),
            ],
          ),
        ),
      );

      final success = await _responseController.deleteForm(formId);

      if (mounted) {
        Navigator.pop(context); // Close loading dialog

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Form deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          _loadForms();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete form'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Forms',
          style: GoogleFonts.jetBrainsMono(fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _forms.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.note_outlined,
                          size: 64, color: Colors.grey[400]),
                      SizedBox(height: 16),
                      Text(
                        'No forms created yet',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/new-form'),
                        child: Text('Create New Form'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadForms,
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: _forms.length,
                    itemBuilder: (context, index) {
                      final form = _forms[index];
                      final responseCount =
                          _responseCountMap[form.formId ?? 0] ?? 0;

                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Form #${form.formId}',
                                          style: GoogleFonts.jetBrainsMono(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Project #${form.projectId}',
                                          style: GoogleFonts.jetBrainsMono(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[50],
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          '$responseCount responses',
                                          style: GoogleFonts.jetBrainsMono(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue[900],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Divider(),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ResponseCollectionScreen(
                                            formId: form.formId ?? 0,
                                            userId: null,
                                          ),
                                        ),
                                      ).then((_) => _loadForms());
                                    },
                                    icon: Icon(Icons.add_circle_outline),
                                    label: Text('Responses'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditFormScreen(
                                            formId: form.formId ?? 0,
                                          ),
                                        ),
                                      ).then((_) => _loadForms());
                                    },
                                    icon: Icon(Icons.edit),
                                    label: Text('Edit'),
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        _deleteForm(form.formId ?? 0),
                                    icon: Icon(Icons.delete),
                                    color: Colors.red,
                                    tooltip: 'Delete form',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
