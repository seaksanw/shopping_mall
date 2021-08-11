import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const CameraPosition _kInitialPosition =
    CameraPosition(target: LatLng(-33.852, 151.211), zoom: 11.0);

class ExampleLite extends StatelessWidget {
  const ExampleLite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Example'),
      ),
      body: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: Center(
            child: SizedBox(
              width: 300.0,
              height: 300.0,
              child: GoogleMap(
                initialCameraPosition: _kInitialPosition,
                liteModeEnabled: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
