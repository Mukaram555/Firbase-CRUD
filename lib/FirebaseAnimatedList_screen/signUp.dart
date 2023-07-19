import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstday/Screens/homePage.dart';
import 'package:firstday/screen/login_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final cPasswordController = TextEditingController();
  final auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                height: MediaQuery.sizeOf(context).height * 0.04,
              ),
              Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: MediaQuery.sizeOf(context).height * 0.04,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.04,
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
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.08,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.name,
                              controller: firstName,
                              decoration: const InputDecoration(
                                hintText: "Ali",
                                labelText: "First Name",
                                labelStyle: TextStyle(
                                    fontSize: 16),
                                border: InputBorder.none,
                                fillColor: Colors.white,
                                filled: true,
                              ),
                              validator: (name){
                                if(name!.isEmpty){
                                  return "Please Enter Your Name";
                                }
                                else if(name!.length < 3){
                                  return "Name Must be at Least 3 Characters";
                                }
                              },
                            ),
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.04,
                            ),


                            TextFormField(
                              keyboardType: TextInputType.name,
                              controller: lastName,
                              decoration: const InputDecoration(
                                hintText: "Khan",
                                labelText: "Last Name",
                                labelStyle: TextStyle(
                                     fontSize: 16),
                                border: InputBorder.none,
                                fillColor: Colors.white,
                                filled: true,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.04,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              decoration: const InputDecoration(
                                hintText: "pakistan@gmail.com",
                                labelText: "Email",
                                labelStyle: TextStyle(
                                    fontSize: 16),
                                border: InputBorder.none,
                                fillColor: Colors.white,
                                filled: true,
                              ),
                              validator: (email)=> email!.isEmpty || !email.contains('@') ? "Enter Valid Email":null,
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
                                    fontSize: 16),
                                border: InputBorder.none,
                                fillColor: Colors.white,
                                filled: true,
                              ),
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'Please Enter Your Password';
                                }
                                else if(value!.length < 8){
                                  return 'Password Must be at-least 8 characters';
                                }
                              },
                            ),
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.04,
                            ),
                            TextFormField(
                              controller: cPasswordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: "**********",
                                labelText: "Confirm Password",
                                labelStyle: TextStyle(
                                    fontSize: 16),
                                border: InputBorder.none,
                                fillColor: Colors.white,
                                filled: true,
                              ),
                              validator: (cPassword){
                                if(cPassword!.isEmpty){
                                  return "Please Enter Your Confirm Password";
                                }
                                else if(cPassword != passwordController.text){
                                  return "Password and ConfirmPassword Does Not match";
                                }
                                else{
                                  return null;
                                }
                              },
                            ),
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.04,
                            ),
                            InkWell(
                              onTap: (){
                                if(formKey.currentState!.validate()){
                                  setState(() {
                                    loading = true;
                                  });
                                  auth.createUserWithEmailAndPassword(email: emailController.text.toString(), password: passwordController.text.toString()).then((value){
                                    Fluttertoast.showToast(msg: "Account Created Successfully");
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddPage(),),);
                                  }).onError((error, stackTrace) {
                                    Fluttertoast.showToast(msg: error.toString());
                                  });
                                }
                              },
                              child: Center(
                                child: loading ? const CircularProgressIndicator() : Container(
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
                                      "Register",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
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
                                const Text("Already have an Account?"),
                                InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginPage(),),);
                                  },
                                  child: const Text(
                                    "Log In",style: TextStyle(fontWeight: FontWeight.bold,),),
                                )
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.04,
                            ),
                          ],
                        ),
                      ),
                    ),
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
