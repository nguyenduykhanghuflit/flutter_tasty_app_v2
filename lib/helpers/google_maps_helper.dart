
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
Future<Position> checkPermission() async {
  final Logger logger = Logger();

  try {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) print('Location services are disabled.');

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) print('Location permissions are denied');
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied, we cannot request permissions.');
    }
  } catch (error) {
    print('>>> Error check location permission: $error');
  }

  return await Geolocator.getCurrentPosition();
}

Future<LatLng> getCurrentLocation() async {
  final Logger logger = Logger();

  try {
    final Position position = await checkPermission();
    return LatLng(position.latitude, position.longitude);
  } catch (error) {
 print('>>> Error get current location: $error');
  }

  return const LatLng(0, 0);
}
Marker customMarker(String id, LatLng position, String title,String name) {
  return Marker(
    markerId: MarkerId(id),
    position: position,
    infoWindow: InfoWindow(title: title,snippet: name),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
    // onTap: () => (getCurrentPoint != null) ? getCurrentPoint(position) : null,
  );
}

Future<String> makeGetRequest(LatLng latLng) async {

  const key='QSh03i04EegegI8PRkYYDnC2tci4ZDn4';
  String url='https://www.mapquestapi.com/geocoding/v1/reverse?key=$key&location=${latLng.latitude},${latLng.longitude}';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return getAddressFromResponse(response.body);
  } else {
    return ("Lỗi ${response.statusCode}");
  }
}

Future<LatLng> getLatLngFromAddress(String address) async {

  const key='QSh03i04EegegI8PRkYYDnC2tci4ZDn4';
  String url='https://www.mapquestapi.com/geocoding/v1/address?key=$key&location=$address';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body); // Parse JSON thành Map

// Lấy giá trị lat và lng từ response
    double lat = data['results'][0]['locations'][0]['latLng']['lat'];
    double lng = data['results'][0]['locations'][0]['latLng']['lng'];
    return  LatLng(lat, lng);
  } else {
    return const LatLng(0, 0);
  }
}

String getAddressFromResponse(String responseJson) {
  Map<String, dynamic> responseMap = jsonDecode(responseJson);

  if (responseMap['info']['statuscode'] == 0) {
    List<dynamic> locations = responseMap['results'][0]['locations'];
    if (locations.isNotEmpty) {
      Map<String, dynamic> address = locations[0];

      String street = address['street'];
      String adminArea6 = address['adminArea6']; //phường
      String adminArea5 = address['adminArea5'];//quâận
      String adminArea4 = address['adminArea4'];//thành phố

      return '$street, $adminArea6, $adminArea5, $adminArea4';
    }
    return 'Lỗi chưa load được vị trí...';
  }
  else {
    return 'Lỗi chưa load được vị trí...';
  }
}