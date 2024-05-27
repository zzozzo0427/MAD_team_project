import 'package:flutter/material.dart';
import 'package:mad_real_project/main.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:provider/provider.dart';

import 'home.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  void _showMapsDialog(BuildContext context, Coords coords) async {
    final availableMaps = await MapLauncher.installedMaps;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              for (var map in availableMaps)
                ListTile(
                  onTap: () {
                    map.showMarker(
                      coords: coords,
                      title: "San Francisco",
                      description: "This is San Francisco",
                    );
                    Navigator.pop(context);
                  },
                  title: Text(map.mapName),
                  leading: Image.network(
                    map.icon.toString(),
                    height: 30,
                    width: 30,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final coords = Coords(37.7749, -122.4194); // 샌프란시스코 위치
    final navBarModel = Provider.of<NavBarModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Map Launcher Demo'),
      ),
      body: Stack(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () => _showMapsDialog(context, coords),
              child: Text('Launch Map'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Consumer<NavBarModel>(
        builder: (context, navBarModel, child) {
          return BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.videogame_asset),
                label: 'Game',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.group),
                label: 'Community',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: 'Map',
              ),
            ],
            currentIndex: navBarModel.currentIndex,
            selectedItemColor: Colors.green,
            onTap: (index) {
              navBarModel.setCurrentIndex(index);
              // Handle navigation on tap
              if (index == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              // } else if (index == 1) {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => GameScreen()),
              //   );
              // } else if (index == 2) {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => CommunityScreen()),
              //   );
              }
            },
          );
        },
      ),
    );
  }
}