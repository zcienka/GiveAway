import 'package:flutter/material.dart';

import '../pages/custom_map.dart';

class CustomFindOnMapButton extends StatelessWidget {
  const CustomFindOnMapButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.black12,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ButtonBar(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CustomMap()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(180, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text('Find on map'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
