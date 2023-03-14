import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSearchField extends StatelessWidget {
  const CustomSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          prefixIcon: SvgPicture.asset('assets/icons/magnifyingGlass.svg'),
          filled: true,
          fillColor: Theme.of(context).colorScheme.onPrimaryContainer,
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
        ));
  }
}
