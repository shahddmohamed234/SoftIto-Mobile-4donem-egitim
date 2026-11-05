import 'package:firebase_messaging/firebase_messaging.dart';


@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  print("Arka planda bildirim geld:${message.notification?.title}");
}
 //her şeyden bağımsız bir şekilde çalıştırabilen bir fonksiyon
class BildirimServisi {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future <void> baslat() async{
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print("Kullanıcı Bildirim iznini verdi");
    }
    final token = await _fcm.getToken();
    print('Cihazın FCM tokeni: $token');
  }
}