import 'package:flutter/material.dart';
import 'package:quiz/models/multi_model.dart';
import 'package:quiz/widgets/next_button.dart';
import 'package:quiz/widgets/result_box.dart';
import '../constants.dart';
import '../models/question_model.dart';
import '../widgets/question_widget.dart';
import '../widgets/option_card.dart';
import '../models/db_connect.dart';

class HomeScreen extends StatefulWidget {
  final bool showAppBar;
  final RoomModel? roomModel;
  final String? defualtRoomId;
  final bool? isPlayerOnde;
  final Function(int score)? getCurrentScore;
  const HomeScreen({
    Key? key,
    this.showAppBar = true,
    this.getCurrentScore,
    this.roomModel,
    this.isPlayerOnde,
    this.defualtRoomId,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var db = DBconnect(); //create object for db connect
  late Future _questions;
  List<Question> extractedData = [];

  Future<List<Question>> getData() async {
    return db.fetchQuestions();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    super.didChangeDependencies();
    showMesg();
  }

  @override
  void initState() {
    _questions = getData();
    super.initState();
    nextQWithoutPressing();
  }

  // final List<Question> _questions = [
  //   Question(
  //       id: '10',
  //       title: 'What is 2 + 2 ?',
  //       options: {'5': false, '30': false, '4': true, '10': false}),
  //   Question(
  //       id: '11',
  //       title: 'What is 20 + 10 ?',
  //       options: {'50': false, '30': true, '40': false, '10': false}),
  // ];
  //index to loop through questions
  int index = 0;
  //score varible
  int score = 0;
  //check if answer selected
  bool isAlreadySelected = false;
  //check if user clicked
  bool isPressed = false;
  void showMesg() {
    Future.delayed(Duration.zero, () {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            "You have 10 Second to Answer the Question ,other wise the Question will disappear"),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(vertical: 20.0),
      ));
    });
  }
  //function to display next question

  void nextQuestion(int questionLenght) {
    // nextQWithoutPressing();

    if (index == questionLenght - 1) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => ResultBox(
                roomModel: widget.roomModel,
                defaultRoomId: widget.defualtRoomId,
                isPlayerOne: widget.isPlayerOnde,
                result: score,
                questionLength: questionLenght,
                onPressed: startOver,
              ));
    } else {
      nextQWithoutPressing();
      if (isPressed) {
        setState(() {
          index++;
          isPressed = false;
          isAlreadySelected = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please Select any Option"),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(vertical: 20.0),
        ));
      }
    }
  }

  Future<void> nextQWithoutPressing() async {
    // if (!isPressed) {
    await Future.delayed(const Duration(seconds: 10));

    setState(() {
      isPressed == true ? isPressed = false : isPressed = true;
      // index += 1;
      print(isPressed);
      nextQuestion(extractedData.length);
    });

    // }
  }

  Future<void> checkAnswerAndUpdate(bool value) async {
    if (isAlreadySelected) {
      return;
    } else {
      if (value == true) {
        score++;
        if (widget.getCurrentScore != null) {
          widget.getCurrentScore!(score);
        }
      }
      setState(() {
        isPressed = true;
        isAlreadySelected = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        nextQuestion(extractedData.length);
        // index += 1;
        // isPressed = false;
        // isAlreadySelected = false;
      });
    }
  }

  void startOver() {
    setState(() {
      index = 0;
      score = 0;
      isPressed = false;
      isAlreadySelected = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _questions as Future<List<Question>>,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              extractedData = snapshot.data as List<Question>;
              return Scaffold(
                backgroundColor: background,
                appBar: widget.showAppBar
                    ? AppBar(
                        title: const Text("Quiz App"),
                        backgroundColor: background,
                        shadowColor: Colors.transparent,
                        actions: [
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Text(
                              "Score : $score",
                              style: const TextStyle(fontSize: 18.0),
                            ),
                          )
                        ],
                      )
                    : null,
                body: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  width: double.infinity,
                  child: Column(
                    children: [
                      QuestionWidget(
                          indexAction: index,
                          question: extractedData[index].title,
                          totalQuestions: extractedData.length),
                      const Divider(
                        color: neutral,
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      for (int i = 0;
                          i < extractedData[index].options.length;
                          i++)
                        GestureDetector(
                          onTap: () => checkAnswerAndUpdate(
                              extractedData[index].options[i].values.first),
                          child: OptionCard(
                            option: extractedData[index].options[i].keys.first,
                            color: isPressed
                                ? extractedData[index]
                                            .options[i]
                                            .values
                                            .first ==
                                        true
                                    ? correct
                                    : incorrect
                                : neutral,
                          ),
                        ),
                    ],
                  ),
                ),
                floatingActionButton: GestureDetector(
                  onTap: () => nextQuestion(extractedData.length),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: NextButton(),
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
              );
            }
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Please wait while Questions are Loading..',
                    style: TextStyle(
                        color: neutral,
                        decoration: TextDecoration.none,
                        fontSize: 18.0),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: Text(
              'No Data',
              style: TextStyle(fontSize: 18),
            ),
          );
        });
  }
}
