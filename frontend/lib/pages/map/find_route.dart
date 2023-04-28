import 'dart:convert';
import 'package:flutter/material.dart';
import '../../components/custom_button.dart';
import '../../components/custom_icon_textfield.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;

class FindRoute extends StatefulWidget {
  final String destination;

  const FindRoute(this.destination, {Key? key}) : super(key: key);

  @override
  State<FindRoute> createState() => _FindRouteState();
}

class _FindRouteState extends State<FindRoute> {
  final TextEditingController startingPointController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  Future<void>? _getCurrentLocationFuture;

  @override
  void initState() {
    super.initState();
    _getCurrentLocationFuture = getCurrentLocation();
    destinationController.text = widget.destination;
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      final response = await http.get(Uri.parse("https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}"));

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
      developer.log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  "Find the best route",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              FutureBuilder<void>(
                future: _getCurrentLocationFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return CustomIconTextField(
                      fieldName: "Starting point",
                      controller: startingPointController,
                      icon: Icon(Icons.my_location,
                          size: 32.0, color: Theme.of(context).colorScheme.primary),
                      onPressed: getCurrentLocation,
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              CustomIconTextField(
                fieldName: "Destination",
                controller: destinationController,
                icon: Icon(Icons.my_location,
                    size: 32.0, color: Theme.of(context).colorScheme.primary),
                onPressed: getCurrentLocation,
              ),
              const CustomButton(
                buttonName: "Submit",
              )
            ],
          ),
        ),
      ),
    );
  }
}
