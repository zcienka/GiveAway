import 'package:flutter/material.dart';
import 'package:give_away/components/custom_searchfield.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(child: Column(children: const [
          CustomSearchField()
        ])));
  }
}
