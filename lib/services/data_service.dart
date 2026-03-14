import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/question.dart';

class DataService {
  static Future<List<Question>> loadQuestions() async {
    final String response = await rootBundle.loadString('assets/data/questions.json');
    final List<dynamic> data = json.decode(response);
    return data.map((q) => Question.fromJson(q)).toList();
  }
}
