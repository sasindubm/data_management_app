import 'package:flutter/foundation.dart';
import '../models/response.dart';
import '../models/answer.dart';
import '../models/question.dart';
import '../models/choice.dart';
import '../models/answer_choice.dart';
import '../models/form.dart';
import '../repositories/response_repository.dart';
import '../repositories/answer_repository.dart';
import '../repositories/question_repository.dart';
import '../repositories/choice_repository.dart';
import '../repositories/answer_choice_repository.dart';
import '../repositories/form_repository.dart';

class ResponseController {
  final ResponseRepository _responseRepo = ResponseRepository();
  final AnswerRepository _answerRepo = AnswerRepository();
  final QuestionRepository _questionRepo = QuestionRepository();
  final ChoiceRepository _choiceRepo = ChoiceRepository();
  final AnswerChoiceRepository _answerChoiceRepo = AnswerChoiceRepository();
  final FormRepository _formRepo = FormRepository();

  // Create a response with answers
  Future<int?> submitResponse({
    required int formId,
    required int? userId,
    required List<Map<String, dynamic>> answersData,
    String responseStatus = 'Submitted',
  }) async {
    try {
      // Create the response
      final response = Response(
        formId: formId,
        userId: userId,
        responseStatus: responseStatus,
      );
      final responseId = await _responseRepo.insertResponse(response);

      if (responseId <= 0) {
        return null;
      }

      // Create answers for each question
      for (final answerData in answersData) {
        final answer = Answer(
          answerText: answerData['answerText'] ?? '',
          questionId: answerData['questionId'],
          responseId: responseId,
        );

        final answerId = await _answerRepo.insertAnswer(answer);

        // If there are choice links, save them
        if (answerId > 0 && answerData['choiceId'] != null) {
          final choiceId = answerData['choiceId'] as int;
          final answerChoice = AnswerChoice(
            answerId: answerId,
            choiceId: choiceId,
          );
          await _answerChoiceRepo.insertAnswerChoice(answerChoice);
        }
      }

      return responseId;
    } catch (e) {
      debugPrint('Error submitting response: $e');
      return null;
    }
  }

  // Get all responses for a form
  Future<List<Response>> getResponsesByFormId(int formId) async {
    return await _responseRepo.getResponsesByFormId(formId);
  }

  // Get all responses by user
  Future<List<Response>> getResponsesByUserId(int userId) async {
    return await _responseRepo.getResponsesByUserId(userId);
  }

  // Get form questions
  Future<List<Question>> getFormQuestions(int formId) async {
    return await _questionRepo.getQuestionsByFormId(formId);
  }

  // Get question choices
  Future<List<Choice>> getQuestionChoices(int questionId) async {
    return await _choiceRepo.getChoicesByQuestionId(questionId);
  }

  // Get response with its answers
  Future<Map<String, dynamic>?> getResponseDetails(int responseId) async {
    final response = await _responseRepo.getResponseById(responseId);
    if (response == null) return null;

    final answers = await _answerRepo.getAnswersByResponseId(responseId);

    return {
      'response': response,
      'answers': answers,
    };
  }

  // Delete response and its answers
  Future<bool> deleteResponse(int responseId) async {
    try {
      final answers = await _answerRepo.getAnswersByResponseId(responseId);

      // Delete answer choices
      for (final answer in answers) {
        final answerChoices = await _answerChoiceRepo
            .getAnswerChoicesByAnswerId(answer.answerId!);
        for (final ac in answerChoices) {
          await _answerChoiceRepo.deleteAnswerChoice(ac.answerId, ac.choiceId);
        }
        // Delete answer
        await _answerRepo.deleteAnswer(answer.answerId!);
      }

      // Delete response
      await _responseRepo.deleteResponse(responseId);
      return true;
    } catch (e) {
      debugPrint('Error deleting response: $e');
      return false;
    }
  }

  // Update response status
  Future<bool> updateResponseStatus(int responseId, String newStatus) async {
    try {
      final response = await _responseRepo.getResponseById(responseId);
      if (response == null) return false;

      final updatedResponse = Response(
        responseId: response.responseId,
        formId: response.formId,
        userId: response.userId,
        responseStatus: newStatus,
      );

      final rowsAffected = await _responseRepo.updateResponse(updatedResponse);
      return rowsAffected > 0;
    } catch (e) {
      debugPrint('Error updating response status: $e');
      return false;
    }
  }

  // Get all forms
  Future<List<Form>> getAllForms() async {
    return await _formRepo.getAllForms();
  }

  // Get form with details
  Future<Map<String, dynamic>?> getFormWithDetails(int formId) async {
    try {
      final form = await _formRepo.getFormById(formId);
      if (form == null) return null;

      final questions = await _questionRepo.getQuestionsByFormId(formId);
      final questionDetails = <Map<String, dynamic>>[];

      for (final question in questions) {
        final choices =
            await _choiceRepo.getChoicesByQuestionId(question.questionId ?? 0);
        questionDetails.add({
          'question': question,
          'choices': choices,
        });
      }

      return {
        'form': form,
        'questions': questionDetails,
      };
    } catch (e) {
      debugPrint('Error getting form details: $e');
      return null;
    }
  }

  // Update question
  Future<bool> updateQuestion(Question question) async {
    try {
      final rowsAffected = await _questionRepo.updateQuestion(question);
      return rowsAffected > 0;
    } catch (e) {
      debugPrint('Error updating question: $e');
      return false;
    }
  }

  // Update choice
  Future<bool> updateChoice(Choice choice) async {
    try {
      final rowsAffected = await _choiceRepo.updateChoice(choice);
      return rowsAffected > 0;
    } catch (e) {
      debugPrint('Error updating choice: $e');
      return false;
    }
  }

  // Delete question
  Future<bool> deleteQuestion(int questionId) async {
    try {
      // Delete all choices for this question
      final choices = await _choiceRepo.getChoicesByQuestionId(questionId);
      for (final choice in choices) {
        await _choiceRepo.deleteChoice(choice.choiceId ?? 0);
      }
      // Delete question
      await _questionRepo.deleteQuestion(questionId);
      return true;
    } catch (e) {
      debugPrint('Error deleting question: $e');
      return false;
    }
  }

  // Delete form
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

  // Get response count for form
  Future<int> getResponseCountForForm(int formId) async {
    try {
      final responses = await _responseRepo.getResponsesByFormId(formId);
      return responses.length;
    } catch (e) {
      debugPrint('Error getting response count: $e');
      return 0;
    }
  }
}
