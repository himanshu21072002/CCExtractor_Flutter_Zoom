import 'package:flutter/cupertino.dart';
import 'package:gsoc2/spash_screen.dart';

import 'package:camera/camera.dart';

List<CameraDescription>? cameras;
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  cameras=await availableCameras();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      home:MySplashScreen(),
    );
  }
}

