import 'package:flutter/material.dart';

import '../components/custom_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../components/Offer.dart';
import 'package:logger/logger.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Future<Offer> futureOffer;

  @override
  void initState() {
    super.initState();
    futureOffer = fetchOffer();
    final logger = Logger();

    futureOffer.then((offer) {
      logger.i(offer);
    });

  }
  Future<Offer> fetchOffer() async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:8000/api/v1/offers'));

    final logger = Logger();
    // logger.i(jsonDecode(response.body)[0].title);
    logger.i(response.statusCode);

    if (response.statusCode == 200) {
      return Offer.fromJson(jsonDecode(response.body)[0]);
    } else {
      throw Exception(jsonDecode(response.body));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Offer>(
            future: futureOffer,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.description);
              }
              // else if (snapshot.hasError) {
              //   return Text('${snapshot.error}');
              // }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
