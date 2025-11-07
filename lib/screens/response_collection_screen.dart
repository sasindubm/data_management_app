import 'package:flutter/material.dart';
import 'newform_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class ResponseCollectionScreen extends StatefulWidget {
  final CreatedForm form;

  const ResponseCollectionScreen({
    super.key,
    required this.form,
  });

  @override
  ResponseCollectionScreenState createState() => ResponseCollectionScreenState();
}

class ResponseCollectionScreenState extends State<ResponseCollectionScreen> {
  late List<TextEditingController> _textControllers;
  late List<bool> _checkboxValues;
  late List<String?> _selectedMultipleChoice;
  late List<String?> _selectedDropdown;
  int _responseCount = 0;
  final List<Map<String, dynamic>> _allResponses = [];

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    _textControllers = [];
    _checkboxValues = [];
    _selectedMultipleChoice = [];
    _selectedDropdown = [];

    // ignore: unused_local_variable
    for (var question in widget.form.questions) {
      _textControllers.add(TextEditingController());
      _checkboxValues.add(false);
      _selectedMultipleChoice.add(null);
      _selectedDropdown.add(null);
    }
  }

  void _clearFields() {
    setState(() {
      for (var controller in _textControllers) {
        controller.clear();
      }
      for (int i = 0; i < _checkboxValues.length; i++) {
        _checkboxValues[i] = false;
      }
      for (int i = 0; i < _selectedMultipleChoice.length; i++) {
        _selectedMultipleChoice[i] = null;
      }
      for (int i = 0; i < _selectedDropdown.length; i++) {
        _selectedDropdown[i] = null;
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submitResponse() {
    Map<String, dynamic> currentResponse = {};
    
    for (int i = 0; i < widget.form.questions.length; i++) {
      var question = widget.form.questions[i];
      dynamic answer;
      
      switch (question.type) {
        case QuestionType.text:
          answer = _textControllers[i].text;
          break;
        case QuestionType.checkbox:
          answer = _checkboxValues[i];
          break;
        case QuestionType.multipleChoice:
          answer = _selectedMultipleChoice[i] ?? "Not selected";
          break;
        case QuestionType.dropdown:
          answer = _selectedDropdown[i] ?? "Not selected";
          break;
      }
      currentResponse[question.question] = answer;
    }

    setState(() {
      _allResponses.add(currentResponse);
      _responseCount++;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Response #$_responseCount submitted successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    // Clear fields for next response
    _clearFields();
  }

  void _viewAllResponses() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('All Responses ($_responseCount)'),
        content: SizedBox(
          width: double.maxFinite,
          child: _allResponses.isEmpty
              ? Text('No responses submitted yet.')
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: _allResponses.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.only(bottom: 8),
                      child: ExpansionTile(
                        title: Text('Response #${index + 1}'),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _allResponses[index].entries.map((entry) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 8),
                                  child: Text(
                                    '${entry.key}: ${entry.value}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildFillableField(int index) {
    final question = widget.form.questions[index];

    switch (question.type) {
      case QuestionType.text:
        return TextFormField(
          controller: _textControllers[index],
          decoration: InputDecoration(
            labelText: question.question,
            border: OutlineInputBorder(),
          ),
        );

      case QuestionType.checkbox:
        return Row(
          children: [
            Expanded(
              child: Text(
                question.question,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Checkbox(
              value: _checkboxValues[index],
              onChanged: (val) {
                setState(() {
                  _checkboxValues[index] = val ?? false;
                });
              },
            ),
          ],
        );

      case QuestionType.multipleChoice:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.question,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            ...question.options.map((option) {
              return RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: _selectedMultipleChoice[index],
                onChanged: (val) {
                  setState(() {
                    _selectedMultipleChoice[index] = val;
                  });
                },
              );
            }),
          ],
        );

      case QuestionType.dropdown:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.question,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedDropdown[index],
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              hint: Text('Select an option'),
              items: question.options
                  .map((opt) => DropdownMenuItem(
                        value: opt,
                        child: Text(opt),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _selectedDropdown[index] = val;
                });
              },
            ),
          ],
        );

      default:
        return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Collect Responses'),
        actions: [
          IconButton(
            icon: Badge(
              label: Text('$_responseCount'),
              child: Icon(Icons.list_alt),
            ),
            onPressed: _viewAllResponses,
            tooltip: 'View all responses',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.form.projectName,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Chip(
                    label: Text('$_responseCount responses'),
                    backgroundColor: Colors.blue.shade100,
                  ),
                ],
              ),
              SizedBox(height: 8),
              Divider(thickness: 2),
              SizedBox(height: 16),
              ...widget.form.questions.asMap().entries.map((entry) {
                int index = entry.key;
                return Card(
                  margin: EdgeInsets.only(bottom: 16.0),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: _buildFillableField(index),
                  ),
                );
              }),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitResponse,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.green,
                      ),
                      child: Text(
                        'Submit Response',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _clearFields,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    ),
                    child: Icon(Icons.refresh),
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
