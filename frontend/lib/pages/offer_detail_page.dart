import 'package:flutter/material.dart';
import '../components/custom_find_on_map_button.dart';
import '../models/Offer.dart';

class OfferDetailPage extends StatelessWidget {
  final Offer offer;

  const OfferDetailPage(this.offer, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: 280,
              child: ClipRRect(
                child: Image.network(
                  offer.img ?? '',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 240),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        offer.location,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Text("Phone number",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        )),
                    const Text(
                      "666 666 666",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        offer.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomFindOnMapButton(),
    );
  }
}
