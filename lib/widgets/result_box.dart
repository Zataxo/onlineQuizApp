import 'package:flutter/material.dart';
import 'package:quiz/Screens/main_page.dart';
import 'package:quiz/models/multi_model.dart';
import '../constants.dart';

class ResultBox extends StatefulWidget {
  final int result;
  final int questionLength;
  final VoidCallback onPressed;
  final RoomModel? roomModel;
  final String? defaultRoomId;
  final bool? isPlayerOne;

  const ResultBox({
    Key? key,
    required this.result,
    required this.questionLength,
    required this.onPressed,
    this.isPlayerOne,
    this.roomModel,
    this.defaultRoomId,
  }) : super(key: key);

  @override
  State<ResultBox> createState() => _ResultBoxState();
}

class _ResultBoxState extends State<ResultBox> {
  bool isDelaied = true;
  @override
  void initState() {
    super.initState();
    if (widget.roomModel != null) {
      waitingOotherPlayer();
      getWinner();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // double w = MediaQuery.of(context).size.width;

    return Builder(builder: (context) {
      return Dialog(
        backgroundColor: background,
        child: Padding(
          padding: const EdgeInsets.all(60),
          child: widget.roomModel != null
              ? (isDelaied
                  ? _buildWaitingAnotherPAlyer()
                  : _buildMultiPlayerDialog(size))
              : _buildSingelPlayerDialog(),
        ),
      );
    });
  }

  SizedBox _buildWaitingAnotherPAlyer() {
    return SizedBox(
      width: 300,
      height: 100,
      child: Column(
        children: const [
          Text('Waiting'),
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  String getWinner() {
    if (widget.isPlayerOne! &&
        widget.roomModel!.playerOneScore > widget.roomModel!.playerTwoScore) {
      return 'You Are the Winner';
    } else if (widget.isPlayerOne! &&
        widget.roomModel!.playerOneScore < widget.roomModel!.playerTwoScore) {
      return 'You Lost';
    } else if (!widget.isPlayerOne! &&
        widget.roomModel!.playerTwoScore > widget.roomModel!.playerOneScore) {
      return 'You Are the Winner';
    } else if (!widget.isPlayerOne! &&
        widget.roomModel!.playerTwoScore < widget.roomModel!.playerOneScore) {
      return 'You Lost';
    }
    return 'Draw';
  }

  void waitingOotherPlayer() {
    Future.delayed(
      const Duration(seconds: 10),
      () {
        setState(() {
          isDelaied = false;
        });
      },
    );
  }

  Widget _buildMultiPlayerDialog(Size size) {
    return SizedBox(
      width: size.width * 0.5,
      height: size.height * 0.4,
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.2,
          ),
          Text(getWinner()),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainPage(),
                  ),
                  (route) => false);
              //   DatabaseReference ref1 =
              //       FirebaseDatabase.instance.ref("Room/${widget.defaultRoomId}");
              //   await ref1
              //       .update(widget.roomModel!
              //           .copyWith(
              //               playerOneScore: 0,
              //               playerTwoScore: 0,
              //               plyaerOneStatus: widget.isPlayerOne,
              //               plyaerTwoStatus: !widget.isPlayerOne!)
              //           .toJson())
              //       .then((value) {
              //     widget.onPressed();

              //   });
            },
            child: const Text('Switch off'),
          ),
        ],
      ),
    );
  }

  Widget _buildSingelPlayerDialog() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Result',
          style: TextStyle(color: neutral, fontSize: 22.0),
        ),
        const SizedBox(
          height: 20.0,
        ),
        CircleAvatar(
          child: Text(
            '${widget.result}/${widget.questionLength}',
            style: const TextStyle(fontSize: 30.0),
          ),
          radius: 70.0,
          backgroundColor: widget.result == widget.questionLength / 2
              ? Colors.yellow
              : widget.result < widget.questionLength / 2
                  ? incorrect
                  : correct,
        ),
        const SizedBox(
          height: 20.0,
        ),
        Text(
          widget.result == widget.questionLength / 2
              ? 'Almost There'
              : widget.result < widget.questionLength / 2
                  ? 'Try Again ?'
                  : 'Great',
          style: const TextStyle(color: neutral),
        ),
        const SizedBox(
          height: 25.0,
        ),
        GestureDetector(
          onTap: widget.onPressed,
          child: const Text(
            'Start Over',
            style: TextStyle(color: Colors.blue, fontSize: 20.0),
          ),
        )
      ],
    );
  }
}
