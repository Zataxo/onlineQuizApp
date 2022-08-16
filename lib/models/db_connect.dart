import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quiz/models/model.dart';
import './question_model.dart';

class DBconnect {
  //function for add questions
  final url = Uri.parse(
      'https://quiapp-1c97b-default-rtdb.firebaseio.com/questions.json');
  Future<void> addQuestion(Question question) async {
    http.post(url,
        body: json.encode({
          'title': question.title,
          'options': question.options,
        }));
  }

  //fetching data from firebase
  Future<List<Question>> fetchQuestions() async {
    return http.get(url).then((response) {
      //then method returns a response which is our data

      var data = modelFromJson(response.body);

      List<Question> newQuestions = [];
      data.forEach((key, value) {
        var newQuestion = Question(
          id: key,
          title: value.title,
          options: value.options,
        );
        //add to newQuestions
        newQuestions.add(newQuestion);
      });
      return newQuestions;
    });
  }
}
