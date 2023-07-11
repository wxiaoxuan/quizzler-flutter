import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'quizBrain.dart';

QuizBrain quizBrain = QuizBrain();

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  // Score Indicator for User
  List<Icon> scoreKeeper = [];
  int correct = 0;
  int wrong = 0;

  // Display User's Score after end of quiz
  void showAlert() {
    Alert(
      context: context,
      title: "QUIZ COMPLETED!",
      desc: "You have completed the quiz.\n"
          "Correct Answers: $correct \n"
          "Wrong Answers: $wrong \n"
          "Good job!",
      // type: AlertType.info,
      buttons: [
        DialogButton(
          child: Text(
            "End of Quiz",
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ).show();
  }

  // Check if user's answer is correct or wrong
  void checkAnswer(bool userPickedAnswer) {
    bool correctAnswer =
        quizBrain.getQuestionAnswer(); // able to access the private quizBrain

    setState(() {
      // if user is Correct
      if (userPickedAnswer == correctAnswer) {
        correct++;
        scoreKeeper.add(Icon(
          Icons.check,
          color: Colors.green,
        ));
        print("You are correct!");
      } else {
        // if user is wrong
        wrong++;
        scoreKeeper.add(Icon(
          Icons.close,
          color: Colors.red,
        ));
        print("You got it wrong noob. ");
      }

      // Check if User has reach the end of quiz
      if (quizBrain.isFinished() == true) {
        showAlert();
        quizBrain.reset();
        scoreKeeper.clear();
        correct = 0;
        wrong = 0;
      } else {
        // After user answered, move on to the next question
        quizBrain.nextQuestion();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain
                    .getQuestionText(), // able to access the private quizBrain
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),

        // USER PICKED TRUE
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: TextButton(
              onPressed: () {
                checkAnswer(true);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.green, // Background Color
              ),
              child: const Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ),

        // USER PICKED FALSE
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: TextButton(
              onPressed: () {
                checkAnswer(false);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red, // Background Color
              ),
              child: const Text(
                'False',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ),
        //TODO: Add a Row here as your score keeper
        Row(
          children: scoreKeeper,
        )
      ],
    );
  }
}
