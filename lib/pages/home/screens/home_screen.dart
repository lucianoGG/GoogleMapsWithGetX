part of '../home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<HomeController>().getPosition();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: GetBuilder<HomeController>(builder: (controller) {
        return GoogleMap(
          buildingsEnabled: false,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
              target:
                  LatLng(controller.latitudeOrigem, controller.longitudeOrigem),
              zoom: 15),
          myLocationButtonEnabled: true,
          tiltGesturesEnabled: true,
          compassEnabled: true,
          scrollGesturesEnabled: true,
          zoomControlsEnabled: true,
          onMapCreated: (GoogleMapController c) {
            controller.onMapCreated(c);
          },
          markers: Set<Marker>.of(controller.markers.values),
          polylines: Set<Polyline>.of(controller.polylines.values),
        );
      }),
    ));
  }
}
