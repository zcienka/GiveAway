import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:give_away/components/custom_textfield.dart';
import 'package:give_away/components/custom_button.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'error_page.dart';
import 'main_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/gestures.dart';

class LoginRegister extends StatefulWidget {
  const LoginRegister({super.key});

  @override
  State<LoginRegister> createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  final httpAddress = dotenv.env['HTTP_ADDRESS'];
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController repeatPassword = TextEditingController();
  bool isLogin = true;

  Future<void> createUser(
      String username, String password, BuildContext context) async {
    final response = await http.post(
      Uri.parse(isLogin ? '$httpAddress/api/auth/login' : '$httpAddress/api/auth/register'),
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
      await storage.write(
          key: 'jwt-token', value: jsonDecode(response.body)['jwt']);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    } else {
      throw Exception('Failed to create the user.');
    }
  }

  Future<void> getJwt(String? username, BuildContext context) async {
    final response = await http.post(
      Uri.parse('$httpAddress/api/auth/jwt'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String?>{
        'username': username,
      }),
    );

    if (response.statusCode == 200) {
      const storage = FlutterSecureStorage();
      await storage.write(
          key: 'jwt-token', value: jsonDecode(response.body)['jwt']);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ErrorPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
      ],
    );

    return Scaffold(
        body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: Theme.of(context).colorScheme.background,
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: 1,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(16))),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isLogin ? 'Welcome back' : "Create new account",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Column(children: [
                          Container(
                              margin: const EdgeInsets.symmetric(vertical: 16),
                              child: OutlinedButton(
                                  onPressed: () {
                                    _googleSignIn.isSignedIn().then((value) {
                                      if (value) {
                                        getJwt(
                                            _googleSignIn
                                                .currentUser?.displayName,
                                            context);
                                      } else {
                                        _googleSignIn.signIn().then((value) {
                                          getJwt(
                                              _googleSignIn
                                                  .currentUser?.displayName,
                                              context);
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const MainPage()),
                                          );
                                        });
                                      }
                                    });
                                  },
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
                                          width: 2),
                                    )),
                                  ),
                                  child: Text(
                                    "Login with Google",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground),
                                  ))),
                          isLogin
                              ? Text('or login with your email',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary))
                              : Text('or sign up with your email',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary)),
                          CustomTextField(
                              fieldName: "Email",
                              controller: email,
                              isPassword: false),
                          CustomTextField(
                              fieldName: "Password",
                              controller: password,
                              isPassword: true),
                          if (!isLogin)
                            CustomTextField(
                                fieldName: "Repeat password",
                                controller: repeatPassword,
                                isPassword: true),
                          InkWell(
                            child: IgnorePointer(
                                child: CustomButton(
                                    buttonName:
                                        isLogin ? "Login" : "Register")),
                            onTap: () {
                              createUser(email.text, password.text, context);
                            },
                          ),
                          isLogin ?
                          Container(
                            margin: const EdgeInsets.only(top: 16),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: RichText(
                                  text: TextSpan(
                                      text: "Don't have an account yet? ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text: 'Sign up',
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () => setState(() {isLogin = false;}),
                                          style: TextStyle(
                                            fontSize: 16,
                                            decoration: TextDecoration.underline,
                                            decorationThickness: 2,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      ])),
                            ),
                          ) : Container(
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
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => setState(() {isLogin = true;}),
                                      style: TextStyle(
                                        fontSize: 16,
                                        decoration: TextDecoration.underline,
                                        decorationThickness: 2,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ])),
                            ),
                          )
                        ]),
                      ])
              )
          ),
        ),
      ),
    ));
  }
}
