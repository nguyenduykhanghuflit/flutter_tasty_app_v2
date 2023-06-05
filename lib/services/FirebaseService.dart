import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future initialize() async {
    // Lắng nghe thông báo mới
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Nhận được thông báo mới: ${message.notification!.title}');
      _showNotification(message.notification!);
    });

    // Xử lý thông báo khi ứng dụng đang chạy ở nền
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          'Đã mở thông báo từ app đang chạy ở nền: ${message.notification!.title}');
    });

    // Xử lý thông báo khi ứng dụng đang tắt
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Yêu cầu quyền truy cập thông báo
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Quyền truy cập thông báo đã được cấp.');
    } else {
      print('Quyền truy cập thông báo không được cấp.');
    }
  }

  // Hiển thị thông báo khi có thông báo mới
  void _showNotification(RemoteNotification notification) {
    // Để hiển thị thông báo, bạn có thể sử dụng một plugin thông báo bên thứ ba, ví dụ như flutter_local_notifications
    // Ở đây, chúng ta sẽ chỉ in ra nội dung của thông báo trên console
    print('Tiêu đề thông báo: ${notification.title}');
    print('Nội dung thông báo: ${notification.body}');
  }

  // Xử lý thông báo khi ứng dụng đang tắt
  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print(
        'Đã nhận được thông báo khi app đang tắt: ${message.notification!.title}');
  }
}
