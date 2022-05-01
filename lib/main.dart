import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_with_getx/helpers/get_di.dart' as di;
import 'package:google_maps_with_getx/helpers/routes.dart';

void main() async {
  // inicializa o Get
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Google Maps With GetX',
      debugShowCheckedModeBanner: false,
      navigatorKey: Get.key,
      initialRoute: RouteHelper.getHomeRoute(),
      getPages: RouteHelper.routes,
      defaultTransition: Transition.topLevel,
      transitionDuration: const Duration(milliseconds: 500),
    );
  }
}
