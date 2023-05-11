import 'package:get/get.dart';

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

}