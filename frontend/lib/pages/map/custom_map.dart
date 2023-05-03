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
  LatLng? startingPointCityCoordinates;
  LatLng? destinationCoordinates;
  String startingPointCityName = '';
  String destinationCityName = '';
  List<LatLng> pathCoordinates = [];
  late Future<void> futurePath;
  final apiKey = dotenv.env['OPEN_ROUTE_SERVICE_API_KEY'];
  final List<Marker> markers = [];
  late double travelDuration = 0;

  @override
  void initState() {
    super.initState();
    startingPointCityName = widget.startingPointCityName;

    if (widget.destinationCityName != null) {
      destinationCityName = widget.destinationCityName!;
    }
    futurePath = fetchMapsAndPaths();
  }

  Future<LatLng> getCityCoordinates(
      String cityName, bool setDestination) async {
    if (cityName != '') {
      final response = await http.get(Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=$cityName&format=json&limit=1'));

      if (response.statusCode == 200) {
        final jsonResult = json.decode(response.body);

        if (jsonResult.isNotEmpty) {
          final latitude = double.parse(jsonResult[0]['lat']);
          final longitude = double.parse(jsonResult[0]['lon']);

          if (!setDestination) {
            startingPointCityCoordinates = LatLng(latitude, longitude);
          } else {
            destinationCoordinates = LatLng(latitude, longitude);
          }

          return LatLng(latitude, longitude);
        }
      }
      throw Exception(jsonDecode(response.body));
    }
    throw Exception(jsonDecode('City name is empty'));
  }

  Future<void> getPath(List<LatLng> val) async {
    final startingCityLatitude =
        startingPointCityCoordinates?.latitude.toString();
    final startingCityLongitude =
        startingPointCityCoordinates?.longitude.toString();

    final destinationLatitude = destinationCoordinates?.latitude.toString();
    final destinationLongitude = destinationCoordinates?.longitude.toString();

    final response = await http.get(
      Uri.parse(
          'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=$startingCityLongitude,$startingCityLatitude&end=$destinationLongitude,$destinationLatitude'),
    );

    if (response.statusCode == 200) {
      Logger logger = Logger();
      final jsonResult = json.decode(response.body);
      logger.d(
          jsonResult['features'][0]['properties']['segments'][0]['duration']);

      final coords = jsonResult['features'][0]['geometry']['coordinates'];
      final seconds =
          jsonResult['features'][0]['properties']['segments'][0]['duration'];

      Duration durationInMinutes = Duration(seconds: seconds.toInt());
      double hours =
          durationInMinutes.inHours + (durationInMinutes.inMinutes % 60) / 60.0;

      setState(() {
        travelDuration = hours;
      });

      if (pathCoordinates.isEmpty) {
        for (var element in coords) {
          pathCoordinates.add(LatLng(element[1], element[0]));
        }
      }
    }
  }

  Future<LatLng> fetchMapsAndPaths() async {
    LatLng startingPointCityCoordinates =
        await getCityCoordinates(startingPointCityName, false);
    LatLng destinationCoordinates =
        await getCityCoordinates(destinationCityName, true);

    List<LatLng> pathCoordinates = [
      startingPointCityCoordinates,
      destinationCoordinates
    ];
    await getPath(pathCoordinates);
    return destinationCoordinates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
            future: futurePath,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return FlutterMap(
                  options: MapOptions(
                    center: startingPointCityCoordinates,
                    zoom: 8,
                  ),
                  layers: [
                    TileLayerOptions(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c']),
                    PolylineLayerOptions(
                      polylines: [
                        Polyline(
                          points: pathCoordinates,
                          color: Theme.of(context).colorScheme.primary,
                          strokeWidth: 12,
                          borderStrokeWidth: 5,
                          borderColor: Colors.indigo,
                          isDotted: true,
                        ),
                      ],
                    ),
                    MarkerLayerOptions(
                      markers: [
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: startingPointCityCoordinates!,
                          builder: (ctx) => const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 54.0,
                          ),
                        ),
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: destinationCoordinates!,
                          builder: (ctx) => const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 54.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
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
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
              width: MediaQuery.of(context).size.width,
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
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.place_rounded,
                                color: Theme.of(context).colorScheme.secondary),
                            Text(
                              startingPointCityName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (destinationCityName != '' && travelDuration != 0)
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                travelDuration.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              Text(
                                ' hours',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  destinationCityName == ''
                      ? SizedBox(
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
                                        FindRouteForm(startingPointCityName)),
                              );
                            },
                          ),
                        )
                      : Row(children: [
                          Icon(Icons.place_rounded,
                              color: Theme.of(context).colorScheme.secondary),
                          Text(
                            destinationCityName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
