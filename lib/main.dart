import 'package:alexandrya/auth/constants/firebase_constants.dart';
import 'package:alexandrya/auth/controllers/auth_controller.dart';
import 'package:alexandrya/auth/screens/splash_screen.dart';
import 'package:alexandrya/helpers/loading/loading_overlay.dart';
import 'package:alexandrya/helpers/translations/app_translations.dart';
import 'package:alexandrya/helpers/routes/routes.dart';
import 'package:alexandrya/home/screens/home_screen.dart';
import 'package:alexandrya/video_chat/screens/video_chat_screen.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  firebaseInitialization.then((value) {
    // We inject the auth controller
    Get.put(AuthController());
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Alexandrya',
      translations: AppTranslations(),
      locale: const Locale('es'),
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      /* home: const LoadingOverlay(
        child: SplashScreen(),
      ),
      */
      home: const SplashScreen(),
      builder: (context, child) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, child!),
          maxWidth: 1200,
          minWidth: 450,
          defaultScale: true,
          breakpoints: [
            const ResponsiveBreakpoint.resize(450, name: MOBILE),
            const ResponsiveBreakpoint.autoScale(800, name: TABLET),
            const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
            const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
            const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
          ],
          background: Container(color: const Color(0xFFF5F5F5))),
      //initialRoute: Routes.splash,
      onGenerateRoute: (RouteSettings settings) {
        return Routes.fadeThrough(settings, (context) {
          switch (settings.name) {
            case Routes.splash:
              return const SplashScreen();
            case Routes.home:
              return const HomeScreen();
            case Routes.videoChat:
              return const VideoChatScreen();
            default:
              return const SizedBox.shrink();
          }
        });
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
