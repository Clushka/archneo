import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:freelance_app/screens/user/login_screen.dart';
import 'package:freelance_app/screens/user/architect_signup_screen.dart';

import '../../widgets/custom_button.dart';
import 'client_signup_screen.dart';
import 'package:freelance_app/utils/txt.dart';

class ChooseRoleScreen extends StatelessWidget {
  const ChooseRoleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          //height: MediaQuery.of(context).size.height,
          //width: double.infinity,
          decoration: const BoxDecoration(
              /*
            image: DecorationImage(
              image: AssetImage("assets/images/logo.png"),
            ),

            */
              ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 300,
                //width: 180,
                child: Image(
                    image: AssetImage("assets/images/logo_archneo.png"),
                    fit: BoxFit.fill),
              ),
              const SizedBox(height: 20),
              CustomButton(
                buttonText: "Client",
                buttonColor: Colors.black,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ClientSignUpScreen(),
                    ),
                  );
                },
              ),
              CustomButton(
                buttonText: "Architect",
                buttonColor: Colors.white,
                textColor: Color.fromARGB(255, 14, 14, 54),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SignUpScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Choose your role",
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: RichText(
                  text: TextSpan(children: [
                    const TextSpan(
                      text: 'Already have an account?',
                      style: txt.body2Dark,
                    ),
                    const TextSpan(text: '   '),
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            ),
                      text: 'Login',
                      style: txt.mediumTextButton,
                    ),
                  ]),
                ),
              ),
            ],
          )),
    );
  }
}
