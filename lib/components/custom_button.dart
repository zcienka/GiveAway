import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonName;

  const CustomButton({super.key, required this.buttonName});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 16.0),
        child: OutlinedButton(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).colorScheme.primary),
              minimumSize: MaterialStateProperty.all(const Size.fromHeight(48)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(12),
                ),
                side: BorderSide(
                  width: 1,
                  color: Theme.of(context).colorScheme.outline,
                ),
              )),
            ),
            child: Text(
              buttonName,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.inversePrimary),
            )));
  }
}
