import 'package:flutter/material.dart';
import 'package:give_away/models/Offer.dart';

class CustomMenu extends StatelessWidget {
  const CustomMenu({Key? key}) : super(key: key);

  // const CustomMenu({required this.onPressed});

  // final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 72.0,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search, size: 32.0),
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          SizedBox(
            width: 60.0,
            height: 60.0,
            child: FloatingActionButton(
              // onPressed: onPressed,
              onPressed: () {},
              backgroundColor: Colors.blue,
              elevation: 2.0,
              child: const Icon(Icons.add, size: 48.0),
            ),
          ),
          Expanded(
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.person, size: 32.0),
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
