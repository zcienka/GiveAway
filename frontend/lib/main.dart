import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:give_away/pages/map/custom_map.dart';
import 'package:give_away/pages/login_register.dart';
import 'package:give_away/pages/home_page.dart';
import 'package:flutter/services.dart';
import 'package:give_away/pages/main_page.dart';
import 'package:give_away/pages/map/find_route_form.dart';

void main() async {
  await dotenv.load(fileName: "assets/.env");
  final ThemeData base = ThemeData.light();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.black),
  );

  runApp(MaterialApp(
      home: Theme(
    data: ThemeData(
      fontFamily: 'Inter',
      colorScheme: base.colorScheme.copyWith(
          primary: const Color(0xff3585FD),
          onPrimaryContainer: const Color(0xffE9E7EE),
          onError: const Color(0xffFD4135),
          background: const Color(0xfff3f3f3),
          onBackground: const Color(0xff0F0F0F),
          secondaryContainer: const Color(0xffEAE9E9),
          secondary: const Color(0xff7A7A7A),
          tertiary: const Color(0xfff9f9f9),
          outline: const Color(0xffd6d6d6),
          outlineVariant: const Color(0xff878787)),
      textTheme: const TextTheme(
              displayLarge:
                  TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
              titleLarge:
                  TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
              bodyMedium: TextStyle(fontSize: 14.0),
              bodySmall: TextStyle(fontSize: 12.0))
          .apply(
        bodyColor: const Color(0xff0F0F0F),
      ),
    ),
        child: const LoginRegister(),
      )));
}
