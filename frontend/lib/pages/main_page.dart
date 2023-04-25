import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/Offer.dart';
import 'package:logger/logger.dart';
import '../components/custom_item.dart';
import '../components/custom_item_list.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Future<List<Offer>> futureOffer;

  @override
  void initState() {
    super.initState();
    futureOffer = fetchOffer();
    final logger = Logger();

    futureOffer.then((offer) {
      logger.i(offer);
    });
  }

  Future<List<Offer>> fetchOffer() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/v1/offers'),
      headers: {
        HttpHeaders.authorizationHeader: 'Basic eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImR1YXAiLCJpYXQiOjE2ODIyODA1MTMsImV4cCI6MTY4MjM4MDUxM30.Whvmn8m0M5XvgNJL_lu9ZpuYjuyxCGlQVajfSGjgr1M',
      },
    );

    final logger = Logger();

    if (response.statusCode == 200) {
      return Offer.fromJsonArray(jsonDecode(response.body));
    } else {
      throw Exception(jsonDecode(response.body));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: FutureBuilder<List<Offer>>(
            future: futureOffer,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CustomItemList(snapshot.data!);
              }
              // else if (snapshot.hasError) {
              // }

              return const CircularProgressIndicator();
            },
          ),
        ),
      );
  }
}
