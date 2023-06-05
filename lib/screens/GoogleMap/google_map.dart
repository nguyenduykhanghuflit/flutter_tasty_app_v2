import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:tasty_app_v2/screens/CreatePlace/create_place_page.dart';
import 'package:tasty_app_v2/state/global_state.dart';

import '../../helpers/google_maps_helper.dart';


class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  final GlobalController ctrl = Get.find();
  final Logger logger = Logger();
  final Completer<GoogleMapController> kGgController = Completer<GoogleMapController>();
  LatLng _initLocation = const LatLng(0, 0);
  bool _isLoading = true;
  Set<Marker> markers = {};
  final TextEditingController _addressController = TextEditingController();

  String addressInfo='';
  LatLng latLngInfo=const LatLng(0, 0);

  Future<void> _loadData() async {
    final Set<Marker> newMarkers = {};
    try {
      final currentLocation = await getCurrentLocation();
      makeGetRequest(currentLocation).then((address) {
        _addressController.text=address;
        newMarkers.add(customMarker("currentLocation",currentLocation,"Vị trí của bạn",address));
        setState(() {
          addressInfo=address;
          latLngInfo=currentLocation;
          _initLocation = currentLocation;
          markers = newMarkers;
          _isLoading = false;
        });
      });

    } catch (error) {
      print("bị lỗi $error");
    }
  }

  void _handlePickLocation(LatLng location) {
    markers.clear();
    final Set<Marker> newMarkers = {};
    makeGetRequest(location).then((address) {
      newMarkers.add(customMarker("currentLocation",location,"Vị trí bạn chọn",address));
      _addressController.text=address;
      setState(() {
        addressInfo=address;
        latLngInfo=location;
        markers = newMarkers;
      });
    });
  }

  void _searchAddress(){
    String addressSearch=_addressController.text;
    markers.clear();
    final Set<Marker> newMarkers = {};
    getLatLngFromAddress(addressSearch).then((latLng) {
      newMarkers.add(customMarker("currentLocation",latLng,"Vị trí bạn chọn",addressSearch));
      setState(() {
        addressInfo=addressSearch;
        latLngInfo=latLng;
        markers = newMarkers;
      });
    });
  }

  void _handleSelectAddress(){
    Get.back(result: {"address": addressInfo, "latLng": latLngInfo});
  }
  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:SafeArea(
        child: (_isLoading)
            ? const SpinKitRing(color: Colors.orange)
            : Stack(children: [
          _googleMap(),
          Align(
            alignment: Alignment.topCenter,
              child: Container(
                padding:const EdgeInsets.all(10),

                child: TextField(
                  controller: _addressController,
                 decoration: InputDecoration(
                   suffixIcon: IconButton(
                     iconSize: 30,
                     color: Colors.redAccent,
                     focusColor: Colors.grey[400] ,
                     icon:const Icon(Icons.search),
                     onPressed: () {
                       _searchAddress();
                     },
                   ),
                   filled: true,
                   fillColor: Colors.white,
                   // màu nền
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(10),
                     borderSide: BorderSide.none,
                   ),
                   hintText: 'Địa chỉ',
                   hintStyle: TextStyle(
                     fontSize: 16,
                     fontWeight: FontWeight.bold,
                     color: Colors.grey[400],
                   ),
                 ),
                ),
              )),


          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _handleSelectAddress();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.amber, // Chỉnh màu nền cho button
                  ),
                  child: Text('Chọn địa điểm này'),
                ),

              ],
            ),
          ),
        ]),
      )

    );
  }



  // * ========== Parent widgets ==========
  Positioned _googleMap() {
    return Positioned(
        child: GoogleMap(
          initialCameraPosition: CameraPosition(target: _initLocation, zoom: 15),
          markers: markers,
          onTap: (LatLng location) {
            // Xử lý sự kiện khi người dùng chọn một điểm trên bản đồ
            _handlePickLocation(location);
          },
          onMapCreated: (controller) => kGgController.complete(controller),
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
        ));
  }
}
