import 'package:flutter/material.dart';
import 'package:give_away/components/custom_button.dart';
import 'package:give_away/pages/main_page.dart';
import '../components/custom_menu.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Text('404',
                style: TextStyle(
                  fontSize: 96,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                )),
            Text('Something went wrong',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                )),
            InkWell(
              child: const CustomButton(buttonName: "Go back"),
              onTap: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    ))));
  }
}
