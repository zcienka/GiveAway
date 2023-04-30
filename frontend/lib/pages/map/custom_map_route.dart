import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:give_away/components/custom_button.dart';
import 'package:give_away/pages/map/find_route_form.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class CustomMapRoute extends StatefulWidget {
  final String cityName;

  const CustomMapRoute(this.cityName, {Key? key}) : super(key: key);

  @override
  State<CustomMapRoute> createState() => _CustomMapRouteState();
}

class _CustomMapRouteState extends State<CustomMapRoute> {
  LatLng? cityLocation;
  String cityName = '';
  late Future<LatLng> futureCityLocation;

  @override
  void initState() {
    super.initState();
    cityName = widget.cityName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(cityName)));
  }
}
