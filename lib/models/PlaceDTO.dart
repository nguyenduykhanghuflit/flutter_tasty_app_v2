import 'package:image_picker/image_picker.dart';

class PlaceDTO {
  final List<XFile> listImages;
  final String placeName;
  final String description;
  final String fullAddress;
  final String lat;
  final String lng;
  final dynamic priceFrom;
  final dynamic priceTo;
  final String phone;
  final dynamic timeFrom;
  final dynamic timeTo;
  final dynamic categories;

  PlaceDTO(
      this.listImages,
      this.placeName,
      this.description,
      this.fullAddress,
      this.lat,
      this.lng,
      this.priceFrom,
      this.priceTo,
      this.phone,
      this.timeFrom,
      this.timeTo,
      this.categories);

  @override
  String toString() {
    return 'PlaceDTO{'
        'listImages: $listImages, '
        'placeName: $placeName, '
        'description: $description, '
        'fullAddress: $fullAddress, '
        'lat: $lat, '
        'lng: $lng, '
        'priceFrom: $priceFrom, '
        'priceTo: $priceTo, '
        'phone: $phone, '
        'timeFrom: $timeFrom, '
        'timeTo: $timeTo, '
        'categories: $categories}';
  }
}
