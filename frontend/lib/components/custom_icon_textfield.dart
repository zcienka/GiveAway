import 'package:flutter/material.dart';

class CustomIconTextField extends StatelessWidget {
  final String fieldName;
  final Icon icon;
  final TextEditingController controller;
  final VoidCallback onPressed;

  const CustomIconTextField(
      {super.key,
      required this.fieldName,
      required this.controller,
      required this.icon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
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
              suffixIcon: GestureDetector(
                onTap: onPressed,
                child: icon,
              ),
              contentPadding: const EdgeInsets.all(12),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    width: 2.0),
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline, width: 1.0),
                borderRadius: BorderRadius.circular(12),
              ),
            )),
      ],
    );
  }
}
