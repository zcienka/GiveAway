import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:give_away/components/custom_button.dart';
import 'package:give_away/pages/map/find_route_form.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

class CustomMap extends StatefulWidget {
  final String startingPointCityName;
  final String? destinationCityName;

  const CustomMap(this.startingPointCityName,
      {this.destinationCityName, Key? key})
      : super(key: key);

  @override
  State<CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  LatLng? _cityLocation;
  String _startingPointCityName = '';
  String _destinationCityName = '';
  List<LatLng> _coordinates = [];
  late Future<LatLng> _futureCityLocation;
  final _apiKey = dotenv.env['OPEN_ROUTE_SERVICE_API_KEY'];
  final List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _startingPointCityName = widget.startingPointCityName;

    if (widget.destinationCityName != null) {
      _destinationCityName = widget.destinationCityName!;
    }
  }

  Future<LatLng> getCityLocation(String startingPointCityName) async {
    if (_coordinates.isEmpty) {
      getPath();
    }

    final response = await http.get(Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$startingPointCityName&format=json&limit=1'));

    if (response.statusCode == 200) {
      final jsonResult = json.decode(response.body);

      if (jsonResult.isNotEmpty) {
        final latitude = double.parse(jsonResult[0]['lat']);
        final longitude = double.parse(jsonResult[0]['lon']);

        setState(() {
          _cityLocation = LatLng(latitude, longitude);
        });

        return LatLng(latitude, longitude);
      }
    }
    throw Exception(jsonDecode(response.body));
  }

  Future<void> getPath() async {
    if (widget.destinationCityName != '' &&
        widget.destinationCityName != null) {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      };
      final response = await http.get(
        Uri.parse(
            'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$_apiKey&start=-122.073827,37.386051&end=-122.078827,37.386051'),
      );

      if (response.statusCode == 200) {
        final jsonResult = json.decode(response.body);

        if (jsonResult.isNotEmpty) {
          final coords = jsonResult['features'][0]['geometry']['coordinates'];

          if (_coordinates.isEmpty) {
            setState(() {
              for (var element in coords) {
                _coordinates.add(LatLng(element[1], element[0]));
              }
            });
          }
        }
      }
      throw Exception(jsonDecode(response.body));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<LatLng>(
            future: getCityLocation(_startingPointCityName),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return FlutterMap(
                  options: MapOptions(
                    center: _cityLocation,
                    zoom: 13,
                  ),
                  layers: [
                    TileLayerOptions(
                      urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                    ),
                    PolylineLayerOptions(
                      polylines: [
                        Polyline(
                          points: _coordinates,
                          color: Colors.red,
                          strokeWidth: 4,
                        ),
                      ],
                    ),
                    MarkerLayerOptions(
                      markers: [
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: _cityLocation!,
                          builder: (ctx) =>
                          const Icon(
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
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
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
                    _startingPointCityName,
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
                              builder: (context) =>
                                  FindRouteForm(_startingPointCityName)),
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
