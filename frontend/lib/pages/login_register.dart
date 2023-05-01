import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:give_away/components/custom_textfield.dart';
import 'package:give_away/components/custom_button.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'main_page.dart';

class Register extends StatelessWidget {
  Register({super.key});

  final httpAddress = dotenv.env['HTTP_ADDRESS'];
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _repeatPassword = TextEditingController();

  Future<void> createUser(
      String username, String password, BuildContext context) async {
    final response = await http.post(
      Uri.parse('$httpAddress/api/auth/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );


    if (response.statusCode == 200) {
      const storage = FlutterSecureStorage();
      await storage.write(key: 'jwt-token', value: jsonDecode(response.body)['jwt']);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    } else {
      throw Exception('Failed to create the user.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            color: Theme.of(context).colorScheme.background,
            child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 32.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 1,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(16))),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Create new account",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Column(children: [
                        Container(
                            margin: const EdgeInsets.symmetric(vertical: 16),
                            child: OutlinedButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  minimumSize: MaterialStateProperty.all(
                                      const Size.fromHeight(48)),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    side: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                        width: 2.0),
                                  )),
                                ),
                                child: Text(
                                  "Log in with Google",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground),
                                ))),
                        Text("or sign in with your email",
                            style: TextStyle(
                                fontSize: 16,
                                color:
                                    Theme.of(context).colorScheme.secondary)),
                        CustomTextField(fieldName: "Email", controller: _email),
                        CustomTextField(
                            fieldName: "Password", controller: _password),
                        CustomTextField(
                            fieldName: "Repeat password",
                            controller: _repeatPassword),
                        InkWell(
                          child: const IgnorePointer(
                              child: CustomButton(buttonName: "Register")),
                          onTap: () {
                            createUser(_email.text, _password.text, context);
                          },
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                                text: TextSpan(
                                    text: 'Already have an account? ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                    children: <InlineSpan>[
                                  TextSpan(
                                    text: 'Login',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ])),
                          ),
                        )
                      ]),
                    ]))),
      ),
    ));
  }
}
