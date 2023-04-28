import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:give_away/components/custom_button.dart';
import 'package:give_away/pages/map/find_route.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class CustomMap extends StatefulWidget {
  final String cityName;

  const CustomMap(this.cityName, {Key? key}) : super(key: key);

  @override
  State<CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  LatLng? cityLocation;
  String cityName = '';
  late Future<LatLng> futureCityLocation;

  // _CustomMapState(this.cityName);
  @override
  void initState() {
    super.initState();
    cityName = widget.cityName;
  }

  Future<LatLng> getCityLocation(String cityName) async {
    final response = await http.get(Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$cityName&format=json&limit=1'));

    if (response.statusCode == 200) {
      final jsonResult = json.decode(response.body);

      if (jsonResult.isNotEmpty) {
        final latitude = double.parse(jsonResult[0]['lat']);
        final longitude = double.parse(jsonResult[0]['lon']);

        setState(() {
          cityLocation = LatLng(latitude, longitude);
        });

        return LatLng(latitude, longitude);
      }
    }
    throw Exception(jsonDecode(response.body));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<LatLng>(
            future: getCityLocation(cityName),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return FlutterMap(
                  options: MapOptions(
                    center: cityLocation,
                    zoom: 12.0,
                  ),
                  layers: [
                    TileLayerOptions(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayerOptions(
                      markers: [
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: cityLocation!,
                          builder: (ctx) => const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 64.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
              // else if (snapshot.hasError) {
              // }
              return const CircularProgressIndicator();
            },
          ),
          Positioned(
            top: 64,
            left: 24,
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 8,
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              width: MediaQuery.of(context).size.width,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(48),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 8,
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    cityName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: InkWell(
                      child: const IgnorePointer(
                        child: CustomButton(
                          buttonName: 'Find a route',
                        ),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FindRoute(cityName)),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
