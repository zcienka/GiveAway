import 'package:flutter/material.dart';

class CustomItem extends StatelessWidget {
  final String? s;
  final String? imageUrl;

  const CustomItem(this.s, this.imageUrl, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = s ?? 'No items found';
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      height: 320,
      decoration: BoxDecoration(
        // color:  colorScheme.background,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: Container(
        // padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            border: Border.all(color: colorScheme.outline, width: 1)),
        // child: Text(text),
        child: Container(
          child: Column(
            children: [
              if (imageUrl != null) Image.network(imageUrl!),
              Text(text),
            ],
          ),
        )
      ),
    );
  }
}
