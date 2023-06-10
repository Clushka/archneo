import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:freelance_app/screens/homescreen/home_screen.dart';
import 'package:freelance_app/screens/user/architect_signup_screen.dart';
import 'package:freelance_app/screens/user/role.dart';
import 'package:freelance_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:freelance_app/utils/clr.dart';

import 'package:freelance_app/config/firebase_auth_service.dart';
import 'package:freelance_app/widgets/custom_button.dart';
import 'package:freelance_app/screens/user/forgot_password.dart';
import 'package:freelance_app/utils/txt.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Color(0xffD2A244),
          ),
          automaticallyImplyLeading: false,
          title: const Padding(
            padding: EdgeInsets.only(left: 230),
            child: Text(
              "ArchNEO",
              style: TextStyle(color: Color(0xffD2A244)),
            ),
          ),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffD2A244), width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_sharp),
                        color: Color(0xffD2A244),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("Welcome Back!\nGlad to see you again",
                      style: TextStyle(
                        color: Color.fromARGB(255, 14, 14, 54),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                const SizedBox(height: 20),
                CustomTextfield(
                  myController: _emailController,
                  hintText: "Enter your Email",
                  isPassword: false,
                ),
                CustomTextfield(
                  myController: _passwordController,
                  hintText: "Enter your Password",
                  isPassword: true,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ForgotPassword()));
                      },
                      child: const Text("Forgot Password?",
                          style: TextStyle(
                            color: Color(0xff6A707C),
                            fontSize: 15,
                          )),
                    ),
                  ),
                ),
                CustomButton(
                  buttonText: "Login",
                  buttonColor: Color.fromARGB(255, 14, 14, 54),
                  textColor: Colors.white,
                  onPressed: () async {
                    try {
                      await FirebaseAuthService().login(
                          _emailController.text.trim(),
                          _passwordController.text.trim());

                      if (FirebaseAuth.instance.currentUser != null) {
                        setState(() {
                          _isLoading = true;
                        });
                        if (!mounted) return;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()));
                      }
                    } on FirebaseException catch (e) {
                      debugPrint("error is ${e.message}");
                      setState(
                        () {
                          _isLoading = false;
                        },
                      );

                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                  title: const Text(
                                      " Invalid Username or password. Please register again or make sure that username and password is correct"),
                                  actions: [
                                    ElevatedButton(
                                      child: const Text("Register Now"),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SignUpScreen()));
                                      },
                                    )
                                  ]));
                    }

                    // Navigator.push(context,
                    //    MaterialPageRoute(builder: (_) => const LoginScreen()));

                    setState(
                      () {
                        _isLoading = false;
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: RichText(
                    text: TextSpan(children: [
                      const TextSpan(
                        text: "Don't have an account?",
                        style: txt.body2Dark,
                      ),
                      const TextSpan(text: '   '),
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ChooseRoleScreen()),
                              ),
                        text: 'Register Now',
                        style: txt.mediumTextButton,
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _progressIndicator() {
    return const Center(
      child: SizedBox(
        height: 70,
        width: 70,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
