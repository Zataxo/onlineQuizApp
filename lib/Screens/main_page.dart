import 'package:flutter/material.dart';
import 'package:quiz/Screens/admin_login.dart';
import 'package:quiz/Screens/home_screen.dart';
import 'package:quiz/Screens/multi_player.dart';
import '../constants.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        title: const Text('Challenge Path'),
        toolbarHeight: h * 0.1,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image(
              image: const AssetImage('Assets/qm.png'),
              height: h * 0.05,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: h * 0.05,
          ),
          ClipRRect(
            child: Image(
              image: const AssetImage('Assets/quiz.gif'),
              height: h * 0.4,
            ),
          ),
          SizedBox(
            height: h * 0.05,
          ),
          Center(
            child: Container(
              width: w * 0.9,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: Row(
                children: [
                  Image(
                    image: const AssetImage('Assets/singleUser.png'),
                    width: w * 0.3,
                    height: h * 0.05,
                  ),
                  SizedBox(
                    height: w * 0.1,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Single Player',
                      style: TextStyle(color: mainBtn),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: h * 0.05,
          ),
          Container(
            width: w * 0.9,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.white),
            child: Row(
              children: [
                Image(
                  image: const AssetImage('Assets/multiUsers.png'),
                  width: w * 0.3,
                  height: h * 0.05,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MultiPlayer(),
                      ),
                    );
                  },
                  child: const Text(
                    'Multi Player',
                    style: TextStyle(color: mainBtn),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: h * 0.05,
          ),
          Container(
            width: w * 0.9,
            height: h * 0.1,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.white),
            child: Row(
              children: [
                Image(
                  image: const AssetImage('Assets/crown.png'),
                  width: w * 0.3,
                  height: h * 0.05,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Admin(),
                        ));
                  },
                  child: const Text(
                    'Admin Login',
                    style: TextStyle(color: mainBtn, fontSize: 18.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
