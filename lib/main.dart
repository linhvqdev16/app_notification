import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

import 'screens/home.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject = BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String?> selectNotificationSubject = BehaviorSubject<String?>();

const MethodChannel platform = MethodChannel('dexterx.dev/flutter_local_notifications_example');


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage? message) async {
  await Firebase.initializeApp();
  if(message != null){
    RemoteNotification notification = RemoteNotification(title: message.data['title'], body: message.data['content']);

    var notify = ReceivedNotification(
        title: notification.title ?? "",
        body: notification.body ?? "");

    flutterLocalNotificationsPlugin.show(
        notify.hashCode,
        notify.title,
        notify.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            icon: 'ic_launcher',
          ),
        ));
  }
}


Future<dynamic> handlerBackgroundMessage(RemoteMessage? message) async{
  if(message != null){
    print("I'm here");
  }
}

AndroidNotificationChannel channel = const AndroidNotificationChannel(
  '1', // id
  'High Importance Notifications', // title // description
  importance: Importance.high,
);

class ReceivedNotification {
  ReceivedNotification({
    required this.title,
    required this.body,
  });

  final String? title;
  final String? body;
}

String? selectedNotificationPayload;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp( const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('mipmap/ic_launcher');

    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (id, title, body, payload) async {
          didReceiveLocalNotificationSubject.add(ReceivedNotification(title: title, body: body,));
        });

    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    String? token = await FirebaseMessaging.instance.getToken();
    if(token != null){
      print("FCM Token:" + token);
    }

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) async {
          if (payload != null) {
            debugPrint('notification payload: $payload');
          }
          selectNotificationSubject.add(payload);
        });

    _requestPermissions();

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print("Hello test");
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      if (message != null) {
        RemoteNotification notification = RemoteNotification(title: message.data['title'], body: message.data['content']);
        processMessage(notification, isShowLocalNotify: true);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
      if (message != null) {
        RemoteNotification notification = RemoteNotification(title: message.data['title'], body: message.data['content']);
        processMessage(notification, isShowLocalNotify: true);
      }
    });
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void processMessage(RemoteNotification? message, {bool isShowLocalNotify = false}) {
    try {
      if (isShowLocalNotify) {
        var notify = ReceivedNotification(
            title: message?.title ?? "",
            body: message?.body ?? "");
        _showPublicNotificationAndroid(notify);
      } else {
        print("null");
      }
    } on Exception {
      //throw
    }
  }

  Future<void> _showPublicNotificationAndroid(ReceivedNotification item) async {
    flutterLocalNotificationsPlugin.show(
        item.hashCode,
        item.title,
        item.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            icon: 'ic_launcher',
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}
