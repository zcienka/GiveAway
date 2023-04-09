import 'package:flutter/cupertino.dart';

class CustomItem extends StatelessWidget {
  const CustomItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 16.0),
        child: const Text('Custom Item')
    );
  }
}