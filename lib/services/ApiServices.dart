import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasty_app_v2/models/PlaceDTO.dart';
import 'package:tasty_app_v2/screens/Auth/login_page.dart';
import '../helpers/functions.dart';
import '../models/PostDTO.dart';
import '../models/response.dart';
import '../screens/StartApp/main_page.dart';
import 'package:dio/dio.dart' as dio;
import 'dart:async';
class ApiServices{

  String url='https://backend-tasty-app.vercel.app/api';

  //----------AUTHENTICATION----------------
  Future<void> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$url/user-login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> data = jsonDecode(response.body);
        String accessToken = data["response"]["accessToken"];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', accessToken);
        Get.offAll(() => const MyHomePage());
      }
      catch (e) {
        Functions.showDialog("Thông báo", "Lỗi khi đăng nhập");
      }
    } else if (response.statusCode == 400) {
      Functions.showDialog("Thông báo", "Sai tên đăng nhập hoặc mật khẩu");
    } else {
      Functions.showDialog(
          "Lỗi server", "Lỗi không xác định ${response.statusCode}");
    }
  }
  Future<void> register(String fullName, String username,String pw,String phone) async {
    final response = await http.post(
      Uri.parse('$url/user-register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': pw,'fullname':fullName,'phone':phone}),
    );

    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> data = jsonDecode(response.body);
        Functions.showDialog("Thành công", "Đăng ký thành công");
       // Get.to(const LoginPage());
      }
      catch (e) {
        Functions.showDialog("Thông báo", "Lỗi khi đăng ký");
      }
    } else if (response.statusCode == 400) {
      Map<String, dynamic> data = jsonDecode(response.body);
      Functions.showDialog("Thông báo", data['error']['message']);
    } else {
      Functions.showDialog(
          "Lỗi server", "Lỗi không xác định ${response.statusCode}");
    }
  }
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    return token;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  //----------PLACE----------------
  Future<Map<String, dynamic>> getAllPlace(String keyword) async {
   try{
     String apiUrl='$url/place';
     if(keyword.isNotEmpty){
       apiUrl+='?search=$keyword';
     }
     final response = await http.get(Uri.parse(apiUrl));

     if (response.statusCode == 200) {
       Map<String, dynamic> data = jsonDecode(response.body);
       return data;
     } else {
       Functions.showDialog("Thông báo", "Lỗi server: Không tải được dữ liệu :(((" );
       throw Exception('Failed to load data');
     }
   }catch(err){
     Functions.showDialog("Thông báo", "Lỗi server: Không tải được dữ liệu :(((" );
     print(err);
     throw Exception('Failed to load data');
   }

  }

  Future<List<dynamic>> searchPlace(String keyword) async {
    final response = await http.get(Uri.parse('$url/place?search=$keyword'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      Functions.showDialog("Thông báo", "Lỗi server: Không tải được dữ liệu :(((" );
      throw Exception('Failed to load data');
    }
  }

  //----------POST----------------
  Future<Map<String, dynamic>> fetchPost(String catalog) async {
    try {
      String apiUrl = '$url/post';
      if (catalog != 'all') {
        apiUrl += '?catalog=$catalog';
      }
      final response = await dio.Dio().get(apiUrl);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        return data;
      } else {
        Functions.showDialog("Thông báo", "Lỗi server: Không tải được dữ liệu :(((" );
        throw Exception('Failed to load data');
      }
    } catch (err) {
      Functions.showDialog("Thông báo", "Lỗi server: Không tải được dữ liệu :(((" );
      print(err);
      throw Exception('Failed to load data');
    }
  }


  //----------POST----------------
  Future<Map<String, dynamic>> fetchPostByUser() async {
    try {
      String? token=await getToken();
      String apiUrl = '$url/post/user';
      final response = await dio.Dio().get(apiUrl,options: dio.Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        return data;
      } else {
        Functions.showDialog("Thông báo", "Lỗi server: Không tải được dữ liệu :(((" );
        throw Exception('Failed to load data');
      }
    } catch (err) {
      Functions.showDialog("Thông báo", "Lỗi server: Không tải được dữ liệu :(((" );
      print(err);
      throw Exception('Failed to load data');
    }
  }


  //----------POST----------------
  Future<Map<String, dynamic>> fetchPlaceByUser() async {
    try {
      String? token=await getToken();
      String apiUrl = '$url/place/user';
      final response = await dio.Dio().get(apiUrl,options: dio.Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        return data;
      } else {
        Functions.showDialog("Thông báo", "Lỗi server: Không tải được dữ liệu :(((" );
        throw Exception('Failed to load data');
      }
    } catch (err) {
      Functions.showDialog("Thông báo", "Lỗi server: Không tải được dữ liệu :(((" );
      print(err);
      throw Exception('Failed to load data');
    }
  }





  Future<APIResponse> createPost(PostDTO data) async{
    try {
      String? token=await getToken();
      String endpoint= '$url/post';
      dio.FormData formData = dio.FormData.fromMap({
        'placeId': data.placeId,
        'title': data.title,
        'content': data.content,
        'star': data.rating,
      });
      List<XFile> listImage=data.listImages;
      for (int i = 0; i < listImage.length; i++) {
        formData.files.add(
          MapEntry(
            'images',
            await dio.MultipartFile.fromFile(
              listImage[i].path,
            ),
          ),
        );
      }

      await dio.Dio().post(
        endpoint,
        data: formData,
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      ) ;
    return successResponse(null);

    } catch (error) {
    return errorResponse(error);

    }

  }


  Future<APIResponse> createPlace(PlaceDTO data) async{
    try {
      print(data.categories.toString());
      String? token=await getToken();
      String endpoint= '$url/place';
      dio.FormData formData = dio.FormData.fromMap({
        'placeName': data.placeName,
        'description': data.description,
        'fullAddress': data.fullAddress,
        'lat': data.lat,
        'lng': data.lng,
        'priceFrom':data.priceFrom,
        'priceTo':data.priceTo,
        'phone':data.phone,
        'timeFrom':data.timeFrom,
        'timeTo':data.timeTo,
        'category':data.categories,
      });
      List<XFile> listImage=data.listImages;
      for (int i = 0; i < listImage.length; i++) {
        formData.files.add(
          MapEntry(
            'images',
            await dio.MultipartFile.fromFile(
              listImage[i].path,
            ),
          ),
        );
      }

      await dio.Dio().post(
        endpoint,
        data: formData,
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      ) ;
      return successResponse(null);

    } catch (error) {
      return errorResponse(error);

    }

  }


  //update info

  Future<APIResponse> updateInfoUser(String fullName,String email,String phone,File? image) async{
    try {
      String? token=await getToken();
      String endpoint= '$url/user/update';
      dio.FormData formData = dio.FormData.fromMap({
        'fullname': fullName,
        'email': email,
        'phone': phone,
      });

      if(image!=null){
        formData.files.add(
          MapEntry(
            'avt',
            await dio.MultipartFile.fromFile(
              image.path,
            ),
          ),
        );
      }

      await dio.Dio().post(
        endpoint,
        data: formData,
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      ) ;
      return successResponse(null);

    } catch (error) {
      return errorResponse(error);

    }

  }

  Future<APIResponse> updatePassword(String rePassword,String password) async{
    try {
      String? token=await getToken();
      String endpoint= '$url/user/update';
      dio.FormData formData = dio.FormData.fromMap({
        'repassword': rePassword,
        'password': password,
      });

      await dio.Dio().post(
        endpoint,
        data: formData,
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      ) ;
      return successResponse(null);

    } catch (error) {
      return errorResponse(error);

    }

  }

  Future<Map<String, dynamic>> searchPost(String keyword) async{
    try {
      String apiUrl = '$url/post/?search=$keyword';
      final response = await dio.Dio().get(apiUrl);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        return data;
      } else {
        Functions.showDialog("Thông báo", "Lỗi server: Không tải được dữ liệu :(((" );
        throw Exception('Failed to load data');
      }
    } catch (err) {
      Functions.showDialog("Thông báo", "Lỗi server: Không tải được dữ liệu :(((" );
      print(err);
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getPostById(String postId) async{
    try {
      String apiUrl = '$url/post/?postId=$postId';
      final response = await dio.Dio().get(apiUrl);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        return data;
      } else {
        Functions.showDialog("Thông báo", "Lỗi server: Không tải được dữ liệu :(((" );
        throw Exception('Failed to load data');
      }
    } catch (err) {
      Functions.showDialog("Thông báo", "Lỗi server: Không tải được dữ liệu :(((" );
      print(err);
      throw Exception('Failed to load data');
    }
  }


  Future<Map<String, dynamic>> getUserInfo() async{
    try {
      String apiUrl = '$url/user/info';
      String? token=await getToken();
      final response = await dio.Dio().get(apiUrl,options: dio.Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        return data;
      } else {
        Functions.showDialog("Thông báo", "Lỗi server: Không tải được dữ liệu :(((" );
        throw Exception('Failed to load data');
      }
    } catch (err) {
      Functions.showDialog("Thông báo", "Lỗi server: Không tải được dữ liệu :(((" );
      print(err);
      throw Exception('Failed to load data');
    }
  }

  //get comment
  Future<Map<String, dynamic>> fetchComment(String postId) async {
    try {
      String apiUrl = '$url/comment?postId=$postId';

      final response = await dio.Dio().get(apiUrl);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        return data;
      } else {
        Functions.showDialog("Thông báo", "Lỗi server: Không tải được dữ liệu :(((" );
        throw Exception('Failed to load data');
      }
    } catch (err) {
      Functions.showDialog("Thông báo", "Lỗi server: Không tải được dữ liệu :(((" );
      print(err);
      throw Exception('Failed to load data');
    }
  }

  Future<APIResponse> commentPost(String postId, String content) async{
    try {
      String? token=await getToken();
      String endpoint= '$url/comment';
      await dio.Dio().post(
        endpoint,
        data: {
          'postId': postId,
          'content': content,
        },
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      ) ;
      return successResponse(null);
    } catch (error) {
      return errorResponse(error);
    }


  }

  APIResponse errorResponse(dynamic error){
    if (error is dio.DioError) {
      final response = error.response;
      if (response != null) {
        int? code = response.statusCode;
        final message = response.data["error"]["message"]?? response.statusMessage ;

        return APIResponse(code, message.toString(),null);
      }
    }
    print("=======API err $error");
    return APIResponse(1, "Dev error: ${error}",null);
  }

  APIResponse successResponse(dynamic data){
    return APIResponse(-1,'Success',data);
  }

}