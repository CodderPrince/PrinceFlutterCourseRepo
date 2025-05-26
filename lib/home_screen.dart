import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  LatLng? _currentPosition;
  final List<LatLng> _userPathCoordinates = [];
  Timer? _locationTimer;

  LatLng? _selectedDestination;
  double? _distanceToDestination;

  final Set<Marker> _mapMarkers = {};
  final Set<Polyline> _mapPolylines = {};

  bool _isLocationServiceEnabled = false;
  String _errorMessage = '';

  static const double _defaultZoom = 15.0;
  static const double _currentLocationZoom = 17.0;

  @override
  void initState() {
    super.initState();
    _initializeLocationService();
  }

  Future<void> _initializeLocationService() async {
    try {
      _isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!_isLocationServiceEnabled) {
        if (mounted)
          setState(
            () =>
                _errorMessage =
                    'Location services are disabled. Please enable them!',
          );
        return;
      }

      final status = await Permission.location.request();
      if (status.isGranted) {
        await _fetchAndUpdateCurrentLocation(shouldAnimateCamera: true);
        _locationTimer?.cancel();
        _locationTimer = Timer.periodic(
          const Duration(seconds: 10),
          (_) => _fetchAndUpdateCurrentLocation(shouldAnimateCamera: true),
        );
      } else if (status.isDenied) {
        if (mounted)
          setState(
            () =>
                _errorMessage =
                    'Location permission denied. Please grant permission in app settings!',
          );
      } else if (status.isPermanentlyDenied) {
        if (mounted)
          setState(
            () =>
                _errorMessage =
                    'Location permission permanently denied. Please grant permission in app settings!',
          );
      }
    } catch (e) {
      if (mounted)
        setState(
          () => _errorMessage = 'Error initializing location: ${e.toString()}',
        );
    }
  }

  Future<void> _fetchAndUpdateCurrentLocation({
    bool shouldAnimateCamera = false,
    bool clearDestination = false,
  }) async {
    if (clearDestination) {
      _clearSelectedDestination();
    }

    try {
      _isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!_isLocationServiceEnabled) {
        if (mounted)
          setState(
            () =>
                _errorMessage =
                    'Location services are disabled. Please enable them!',
          );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final newPosition = LatLng(position.latitude, position.longitude);

      if (mounted) {
        setState(() {
          if (_errorMessage.isNotEmpty &&
              (_errorMessage.contains('Error getting location') ||
                  _errorMessage.contains('Location permission') ||
                  _errorMessage.contains('Location services'))) {
            _errorMessage = '';
          }
          _currentPosition = newPosition;
          if (_userPathCoordinates.isEmpty ||
              (_userPathCoordinates.isNotEmpty &&
                  newPosition != _userPathCoordinates.last)) {
            _userPathCoordinates.add(newPosition);
          }
          _updateMapVisualElements();
        });
      }

      if (shouldAnimateCamera &&
          _currentPosition != null &&
          _controller.isCompleted) {
        final mapController = await _controller.future;
        mapController.animateCamera(
          CameraUpdate.newLatLngZoom(_currentPosition!, _currentLocationZoom),
        );
      }
    } catch (e) {
      String userFriendlyError = 'Error getting location.';
      if (e is LocationServiceDisabledException)
        userFriendlyError = 'Location services are disabled on your device!';
      else if (e is PermissionDeniedException)
        userFriendlyError = 'Location permission was denied!';
      else if (e is TimeoutException)
        userFriendlyError =
            'Getting location timed out. Check your connection/GPS.';
      else
        userFriendlyError =
            'Error getting location: ${e.toString().split(':').last.trim()}';

      if (mounted) setState(() => _errorMessage = userFriendlyError);
    }
  }

  void _onMapTapped(LatLng tappedPoint) {
    setState(() {
      _selectedDestination = tappedPoint;
      _updateMapVisualElements();
    });
  }

  void _clearSelectedDestination() {
    setState(() {
      _selectedDestination = null;
      _distanceToDestination = null;
      _updateMapVisualElements();
    });
  }

  void _calculateDistanceToDestination() {
    if (_currentPosition != null && _selectedDestination != null) {
      _distanceToDestination = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        _selectedDestination!.latitude,
        _selectedDestination!.longitude,
      );
    } else {
      _distanceToDestination = null;
    }
  }

  void _updateMapVisualElements() {
    _mapMarkers.clear();
    _mapPolylines.clear();
    _calculateDistanceToDestination();

    if (_currentPosition != null) {
      _mapMarkers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: _currentPosition!,
          infoWindow: InfoWindow(
            title: 'My Current Location',
            snippet:
                '${_currentPosition!.latitude.toStringAsFixed(6)}, ${_currentPosition!.longitude.toStringAsFixed(6)}',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    if (_userPathCoordinates.length > 1) {
      _mapPolylines.add(
        Polyline(
          polylineId: const PolylineId('userPath'),
          points: _userPathCoordinates,
          color: Colors.blue,
          width: 5,
          jointType: JointType.round,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),
      );
    }

    if (_selectedDestination != null) {
      String snippetText =
          '${_selectedDestination!.latitude.toStringAsFixed(6)}, ${_selectedDestination!.longitude.toStringAsFixed(6)}';
      if (_distanceToDestination != null) {
        snippetText +=
            '\nDistance: ${(_distanceToDestination! / 1000).toStringAsFixed(2)} km';
      }
      _mapMarkers.add(
        Marker(
          markerId: const MarkerId('destinationLocation'),
          position: _selectedDestination!,
          infoWindow: InfoWindow(
            title: 'Selected Destination',
            snippet: snippetText,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
          onTap: () {
            // TAPPING THE DESTINATION MARKER CLEARS IT
            _clearSelectedDestination();
          },
        ),
      );

      if (_currentPosition != null) {
        _mapPolylines.add(
          Polyline(
            polylineId: const PolylineId('routeToDestination'),
            points: [_currentPosition!, _selectedDestination!],
            color: Colors.orangeAccent,
            width: 4,
            patterns: [PatternItem.dash(20), PatternItem.gap(10)],
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final initialCameraTarget =
        _currentPosition ?? const LatLng(23.8103, 90.4125);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-Time Location Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _fetchAndUpdateCurrentLocation(
                shouldAnimateCamera: true,
                clearDestination: true,
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: initialCameraTarget,
              zoom: _defaultZoom,
            ),
            markers: _mapMarkers,
            polylines: _mapPolylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onMapCreated: (GoogleMapController googleMapController) {
              if (!_controller.isCompleted) {
                _controller.complete(googleMapController);
              }
              if (_currentPosition != null) {
                googleMapController.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    _currentPosition!,
                    _currentLocationZoom,
                  ),
                );
              }
            },
            onTap: _onMapTapped,
          ),

          if (_errorMessage.isNotEmpty)
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: Material(
                elevation: 4.0,
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

          if (_selectedDestination != null && _distanceToDestination != null)
            Positioned(
              bottom: 80,
              left: 10,
              right: 10,
              child: Card(
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Distance to destination: ${(_distanceToDestination! / 1000).toStringAsFixed(2)} km',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => _fetchAndUpdateCurrentLocation(shouldAnimateCamera: true),
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
