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
      home: Scaffold(
        body: NaverMap(
          options: const NaverMapViewOptions(),
          onMapReady: (controller) {
            print("네이버 맵 로딩됨!");
          },
        ),
      ),
    );
  }
}