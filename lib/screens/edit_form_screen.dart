import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/response_controller.dart';
import '../models/question.dart';
import '../models/choice.dart';

class EditFormScreen extends StatefulWidget {
  final int formId;

  const EditFormScreen({
    super.key,
    required this.formId,
  });

  @override
  State<EditFormScreen> createState() => _EditFormScreenState();
}

class _EditFormScreenState extends State<EditFormScreen> {
  late ResponseController _responseController;
  List<Map<String, dynamic>> _questions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _responseController = ResponseController();
    _loadFormDetails();
  }

  Future<void> _loadFormDetails() async {
    try {
      final formDetails =
          await _responseController.getFormWithDetails(widget.formId);
      if (mounted) {
        if (formDetails != null) {
          setState(() {
            _questions = List.from(formDetails['questions'] as List);
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading form: $e')),
        );
      }
    }
  }

  Future<void> _saveChanges() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Saving changes...'),
          ],
        ),
      ),
    );

    try {
      for (final questionData in _questions) {
        final question = questionData['question'] as Question;
        await _responseController.updateQuestion(question);

        final choices = questionData['choices'] as List<Choice>;
        for (final choice in choices) {
          await _responseController.updateChoice(choice);
        }
      }

      if (mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Changes saved successfully'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving changes: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Edit Form')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Form #${widget.formId}',
          style: GoogleFonts.jetBrainsMono(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: _saveChanges,
            icon: Icon(Icons.save),
            tooltip: 'Save changes',
          ),
        ],
      ),
      body: _questions.isEmpty
          ? Center(
              child: Text(
                'No questions in this form',
                style: GoogleFonts.jetBrainsMono(),
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: _buildQuestionCards(),
              ),
            ),
    );
  }

  List<Widget> _buildQuestionCards() {
    return _questions.asMap().entries.map((entry) {
      final index = entry.key;
      final questionData = entry.value;
      final question = questionData['question'] as Question;
      final choices =
          List<Choice>.from(questionData['choices'] as List<Choice>);

      return Card(
        margin: EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${index + 1}',
                    style: GoogleFonts.jetBrainsMono(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      question.questionType ?? 'text',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 12,
                        color: Colors.blue[900],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              TextFormField(
                initialValue: question.questionText,
                decoration: InputDecoration(
                  labelText: 'Question Text',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _questions[index]['question'] = Question(
                      questionId: question.questionId,
                      questionText: value,
                      questionType: question.questionType,
                      formId: question.formId,
                    );
                  });
                },
              ),
              if (choices.isNotEmpty)
                ..._buildChoiceWidgets(index, question, choices),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _questions.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Question will be deleted after saving'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text(
                  'Delete Question',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildChoiceWidgets(
      int questionIndex, Question question, List<Choice> choices) {
    return [
      SizedBox(height: 12),
      Text(
        'Options',
        style: GoogleFonts.jetBrainsMono(
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 8),
      ..._buildChoiceRows(questionIndex, choices),
      TextButton.icon(
        onPressed: () {
          setState(() {
            choices.add(Choice(
              choiceText: 'Option ${choices.length + 1}',
              questionId: question.questionId,
            ));
            _questions[questionIndex]['choices'] = choices;
          });
        },
        icon: Icon(Icons.add),
        label: Text('Add Option'),
      ),
    ];
  }

  List<Widget> _buildChoiceRows(int questionIndex, List<Choice> choices) {
    return choices.asMap().entries.map((choiceEntry) {
      final choiceIndex = choiceEntry.key;
      final choice = choiceEntry.value;

      return Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: choice.choiceText ?? '',
                decoration: InputDecoration(
                  labelText: 'Option ${choiceIndex + 1}',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    final updatedChoices = List<Choice>.from(choices);
                    updatedChoices[choiceIndex] = Choice(
                      choiceId: choice.choiceId,
                      choiceText: value,
                      questionId: choice.questionId,
                    );
                    _questions[questionIndex]['choices'] = updatedChoices;
                  });
                },
              ),
            ),
            SizedBox(width: 8),
            IconButton(
              onPressed: () {
                setState(() {
                  final updatedChoices = List<Choice>.from(choices);
                  updatedChoices.removeAt(choiceIndex);
                  _questions[questionIndex]['choices'] = updatedChoices;
                });
              },
              icon: Icon(Icons.delete),
              color: Colors.red,
            ),
          ],
        ),
      );
    }).toList();
  }
}
