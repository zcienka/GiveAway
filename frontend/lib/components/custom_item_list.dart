import 'package:flutter/material.dart';
import 'package:give_away/models/Offer.dart';
import 'package:give_away/components/custom_item.dart';

class CustomItemList extends StatelessWidget {
  final List<Offer> offers;

  const CustomItemList(this.offers, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      itemCount: offers.length,
      itemBuilder: (BuildContext context, int index) {
        final offer = offers[index];
        return CustomItem(offer);
      },
    );
  }
}