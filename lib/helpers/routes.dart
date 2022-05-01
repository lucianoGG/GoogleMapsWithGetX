import 'package:get/get.dart';
import 'package:google_maps_with_getx/pages/home/home.dart';

class RouteHelper {
  static const String home = '/';
  static String getHomeRoute() => home;

  static List<GetPage> routes = [
    GetPage(name: home, page: () => const HomeScreen())
  ];
}
