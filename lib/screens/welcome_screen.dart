import 'package:flutter/material.dart';
import 'package:freelance_app/screens/user/login_screen.dart';
import 'package:freelance_app/screens/user/role.dart';

import '../widgets/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: const BoxDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(
              height: 300,
              //width: 180,
              child: Image(
                  image: AssetImage("assets/images/logo_archneo.png"),
                  fit: BoxFit.fill),
            ),
            // const SizedBox(height: 20),
            Text('ARCHNEO',
                style: TextStyle(
                    fontSize: 30.0,
                    color: Color.fromARGB(255, 14, 14, 54),
                    fontFamily: 'Impact')),
            const SizedBox(height: 20),

            CustomButton(
              buttonText: "Login",
              buttonColor: Color.fromARGB(255, 14, 14, 54),
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                );
              },
            ),
            CustomButton(
              buttonText: "Register",
              buttonColor: Colors.white,
              textColor: Color.fromARGB(255, 14, 14, 54),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ChooseRoleScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            Column(
              children: const [
                Text(
                  'We make design easier for everyone!',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
