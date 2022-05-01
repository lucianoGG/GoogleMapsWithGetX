import 'package:get/get.dart';
import 'package:google_maps_with_getx/controllers/home_controller.dart';

Future<void> init() async {
  // Controller
  Get.lazyPut(() => HomeController());
}
