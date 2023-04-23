import 'package:flutter/material.dart';
import 'package:give_away/components/custom_textfield.dart';
import 'package:give_away/components/custom_button.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery
        .of(context)
        .size
        .height;

    final width = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
        body: Center(
            child: Container(
                color: Theme
                    .of(context)
                    .colorScheme
                    .background,
                padding: EdgeInsets.symmetric(
                    vertical: height * 0.10, horizontal: 8),
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 24.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 1,
                          color: Theme
                              .of(context)
                              .colorScheme
                              .outline,
                        ),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(16))),
                    child: Column(children: [
                      Text(
                        "Create new account",
                        style: Theme
                            .of(context)
                            .textTheme
                            .titleLarge,
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
                                          Theme
                                              .of(context)
                                              .colorScheme
                                              .outline,
                                        ),
                                      )),
                                ),
                                child: Text(
                                  "Log in with Google",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Theme
                                          .of(context)
                                          .colorScheme
                                          .onBackground),
                                ))),
                        Text("or sign in with your email",
                            style: TextStyle(
                                fontSize: 16,
                                color:
                                Theme
                                    .of(context)
                                    .colorScheme
                                    .secondary)),
                        const CustomTextField(fieldName: "Email"),
                        const CustomTextField(fieldName: "Password"),
                        const CustomTextField(fieldName: "Repeat password"),
                        const CustomButton(buttonName: "Register"),
                        Container(
                          margin: const EdgeInsets.only(top: 16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                                text: TextSpan(
                                    text: 'Already have an account? ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Theme
                                            .of(context)
                                            .colorScheme
                                            .secondary),
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text: 'Login',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color:
                                          Theme
                                              .of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    ])),
                          ),
                        )
                      ]),
                    ])))));
  }
}