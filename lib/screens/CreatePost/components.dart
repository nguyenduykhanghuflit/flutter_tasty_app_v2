import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../state/global_state.dart';
import '../SelectPlace/select_place_page.dart';

class Component{
  static Widget buttonSelectPlace = InkWell(
    onTap: () {
      Get.to(const SelectPlace());
    },
    hoverColor: Colors.grey[400],
    child: Container(
      margin: const EdgeInsets.only(top: 15, bottom: 15),
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_on_outlined, color: Colors.grey),
          const SizedBox(height: 10),
          Text("Nhấn vào đây để chọn địa điểm",
              style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold,
                color: Colors.grey[400], // màu chữ của hint text
              )),
        ],
      ),
    ),
  );

  static Widget placeSelected() {
    final GlobalController ctrl = Get.find();
    return Stack(
      children: [
        InkWell(
          hoverColor: Colors.grey[400],
          child: Container(
            margin: const EdgeInsets.only(top: 15, bottom: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  margin: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      // ignore: invalid_use_of_protected_member
                      ctrl.placeSelected.value["media"],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    SizedBox(
                      width: 200,
                      child: Text(
                        // ignore: invalid_use_of_protected_member
                        "${ctrl.placeSelected.value["placeName"]}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // màu chữ của hint text
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                        width: 200,
                        child: Text(
                            // ignore: invalid_use_of_protected_member
                            "${ctrl.placeSelected.value["fullAddress"]}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.black, // màu chữ của hint text
                            ))),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 25,
          right: 10,
          child: GestureDetector(
            onTap: () {
              ctrl.clearPlace();
            },
            child: const Icon(Icons.clear),
          ),
        ),
      ],
    );
  }
}