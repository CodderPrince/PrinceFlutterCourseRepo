import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationInfoDialog extends StatelessWidget {
  final LatLng position;

  const LocationInfoDialog({super.key, required this.position});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'My Current Location',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Latitude: ${position.latitude.toStringAsFixed(6)}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Longitude: ${position.longitude.toStringAsFixed(6)}',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
