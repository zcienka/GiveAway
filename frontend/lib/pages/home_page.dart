import 'package:flutter/material.dart';
import 'package:give_away/pages/main_page.dart';
import '../components/custom_menu.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SafeArea(child: MainPage()), bottomNavigationBar: CustomMenu());
  }
}
