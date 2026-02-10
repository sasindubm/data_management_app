import 'package:flutter/foundation.dart';
import '../models/form.dart';
import '../models/question.dart';
import '../models/choice.dart';
import '../repositories/form_repository.dart';
import '../repositories/question_repository.dart';
import '../repositories/choice_repository.dart';

class FormController {
  final FormRepository _formRepo = FormRepository();
  final QuestionRepository _questionRepo = QuestionRepository();
  final ChoiceRepository _choiceRepo = ChoiceRepository();

  // Create a new form with questions and choices
  Future<int?> createFormWithQuestions({
    required int projectId,
    required List<Map<String, dynamic>> questionsData,
  }) async {
    try {
      // Create the form
      final form = Form(projectId: projectId);
      final formId = await _formRepo.insertForm(form);

      if (formId <= 0) {
        return null;
      }

      // Create questions and choices
      for (final questionData in questionsData) {
        final question = Question(
          questionText: questionData['questionText'] ?? 'Untitled Question',
          questionType: questionData['questionType'] ?? 'text',
          formId: formId,
        );

        final questionId = await _questionRepo.insertQuestion(question);

        if (questionId > 0 && questionData['options'] != null) {
          final options = questionData['options'] as List<String>;
          for (final option in options) {
            if (option.isNotEmpty) {
              final choice = Choice(
                choiceText: option,
                questionId: questionId,
              );
              await _choiceRepo.insertChoice(choice);
            }
          }
        }
      }

      return formId;
    } catch (e) {
      debugPrint('Error creating form: $e');
      return null;
    }
  }

  // Get all projects (assuming you have a project repository)
  Future<List<dynamic>> getProjects() async {
    // This will be implemented when you have ProjectRepository available
    return [];
  }

  // Get form by ID
  Future<Form?> getFormById(int formId) async {
    return await _formRepo.getFormById(formId);
  }

  // Get questions for a form
  Future<List<Question>> getFormQuestions(int formId) async {
    return await _questionRepo.getQuestionsByFormId(formId);
  }

  // Get choices for a question
  Future<List<Choice>> getQuestionChoices(int questionId) async {
    return await _choiceRepo.getChoicesByQuestionId(questionId);
  }

  // Delete form and its questions
  Future<bool> deleteForm(int formId) async {
    try {
      final questions = await _questionRepo.getQuestionsByFormId(formId);

      // Delete choices for all questions
      for (final question in questions) {
        final choices =
            await _choiceRepo.getChoicesByQuestionId(question.questionId ?? 0);
        for (final choice in choices) {
          await _choiceRepo.deleteChoice(choice.choiceId ?? 0);
        }
        // Delete question
        await _questionRepo.deleteQuestion(question.questionId ?? 0);
      }

      // Delete form
      await _formRepo.deleteForm(formId);
      return true;
    } catch (e) {
      debugPrint('Error deleting form: $e');
      return false;
    }
  }
}
