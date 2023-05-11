import 'package:image_picker/image_picker.dart';

class PostDTO{
  final List<XFile> listImages;
  final String title;
  final dynamic placeId;
  final String content;
  final double rating;

  PostDTO(this.listImages, this.title, this.content, this.rating, this.placeId);

}