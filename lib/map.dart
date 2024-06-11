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
              target: NLatLng(36.03155137924545, 129.3883309294615),
              zoom: 11, // 적절한 줌 레벨 설정
            ),
          ),
          onMapReady: (controller) {
            final markerNamgu = NMarker(
              id: 'namgu',
              position: const NLatLng(35.9924409415333, 129.396224430861),
            );
            final markerBukgu = NMarker(
              id: 'bukgu',
              position: const NLatLng(36.0706618169576, 129.380437428062),
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
