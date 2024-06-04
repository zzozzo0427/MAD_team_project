import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text('포항시 보건소 위치'),
        ),
        body: NaverMap(
          options: NaverMapViewOptions(
            initialCameraPosition: const NCameraPosition(
              target: NLatLng(36.0425, 129.3544),
              zoom: 12,
            ),
          ),
          onMapReady: (controller) {
            final markerNamgu = NMarker(
              id: 'namgu',
              position: const NLatLng(36.0192, 129.3431),
            );
            final markerBukgu = NMarker(
              id: 'bukgu',
              position: const NLatLng(36.0658, 129.3657),
            );

            controller.addOverlayAll({markerNamgu, markerBukgu});

            final onMarkerInfoWindowNamgu = NInfoWindow.onMarker(
              id: markerNamgu.info.id,
              text: "포항시 남구 보건소",
            );
            final onMarkerInfoWindowBukgu = NInfoWindow.onMarker(
              id: markerBukgu.info.id,
              text: "포항시 북구 보건소",
            );

            markerNamgu.openInfoWindow(onMarkerInfoWindowNamgu);
            markerBukgu.openInfoWindow(onMarkerInfoWindowBukgu);
          },
        ),
      ),
    );
  }
}