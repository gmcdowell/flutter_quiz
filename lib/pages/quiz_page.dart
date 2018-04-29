import 'package:flutter/material.dart';

import '../models/question.dart';
import '../models/quiz.dart';
import './score_page.dart';

import '../UI/answer_button.dart';
import '../UI/question_text.dart';
import '../UI/correct_wrong_overlay.dart';

class QuizPage extends StatefulWidget {
  @override
  State createState() => new QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  Question currentQuestion;
  Quiz quiz = new Quiz([
    new Question('Elon Musk is human', false),
    new Question('Harry Potter is a girl', true),
    new Question('Cycling is good for you', true),
    new Question('Flutter is hard to learn', false),
  ]);
// int questionNumber;
// String questionText;
  bool isCorrect;

  bool overLayVisible = false;

  void handleAnswer(answer) {
    isCorrect = (currentQuestion.answer == answer);
    quiz.answer(isCorrect);
    this.setState(() {
      overLayVisible = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    currentQuestion = quiz.nextQuestion;    
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new Column(// this is our main page
            children: <Widget>[
          new AnswerButton(true, () => handleAnswer(true)),
          new QuestionText(currentQuestion.question, quiz.questionNumber),
          new AnswerButton(false, () => handleAnswer(false)),
        ]),
        overLayVisible
            ? new CorrectWrongOverlay(isCorrect, () {
                if (quiz.length == quiz.questionNumber) {
                  Navigator.of(context).pushAndRemoveUntil(
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new ScorePage(quiz.score, quiz.length)),
                      (Route route) => route == null);
                  return;
                }

                currentQuestion = quiz.nextQuestion;
                this.setState(() {
                  overLayVisible = false;
                });
              })
            : new Container()
      ],
    );
  }
}
