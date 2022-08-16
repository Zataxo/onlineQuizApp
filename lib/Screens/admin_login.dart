import 'package:flutter/material.dart';
import 'package:quiz/constants.dart';

import 'modify_data.dart';

class Admin extends StatelessWidget {
  Admin({Key? key}) : super(key: key);
  final userName = TextEditingController();
  final passWord = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
      ),
      backgroundColor: background,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: h * 0.01),
              const Center(
                child: Text(
                  "Hello Again",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: neutral),
                ),
              ),
              SizedBox(height: h * 0.01),
              const Text(
                "Welcom back,You Have been missed",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: neutral),
              ),
              SizedBox(height: h * 0.05),
              Image(
                width: w * 0.8,
                height: h * 0.3,
                image: const AssetImage('Assets/adminLogo.png'),
              ),
              SizedBox(height: h * 0.05),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: neutral),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    controller: userName,
                    decoration: const InputDecoration(
                        hintText: "Username",
                        border: InputBorder.none,
                        icon: Icon(Icons.supervised_user_circle)),
                  ),
                ),
              ),
              SizedBox(
                height: h * 0.02,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    controller: passWord,
                    obscureText: true,
                    decoration: const InputDecoration(
                        hintText: "Password",
                        border: InputBorder.none,
                        icon: Icon(Icons.password)),
                  ),
                ),
              ),
              SizedBox(
                height: h * 0.08,
              ),
              Container(
                width: w * 0.95,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: TextButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const ModifyData(),
                    //   ),
                    // );
                    if (userName.text == 'Admin' && passWord.text == '123456') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ModifyData(),
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                          title: Text(
                            'Sorry',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          content: Text('Sorry incorrect Username or Password'),
                          elevation: 20,
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: mainBtn),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
