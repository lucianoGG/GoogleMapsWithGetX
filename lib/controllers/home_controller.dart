import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeController extends GetxController implements GetxService {
  late double _latitudeOrigem = 0;
  late double _longitudeOrigem = 0;
  late double _latitudeFinal = 0;
  late double _longitudeFinal = 0;

  final Map<MarkerId, Marker> _markers = {};
  final Map<PolylineId, Polyline> _polylines = {};
  final List<LatLng> _polylineCoordinates = [];
  final PolylinePoints _polylinePoints = PolylinePoints();
  late String googleAPiKey = "MINHA_KEY";
  late GoogleMapController _mapController;

  double get latitudeOrigem => _latitudeOrigem;
  double get longitudeOrigem => _longitudeOrigem;
  double get latitudeFinal => _latitudeFinal;
  double get longitudeFinal => _longitudeFinal;

  Map<MarkerId, Marker> get markers => _markers;
  Map<PolylineId, Polyline> get polylines => _polylines;
  List<LatLng> get polylineCoordinates => _polylineCoordinates;
  PolylinePoints get polylinePoints => _polylinePoints;
  GoogleMapController get mapController => _mapController;

  Future<Position> _currentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Oops!', 'Seu serviço de localização está desativado!',
          snackPosition: SnackPosition.BOTTOM);
      return Future.error('Seu serviço de localização está desativado!');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
            'Oops!', 'Você precisa aceitar a Localização para continuar.',
            snackPosition: SnackPosition.BOTTOM);
        return Future.error(
            'Você precisa aceitar a Localização para continuar.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('Oops!',
          'Permissão negada para sempre, alterar isso nas configurações do Android.',
          snackPosition: SnackPosition.BOTTOM);
      return Future.error(
          'Permissão negada para sempre, alterar isso nas configurações do Android.');
    }

    update();
    return await Geolocator.getCurrentPosition();
  }

  void _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    update();
  }

  void onMapCreated(GoogleMapController c) {
    _mapController = c;
  }

  void _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(latitudeOrigem, longitudeOrigem),
      PointLatLng(latitudeFinal, longitudeFinal),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    _addPolyLine();
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(latitudeOrigem, longitudeOrigem),
        bearing: 10,
        zoom: 20,
        tilt: 90)));

    update();
  }

  void _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
    update();
  }

  void getPosition() async {
    try {
      final posicao = await _currentPosition();

      _latitudeOrigem = posicao.latitude;
      _longitudeOrigem = posicao.longitude;

      _latitudeFinal = -22.235920;
      _longitudeFinal = -54.825802;

      _addMarker(LatLng(latitudeOrigem, longitudeOrigem), "origin",
          BitmapDescriptor.defaultMarker);
      _addMarker(LatLng(latitudeFinal, longitudeFinal), "destination",
          BitmapDescriptor.defaultMarkerWithHue(90));

      _getPolyline();
    } catch (e) {
      Get.snackbar('erro', e.toString());
    }
    update();
  }
}
