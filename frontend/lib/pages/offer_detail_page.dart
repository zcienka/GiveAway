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
              height: 240,
              child: ClipRRect(
                child: Image.network(
                  offer.img ?? '',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 24,
              left: 24,
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.12),
                      spreadRadius: 24,
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(1000.0),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 8,
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        offer.location,
                        style: const TextStyle(
                          fontSize: 20,
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
                      padding: const EdgeInsets.symmetric(vertical: 4),
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
      bottomNavigationBar: CustomFindOnMapButton(offer),
    );
  }
}
