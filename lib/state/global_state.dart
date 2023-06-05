import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GlobalController extends GetxController {

  var test="".obs;
  void changeValue(var value) {
    test.value=value;
  }



  //for selected place in create post screen
  RxMap  placeSelected={}.obs;

  void setPlace( Map<String, dynamic> place){
    placeSelected.value=place;
  }
  void clearPlace(){
    placeSelected.clear();
  }

  Map<String,List<Map<String, dynamic>>> postListState={};
  void setListPost(  Map<String,List<Map<String, dynamic>>> data){
  postListState=data;
  }
  void clearListPost(){
    postListState={};
  }


 var latLngObs=const LatLng(0, 0).obs;
  var addressObs=''.obs;
  void setAddressInfo( {dynamic latLng, required dynamic address} ){
    latLngObs.value=latLng;
    addressObs.value=address;
  }
  void clearAddressInfo(LatLng latLng,String address ){
    latLng=const LatLng(0, 0);
    address='';
  }
}