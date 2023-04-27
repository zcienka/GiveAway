import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String fieldName;
  final TextEditingController controller;

  const CustomTextField(
      {super.key, required this.fieldName, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  fieldName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ))),
        TextField(
            controller: controller,
            style: const TextStyle(fontSize: 16),
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.all(12.0),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    width: 1.0),
                borderRadius: BorderRadius.circular(12.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline, width: 1.0),
                borderRadius: BorderRadius.circular(12.0),
              ),
            )),
      ],
    );
  }
}
