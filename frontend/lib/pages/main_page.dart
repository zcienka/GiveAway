import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/Offer.dart';
import '../components/custom_item_list.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Future<List<Offer>> futureOffer;
  final storage = const FlutterSecureStorage();
  var jwt = '';

  @override
  void initState() {
    super.initState();
    futureOffer = fetchOffer();
    readFromStorage();
  }

  Future<void> readFromStorage() async {
    String? value = await storage.read(key: 'jwt-token');

    jwt = value!;
    setState(() {
      futureOffer = fetchOffer();
    });
  }

  Future<List<Offer>> fetchOffer() async {
    final httpAddress = dotenv.env['HTTP_ADDRESS'];

    final response = await http.get(
      Uri.parse('$httpAddress/api/v1/offers'),
      headers: {
        HttpHeaders.authorizationHeader: 'Basic $jwt',
      },
    );

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
