import 'package:flutter/material.dart';
import '../models/Offer.dart';
import '../pages/custom_map.dart';
import '../components/custom_button.dart';

class CustomFindOnMapButton extends StatelessWidget {
  final Offer offer;

  const CustomFindOnMapButton(this.offer, {super.key});

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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: InkWell(
          child: const IgnorePointer(child: CustomButton(buttonName: 'Find on map')),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustomMap(offer.location),
              ),
            );
          },
        ),
      ),
    );
  }
}
