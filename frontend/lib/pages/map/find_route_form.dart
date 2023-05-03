import 'dart:convert';
import 'package:flutter/material.dart';
import '../../components/custom_button.dart';
import '../../components/custom_icon_textfield.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'custom_map.dart';
import 'package:logger/logger.dart';

class FindRouteForm extends StatefulWidget {
  final String destination;

  const FindRouteForm(this.destination, {Key? key}) : super(key: key);

  @override
  State<FindRouteForm> createState() => _FindRouteFormState();
}

class _FindRouteFormState extends State<FindRouteForm> {
  final TextEditingController startingPointController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  Future<void>? getCurrentLocationFuture;

  @override
  void initState() {
    super.initState();
    getCurrentLocationFuture = getCurrentLocation();
    destinationController.text = widget.destination;
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      final response = await http.get(Uri.parse(
          "https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}"));

      if (response.statusCode == 200) {
        final jsonResult = json.decode(response.body);

        if (jsonResult.isNotEmpty) {
          final city = jsonResult['address']['city'];
          setState(() {
            startingPointController.text = "$city";
          });
        }
      }
    } catch (e) {
      var logger = Logger();
      logger.d(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: FutureBuilder<void>(
            future: getCurrentLocationFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          "Find the best route",
                          style: TextStyle(
                              fontSize: 28.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      CustomIconTextField(
                        fieldName: "Starting point",
                        controller: startingPointController,
                        icon: Icon(Icons.my_location,
                          size: 32.0,
                            color: Theme.of(context).colorScheme.primary),
                        onPressed: getCurrentLocation,
                      ),
                      CustomIconTextField(
                        fieldName: "Destination",
                        controller: destinationController,
                        icon: Icon(Icons.my_location,
                            size: 32.0,
                            color: Theme.of(context).colorScheme.primary),
                        onPressed: getCurrentLocation,
                      ),
                      InkWell(
                          child: const IgnorePointer(
                            child: CustomButton(
                              buttonName: 'Submit',
                            ),
                          ),
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CustomMap(startingPointController.text, destinationCityName: destinationController.text)));
                          }),
                    ],
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
