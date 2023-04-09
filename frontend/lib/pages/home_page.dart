import 'package:flutter/material.dart';
import 'package:give_away/components/custom_searchfield.dart';
import 'package:give_away/pages/main_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SafeArea(child:
        MainPage()));
  }
}
