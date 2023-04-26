import 'package:flutter/material.dart';
import 'package:give_away/pages/main_page.dart';
import '../components/custom_menu.dart';

class CustomMap extends StatelessWidget {
  const CustomMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(
      children: [
        Text("Map", style: TextStyle(fontSize: 30, color: Colors.black),),
        Text("Map", style: TextStyle(fontSize: 30, color: Colors.black),),
      ],
    ));
  }
}
