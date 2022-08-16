import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/db_connect.dart';
import '../models/question_model.dart';

class ModifyData extends StatefulWidget {
  const ModifyData({Key? key}) : super(key: key);

  @override
  State<ModifyData> createState() => _ModifyDataState();
}

class _ModifyDataState extends State<ModifyData> {
  late bool answerOption = false;
  List<Map<String, bool>> myOptions = [];
  bool isLoading = false;

  final questionString = TextEditingController();
  final answerString = TextEditingController();

  void answerTruth() {
    setState(() {
      answerOption = true;
    });
  }

  listenToFireBase() {
    DatabaseReference ref1 =
        FirebaseDatabase.instance.ref("/questions/-N7PvmsyYKE5GP5q6-ti");
// Only update the name, leave the age and address!

    Stream<DatabaseEvent> pcckg = ref1.onValue;
    pcckg.listen((event) {
      // print('YYYYYYYYYYYYYYYYYYYYYYYYYES ${event.snapshot.children.first}');
    });
  }

  @override
  void initState() {
    super.initState();
    listenToFireBase();
  }

  void appendMyList() {
    if (answerString.text == '') {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text(
            'Sorry',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Text('No option found'),
          elevation: 20,
        ),
      );
    } else if (questionString.text == '') {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text(
            'Sorry',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Text('No Question Specified'),
          elevation: 20,
        ),
      );
    } else {
      myOptions.add({answerString.text: answerOption});
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text(
            'Done',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Text('Option added to list'),
          elevation: 20,
        ),
      );
      // answerString.clear();
    }

    // print(questionString.text);
  }

  void pushQuestion() {
    var db = DBconnect();
    if (questionString.text == '') {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text(
            'Sorry',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Text('No Question Specified'),
          elevation: 20,
        ),
      );
    } else if (answerString.text == '') {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text(
            'Sorry',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Text('No Option Specified Specified'),
          elevation: 20,
        ),
      );
      // questionString.clear();
    } else {
      db.addQuestion(
          Question(id: null, title: questionString.text, options: myOptions));
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text(
            'System Feedback',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Text('Question Uploaded Successfuly'),
          elevation: 20,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: background,
          title: const Text('Modify Data'),
          elevation: 0,
        ),
        body: Column(
          children: [
            const TabBar(tabs: [
              Tab(
                icon: Icon(Icons.new_label),
              ),
              Tab(
                icon: Icon(Icons.edit_note),
              ),
            ]),
            Expanded(
              child: TabBarView(children: [
                //First Tab
                Container(
                  child: Column(
                    children: [
                      const SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: Image(image: AssetImage('Assets/new.png')),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white),
                        ),
                        child: TextField(
                          decoration: const InputDecoration(
                              hintText: "Write Question Here",
                              border: InputBorder.none,
                              icon: Icon(Icons.question_answer)),
                          controller: questionString,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(8),
                            width: 220,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white),
                            ),
                            child: TextField(
                              decoration: const InputDecoration(
                                hintText: "Write Option Here",
                                border: InputBorder.none,
                                icon: Icon(Icons.question_answer),
                              ),
                              controller: answerString,
                            ),
                          ),
                          Switch(
                              value: answerOption,
                              onChanged: (value) {
                                setState(() {
                                  answerOption = value;
                                });
                              }),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: appendMyList,
                        child: const Icon(Icons.add),
                      ),
                      ElevatedButton(
                          onPressed: pushQuestion,
                          child: const Text('Upload Question'))
                    ],
                  ),
                ),
                const QuestionsCard(),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionsCard extends StatefulWidget {
  const QuestionsCard({
    Key? key,
  }) : super(key: key);

  @override
  State<QuestionsCard> createState() => _QuestionsCardState();
}

class _QuestionsCardState extends State<QuestionsCard> {
  List<Question> myQuestionForModify = [];
  bool isLoading = false;
  Future<void> fetchNow() async {
    setState(() {
      isLoading = true;
    });
    var db = DBconnect();
    final temp = await db.fetchQuestions();
    myQuestionForModify.addAll(temp);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchNow();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: myQuestionForModify.length,
            itemBuilder: (context, index) =>
                questionItemWidget(myQuestionForModify[index]),
          );
  }

  Card questionItemWidget(Question q) {
    return Card(
      margin: const EdgeInsets.all(8),
      clipBehavior: Clip.antiAlias,
      elevation: 10,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.question_answer_rounded),
            title: Text(q.title),
            trailing: IconButton(
                onPressed: () {
                  setState(() {});
                },
                icon: const Icon(Icons.edit)),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: q.options.length,
              itemBuilder: (context, index) => CustomTextField(
                  value: q.options[index].keys.first,
                  isResult: q.options[index].values.first,
                  onChange: (val) {
                    q.options[index] = val;
                  }),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  del(q.id!);
                  showDialog(
                    context: context,
                    builder: (context) => const AlertDialog(
                      title: Text(
                        'System Feedback',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      content: Text('Deleted Successfuly'),
                      elevation: 20,
                    ),
                  );
                  setState(() {
                    //  q.options
                  });
                },
                child: const Text('Delete'),
              ),
              TextButton(
                onPressed: () async {
                  if (q.id != null) {
                    await upd(q.id!, q.options);
                    //print(q.id);
                    showDialog(
                      context: context,
                      builder: (context) => const AlertDialog(
                        title: Text(
                          'System Feedback',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        content: Text('Updated Successfuly'),
                        elevation: 20,
                      ),
                    );
                  } else {
                    // print('No');
                  }
                },
                child: const Text('Update'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  upd(String id, List<Map<String, bool>> options) async {
    DatabaseReference ref1 = FirebaseDatabase.instance.ref("questions/$id");
// Only update the name, leave the age and address!

    await ref1.update({
      'options': options,
    });
  }

  del(String id) async {
    DatabaseReference ref1 = FirebaseDatabase.instance.ref("questions/$id");
// Only update the name, leave the age and address!
    await ref1.remove();
  }
}

class CustomTextField extends StatefulWidget {
  final String value;
  final bool isResult;
  final Function(Map<String, bool> val) onChange;
  const CustomTextField(
      {Key? key,
      required this.value,
      required this.isResult,
      required this.onChange})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final myTextFieldControlerForOptions =
      TextEditingController(text: widget.value);
  late bool switchValue = widget.isResult;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: myTextFieldControlerForOptions,
            enabled: true,
            onChanged: (_) {
              widget
                  .onChange({myTextFieldControlerForOptions.text: switchValue});
            },
          ),
        ),
        Switch(
            value: switchValue,
            onChanged: (val) {
              setState(() {
                switchValue = !switchValue;
                widget.onChange(
                    {myTextFieldControlerForOptions.text: switchValue});
              });
            })
      ],
    );
  }
}
