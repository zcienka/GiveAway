import 'dart:convert';
import 'package:flutter/material.dart';
import '../../components/custom_button.dart';
import '../../components/custom_icon_textfield.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'custom_map.dart';

class FindRouteForm extends StatefulWidget {
  final String destination;

  const FindRouteForm(this.destination, {Key? key}) : super(key: key);

  @override
  State<FindRouteForm> createState() => _FindRouteFormState();
}

class _FindRouteFormState extends State<FindRouteForm> {
  final TextEditingController _startingPointController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  Future<void>? _getCurrentLocationFuture;

  @override
  void initState() {
    super.initState();
    _getCurrentLocationFuture = getCurrentLocation();
    _destinationController.text = widget.destination;
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
            _startingPointController.text = "$city";
          });
        }
      }
    } catch (e) {
      developer.log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: FutureBuilder<void>(
          future: _getCurrentLocationFuture,
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
                      controller: _startingPointController,
                      icon: Icon(Icons.my_location,
                        size: 32.0,
                          color: Theme.of(context).colorScheme.primary),
                      onPressed: getCurrentLocation,
                    ),
                    CustomIconTextField(
                      fieldName: "Destination",
                      controller: _destinationController,
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
                                      CustomMap(_startingPointController.text, destinationCityName: _destinationController.text)));
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
    );
  }
}
