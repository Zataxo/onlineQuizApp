import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:quiz/constants.dart';
import 'package:quiz/models/multi_model.dart';
import '../Screens/home_screen.dart';

class LiveGame extends StatefulWidget {
  final String iD;
  final bool isPlayerOnde;

  const LiveGame({Key? key, required this.iD, required this.isPlayerOnde})
      : super(key: key);

  @override
  State<LiveGame> createState() => _LiveGameState();
}

class _LiveGameState extends State<LiveGame> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // listenToFireBase();
  }

  late DatabaseReference ref1 =
      FirebaseDatabase.instance.ref("/Room/${widget.iD}");

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
      stream: ref1.onValue,
      builder: (context, snapshot) {
        final model = _getRoomModel(snapshot);

        if (model == null) {
          return const CircularProgressIndicator();
        }

        //if first palyer is completed
        //if socond palyer is completed
        return Scaffold(
          appBar: AppBar(
            backgroundColor: background,
            title: const Text('Live Game'),
            actions: [
              Text(
                widget.isPlayerOnde
                    ? model.playerOneScore.toString()
                    : model.playerTwoScore.toString(),
              )
            ],
          ),
          body: !model.plyaerTwoStatus
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.person),
                    SizedBox(
                      width: 200,
                      child: LinearProgressIndicator(),
                    ),
                    Icon(Icons.person_add_alt),
                  ],
                )
              : Column(
                  children: [
                    Expanded(
                      child: HomeScreen(
                        showAppBar: false,
                        roomModel: model,
                        isPlayerOnde: widget.isPlayerOnde,
                        defualtRoomId: widget.iD,
                        // onComplete: () {
                        //   print('object');
                        // },
                        getCurrentScore: (value) {
                          if (widget.isPlayerOnde) {
                            final temp = model.copyWith(playerOneScore: value);
                            ref1.update(temp.toJson());

                            ///updateTableInFireBase(temp);
                          } else {
                            final temp = model.copyWith(playerTwoScore: value);
                            log(temp.toJson().toString());

                            ///updateTableInFireBase(temp);
                            ref1.update(temp.toJson());
                          }
                        },
                      ),
                    ),
                    const Divider(
                      color: background,
                    ),
                    Container(
                      height: 90,
                      color: background,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(model.playerOneScore.toString()),
                          Text(model.playerTwoScore.toString()),
                        ],
                      ),
                    )
                  ],
                ),
        );
      },
    );
  }

  RoomModel? _getRoomModel(AsyncSnapshot<DatabaseEvent> snapshot) {
    try {
      return RoomModel.fromJson(
          jsonDecode(jsonEncode(snapshot.data!.snapshot.value)));
    } catch (e) {
      return null;
    }
  }
}
