import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:give_away/components/custom_textfield.dart';
import 'package:give_away/components/custom_button.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;

class Register extends StatelessWidget {

   Register({super.key});

  // get http => null;
  final http.Client httpClient = http.Client();

  Future<String> createUser(String username, String password) async {
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/v1/auth/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create user.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    const storage = FlutterSecureStorage();

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
                            margin: const EdgeInsets.symmetric(vertical: 16.0),
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
                                      width: 1,
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                    ),
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
                        const CustomTextField(fieldName: "Email"),
                        const CustomTextField(fieldName: "Password"),
                        const CustomTextField(fieldName: "Repeat password"),

                        InkWell(
                          child: IgnorePointer(child:  CustomButton(buttonName:"Register")),
                            onTap: () {
                              createUser("text", "text");
                            },
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 16.0),
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
