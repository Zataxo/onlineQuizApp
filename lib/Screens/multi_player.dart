import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:quiz/constants.dart';
import 'dart:math';
import '../models/multi_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'multi_player_stream.dart';

class MultiPlayer extends StatefulWidget {
  const MultiPlayer({Key? key}) : super(key: key);

  @override
  State<MultiPlayer> createState() => _MultiPlayerState();
}

class _MultiPlayerState extends State<MultiPlayer> {
  final userName = TextEditingController();
  final joiningRoomController = TextEditingController();
  Random rd = Random();

  //List myIds = ['A', 'B', 'C', '5', 'E', '12', 'G', '230', 'i', 'j'];
  final url =
      Uri.parse('https://quiapp-1c97b-default-rtdb.firebaseio.com/Room.json');
  Future<void> generateRoomNow() async {
    int randomNumber;
    String? mySerialNumber = '#id';
    if (userName.text == '') {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text(
            'Please Specify your user name',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          elevation: 20,
        ),
      );
    } else {
      for (int i = 0; i < 5; i++) {
        randomNumber = rd.nextInt(9);
        mySerialNumber = mySerialNumber! + randomNumber.toString();
      }
      mySerialNumber = mySerialNumber! + "id#";

      final response = await http.post(url,
          body: json.encode(
            RoomModel(
                    roomId: mySerialNumber,
                    creatorName: userName.text,
                    oppName: '',
                    plyaerOneStatus: true,
                    plyaerTwoStatus: false,
                    playerOneScore: 0,
                    playerTwoScore: 0)
                .toJson(),
          ));

      if (response.statusCode == 200) {
        print(jsonDecode(response.body)['name']);

        // print(response.statusCode);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              'Room Created Successfully',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: SizedBox(
              width: 200,
              height: 100,
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text('Your Room iD is :  '),
                      Text(
                        mySerialNumber ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LiveGame(
                                iD: jsonDecode(response.body)['name'],
                                isPlayerOnde: true,
                              ),
                            ));
                      },
                      child: const Text('Play Now'))
                ],
              ),
            ),
            elevation: 20,
          ),
        );
      }
    }
  }

  void fetchRoomId(String roomId) {
    http.get(url).then((response) {
      final lis = roomModelFromJson(response.body);
      try {
        final model =
            lis.entries.firstWhere((element) => element.value.roomId == roomId);
      } catch (e) {
        return null;
      }
      // listenToFireBase(model.key);
    });
  }

  void joiningRoom() {
    http.get(url).then((response) {
      final lis = roomModelFromJson(response.body);
      try {
        // print(userName.text + 'ed');
        final model = lis.entries.firstWhere(
            (element) => element.value.roomId == joiningRoomController.text);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              'Connected Successfully',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: ElevatedButton(
                onPressed: () async {
                  late DatabaseReference ref1 =
                      FirebaseDatabase.instance.ref("/Room/${model.key}");
                  await ref1.update({
                    "plyaerTwoStatus": true,
                  });
//
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            LiveGame(iD: model.key, isPlayerOnde: false),
                      ));
                },
                child: const Text('Play Now')),
            elevation: 20,
          ),
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            title: Text(
              'Sorry',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: Text('Please Specify Correct information'),
            elevation: 20,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('MultiPlayer'),
        backgroundColor: background,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: h * 0.08,
            ),
            Container(
              margin: const EdgeInsets.all(8.0),
              width: w * 0.4,
              height: h * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(150),
                image: const DecorationImage(
                    image: AssetImage('Assets/people.png'), fit: BoxFit.fill),
              ),
            ),
            SizedBox(
              height: h * 0.1,
            ),
            Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: neutral),
              ),
              child: TextField(
                controller: userName,
                decoration: const InputDecoration(
                  hintText: "User name : ",
                  border: InputBorder.none,
                  icon: Icon(Icons.perm_identity),
                ),
              ),
            ),
            SizedBox(
              height: h * 0.08,
            ),
            Center(
              child: Container(
                width: w * 0.95,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.search),
                    SizedBox(
                      width: w * 0.25,
                    ),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text(
                              'Joining Room',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            content: SizedBox(
                              width: 200,
                              height: 100,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: TextField(
                                      controller: joiningRoomController,
                                      decoration: const InputDecoration(
                                        hintText: "Room id",
                                        border: InputBorder.none,
                                        icon: Icon(Icons.join_full),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                      onPressed: joiningRoom,
                                      child: const Text('Join'))
                                ],
                              ),
                            ),
                            elevation: 20,
                          ),
                        );
                      },
                      child: const Text(
                        'Join Room',
                        style: TextStyle(color: mainBtn),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: h * 0.02,
            ),
            Container(
              width: w * 0.95,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.fiber_new_sharp),
                  SizedBox(
                    width: w * 0.25,
                  ),
                  TextButton(
                    onPressed: generateRoomNow,
                    child: const Text(
                      'Create Room',
                      style: TextStyle(color: mainBtn),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
