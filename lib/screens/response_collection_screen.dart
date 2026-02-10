import 'package:flutter/material.dart';
import 'newform_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/response_controller.dart';
import '../models/question.dart';
import '../models/choice.dart';

class ResponseCollectionScreen extends StatefulWidget {
  final int formId;
  final int? userId;
  final CreatedForm? form; // Keep for backward compatibility

  const ResponseCollectionScreen({
    super.key,
    required this.formId,
    this.userId,
    this.form,
  });

  @override
  ResponseCollectionScreenState createState() =>
      ResponseCollectionScreenState();
}

class ResponseCollectionScreenState extends State<ResponseCollectionScreen> {
  late List<TextEditingController> _textControllers;
  late List<bool> _checkboxValues;
  late List<String?> _selectedMultipleChoice;
  late List<String?> _selectedDropdown;
  late List<int?> _selectedChoiceIds;
  int _responseCount = 0;
  List<Question> _questions = [];
  List<List<Choice>> _questionChoices = [];
  bool _isLoading = true;

  final ResponseController _responseController = ResponseController();

  @override
  void initState() {
    super.initState();
    _loadFormData();
  }

  Future<void> _loadFormData() async {
    try {
      // Load questions from database
      _questions = await _responseController.getFormQuestions(widget.formId);

      // Load choices for each question
      for (var question in _questions) {
        final choices = await _responseController
            .getQuestionChoices(question.questionId ?? 0);
        _questionChoices.add(choices);
      }

      setState(() {
        _isLoading = false;
      });

      _initializeFields();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading form: $e')),
      );
    }
  }

  void _initializeFields() {
    _textControllers = [];
    _checkboxValues = [];
    _selectedMultipleChoice = [];
    _selectedDropdown = [];
    _selectedChoiceIds = [];

    for (var question in _questions) {
      _textControllers.add(TextEditingController());
      _checkboxValues.add(false);
      _selectedMultipleChoice.add(null);
      _selectedDropdown.add(null);
      _selectedChoiceIds.add(null);
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

  void _submitResponse() async {
    // Prepare answers data
    List<Map<String, dynamic>> answersData = [];

    for (int i = 0; i < _questions.length; i++) {
      var question = _questions[i];
      dynamic answerText = '';
      int? choiceId;

      switch (question.questionType) {
        case 'text':
          answerText = _textControllers[i].text;
          break;
        case 'checkbox':
          answerText = _checkboxValues[i].toString();
          break;
        case 'multipleChoice':
          answerText = _selectedMultipleChoice[i] ?? 'Not selected';
          // Find the choice ID for the selected option
          if (_selectedMultipleChoice[i] != null) {
            final choices = _questionChoices[i];
            final selectedChoice = choices.firstWhere(
              (c) => c.choiceText == _selectedMultipleChoice[i],
              orElse: () => Choice(),
            );
            choiceId = selectedChoice.choiceId;
          }
          break;
        case 'dropdown':
          answerText = _selectedDropdown[i] ?? 'Not selected';
          // Find the choice ID for the selected option
          if (_selectedDropdown[i] != null) {
            final choices = _questionChoices[i];
            final selectedChoice = choices.firstWhere(
              (c) => c.choiceText == _selectedDropdown[i],
              orElse: () => Choice(),
            );
            choiceId = selectedChoice.choiceId;
          }
          break;
      }

      answersData.add({
        'questionId': question.questionId,
        'answerText': answerText,
        'choiceId': choiceId,
      });
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Saving response...'),
          ],
        ),
      ),
    );

    // Submit response to database
    final responseId = await _responseController.submitResponse(
      formId: widget.formId,
      userId: widget.userId,
      answersData: answersData,
    );

    Navigator.pop(context); // Close loading dialog

    if (responseId != null && responseId > 0) {
      setState(() {
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save response'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _viewAllResponses() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$_responseCount responses saved to database'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _buildFillableField(int index) {
    final question = _questions[index];
    final choices = _questionChoices[index];

    switch (question.questionType) {
      case 'text':
        return TextFormField(
          controller: _textControllers[index],
          decoration: InputDecoration(
            labelText: question.questionText,
            border: OutlineInputBorder(),
          ),
        );

      case 'checkbox':
        return Row(
          children: [
            Expanded(
              child: Text(
                question.questionText,
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

      case 'multipleChoice':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.questionText,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            ...choices.map((choice) {
              return RadioListTile<String>(
                title: Text(choice.choiceText ?? ''),
                value: choice.choiceText ?? '',
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

      case 'dropdown':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.questionText,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedDropdown[index],
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              hint: Text('Select an option'),
              items: choices
                  .map((choice) => DropdownMenuItem(
                        value: choice.choiceText,
                        child: Text(choice.choiceText ?? ''),
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
        return Text('Unknown question type');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Collect Responses'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Collect Responses'),
        actions: [
          IconButton(
            icon: Badge(
              label: Text('$_responseCount'),
              child: Icon(Icons.check_circle),
            ),
            onPressed: _viewAllResponses,
            tooltip: 'View response count',
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
                      'Form #${widget.formId}',
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
              Text(
                '${_questions.length} Questions',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              Divider(thickness: 2),
              SizedBox(height: 16),
              ..._questions.asMap().entries.map((entry) {
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
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 24),
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
