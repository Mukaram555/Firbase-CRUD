import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstday/screen/signUp.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'mainpage.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;
  final auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  void logIn() async{
   await auth.signInWithEmailAndPassword(
       email: emailController.text,
       password: passwordController.text.toString()).then((value){
     Fluttertoast.showToast(msg:value.user!.email.toString());
     Navigator.push(context,
         MaterialPageRoute(builder: (context) => const HomePage())
     );
    }).onError((error, stackTrace) {
      Fluttertoast.showToast(msg: error.toString());
   });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.08,
            ),
            Container(
              height: 100,
              width: 100,
              color: Colors.white,
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.08,
            ),
            Expanded(
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(80),
                  ),
                  color: Colors.white.withOpacity(0.95),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.sizeOf(context).width * 0.1,
                    right: MediaQuery.sizeOf(context).width * 0.1,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Login",
                          style: TextStyle(
                            fontSize: MediaQuery.sizeOf(context).height * 0.04,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.08,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          decoration: const InputDecoration(
                            hintText: "pakistan@gmail.com",
                            labelText: "Email",
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            filled: true,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.04,
                        ),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: "**********",
                            labelText: "Password",
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            filled: true,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.04,
                        ),
                        InkWell(
                          onTap: (){
                            logIn();
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                              color: Colors.black,
                            ),
                            width: MediaQuery.sizeOf(context).width,
                            height: MediaQuery.sizeOf(context).height * 0.06,
                            child: const Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.09,
                        ),
                        Row(
                          children: [
                             const Text("Don't have any account?"),
                            InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignUp(),),);
                              },
                              child: const Text(
                                "SignUp",style: TextStyle(fontWeight: FontWeight.bold,),),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
