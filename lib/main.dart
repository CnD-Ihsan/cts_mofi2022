import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wfm/api/auth_api.dart';
import 'package:wfm/api/base_api.dart';
import 'package:wfm/pages/list_orders.dart';
import 'package:wfm/pages/login.dart';
import 'package:wfm/pages/show_new_installation.dart';
import 'package:wfm/route.dart';
import 'package:version/version.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'landing.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(); //required for using Firebase services
  print("Handling a background message: ${message.messageId}");
  print('Message also contained an action: ${message.data['action']}');
  if(message.data['action'] == 'force_logout'){
    await _forceLogout();
  }
}

Future<void> _forceLogout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print("Clearing shared prefs...");
  if(await AuthApi.logOut(prefs.getString('email'), prefs.getString('fcm_token')) &&  await prefs.clear()){
    print("Forced Log Out!");
  }else{
    print("Error clearing prefs!");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(fileName: ".env");

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  final fcmToken = await FirebaseMessaging.instance.getToken();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Message data: ${message.data}');
    if (message.notification != null) {
      print('Message also contained an action: ${message.data['action']}');
      String action = message.data['action'] ?? 'none';
      if(action == 'force_logout'){
        _forceLogout();
      }
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatefulWidget{
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  late SharedPreferences prefs;
  late String? user, email;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WFM Mobile Apps',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: false,
      ),
      routes: {
        '/landing': (context) => const Landing(),
        '/login': (context) => const Login(),
        '/list': (context) =>
            const WorkOrders(user: 'Unauthorized', email: 'Unauthorized'),
        '/show/:orderID': (context) => const ShowServiceOrder(
              orderID: 0,
            ),
      },
      onGenerateRoute: RouteGenerator.generateRoute,
      home: const Landing(),
    );
  }
}
