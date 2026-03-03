import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/dummy_map_widget.dart';
import './widgets/driver_info_card.dart';
import './widgets/map_overlay_widgets.dart';
import './widgets/ride_status_bottom_sheet.dart';

// Replace Google Maps import with dummy map
//

// Import dummy map

class LiveTrackingScreen extends StatefulWidget {
  const LiveTrackingScreen({super.key});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen>
    with TickerProviderStateMixin {
  DummyMapController? _mapController; // Changed from GoogleMapController
  late AnimationController _vehicleAnimationController;
  late AnimationController _arrivalAnimationController;

  Timer? _locationUpdateTimer;
  Timer? _etaUpdateTimer;

  // Map and location data
  LatLng _currentLocation = const LatLng(37.7749, -122.4194); // San Francisco
  LatLng _driverLocation = const LatLng(37.7849, -122.4094);
  LatLng _destination = const LatLng(37.7649, -122.4294);

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  bool _isLoading = true;
  bool _isDriverAssigned = false;
  bool _hasDriverArrived = false;

  // Mock data
  final Map<String, dynamic> _driverData = {
    "id": "DR001",
    "name": "Michael Rodriguez",
    "avatar": "https://images.unsplash.com/photo-1696347609175-49b310bb8106",
    "semanticLabel":
        "Professional headshot of Hispanic man with short black hair wearing a dark blue collared shirt",
    "rating": 4.8,
    "vehicle": "Toyota Camry",
    "plateNumber": "ABC-123",
    "phone": "+1-555-0123",
  };

  final Map<String, dynamic> _rideData = {
    "rideId": "TH-2024-1104-001",
    "status": "Driver En Route",
    "progress": 0.35,
    "eta": "5 min",
    "distance": "2.3 km",
    "fare": "\$18.50",
    "pickupAddress": "123 Market Street, San Francisco",
    "destinationAddress": "456 Mission Street, San Francisco",
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeTracking();
  }

  @override
  void dispose() {
    _vehicleAnimationController.dispose();
    _arrivalAnimationController.dispose();
    _locationUpdateTimer?.cancel();
    _etaUpdateTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _vehicleAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _arrivalAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  Future<void> _initializeTracking() async {
    await _getCurrentLocation();
    await _simulateDriverAssignment();
    _startLocationUpdates();
    _startETAUpdates();
    _setupMapMarkers();
    _drawRoute();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      // Use default San Francisco location
    }
  }

  Future<void> _simulateDriverAssignment() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _isLoading = false;
      _isDriverAssigned = true;
    });
    _vehicleAnimationController.forward();
  }

  void _startLocationUpdates() {
    _locationUpdateTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _updateDriverLocation();
    });
  }

  void _startETAUpdates() {
    _etaUpdateTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _updateETA();
    });
  }

  void _updateDriverLocation() {
    if (!_isDriverAssigned) return;

    // Simulate driver movement towards pickup location
    double lat = _driverLocation.latitude;
    double lng = _driverLocation.longitude;

    // Move driver closer to current location
    double deltaLat = (_currentLocation.latitude - lat) * 0.1;
    double deltaLng = (_currentLocation.longitude - lng) * 0.1;

    setState(() {
      _driverLocation = LatLng(lat + deltaLat, lng + deltaLng);
      _rideData["progress"] =
          math.min(0.9, (_rideData["progress"] as double) + 0.05);
    });

    _updateDriverMarker();
    _checkDriverArrival();
  }

  void _updateETA() {
    List<String> etas = [
      "5 นาที",
      "4 นาที",
      "3 นาที",
      "2 นาที",
      "1 นาที",
      "กำลังมาถึง"
    ];
    int currentIndex = etas.indexOf(_rideData["eta"] as String);
    if (currentIndex < etas.length - 1) {
      setState(() {
        _rideData["eta"] = etas[currentIndex + 1];
      });
    }
  }

  void _checkDriverArrival() {
    double distance = Geolocator.distanceBetween(
      _driverLocation.latitude,
      _driverLocation.longitude,
      _currentLocation.latitude,
      _currentLocation.longitude,
    );

    if (distance < 100 && !_hasDriverArrived) {
      _onDriverArrival();
    }
  }

  void _onDriverArrival() {
    setState(() {
      _hasDriverArrived = true;
      _rideData["status"] = "คนขับมาถึงแล้ว";
      _rideData["eta"] = "มาถึงแล้ว";
    });

    _arrivalAnimationController.forward();
    HapticFeedback.heavyImpact();

    _showArrivalNotification();
  }

  void _showArrivalNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.successLight,
              size: 20,
            ),
            SizedBox(width: 2.w),
            const Expanded(
              child: Text("คนขับของคุณมาถึงแล้ว! กรุณาไปที่จุดรับ"),
            ),
          ],
        ),
        backgroundColor: AppTheme.successLight,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void _setupMapMarkers() {
    _markers = {
      Marker(
        markerId: const MarkerId('current_location'),
        position: _currentLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: 'ตำแหน่งของคุณ'),
      ),
      Marker(
        markerId: const MarkerId('destination'),
        position: _destination,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(title: 'จุดหมาย'),
      ),
    };

    if (_isDriverAssigned) {
      _updateDriverMarker();
    }
  }

  void _updateDriverMarker() {
    _markers.removeWhere((marker) => (marker).markerId.value == 'driver');
    _markers.add(
      Marker(
        markerId: const MarkerId('driver'),
        position: _driverLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        infoWindow: InfoWindow(title: _driverData["name"] as String),
        rotation: _calculateBearing(_driverLocation, _currentLocation),
      ),
    );
  }

  double _calculateBearing(LatLng start, LatLng end) {
    double lat1 = start.latitude * math.pi / 180;
    double lat2 = end.latitude * math.pi / 180;
    double deltaLng = (end.longitude - start.longitude) * math.pi / 180;

    double y = math.sin(deltaLng) * math.cos(lat2);
    double x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(deltaLng);

    return math.atan2(y, x) * 180 / math.pi;
  }

  void _drawRoute() {
    _polylines = {
      Polyline(
        polylineId: const PolylineId('route'),
        points: [_currentLocation, _destination],
        color: AppTheme.primaryLight,
        width: 4,
        patterns: [PatternItem.dash(20), PatternItem.gap(10)],
      ),
    };

    if (_isDriverAssigned) {
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('driver_route'),
          points: [_driverLocation, _currentLocation],
          color: AppTheme.successLight,
          width: 3,
        ),
      );
    }
  }

  void _onMapCreated(DummyMapController controller) {
    _mapController = controller;
    _fitMapToMarkers();
  }

  void _fitMapToMarkers() {
    if (_mapController == null) return;

    double minLat = math.min(_currentLocation.latitude, _destination.latitude);
    double maxLat = math.max(_currentLocation.latitude, _destination.latitude);
    double minLng =
        math.min(_currentLocation.longitude, _destination.longitude);
    double maxLng =
        math.max(_currentLocation.longitude, _destination.longitude);

    if (_isDriverAssigned) {
      minLat = math.min(minLat, _driverLocation.latitude);
      maxLat = math.max(maxLat, _driverLocation.latitude);
      minLng = math.min(minLng, _driverLocation.longitude);
      maxLng = math.max(maxLng, _driverLocation.longitude);
    }

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat - 0.01, minLng - 0.01),
          northeast: LatLng(maxLat + 0.01, maxLng + 0.01),
        ),
        100.0,
      ),
    );
  }

  void _centerOnMyLocation() {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_currentLocation, 16),
    );
  }

  void _openExternalNavigation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("กำลังเปิดการนำทาง..."),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleEmergency() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'emergency',
              color: AppTheme.errorLight,
              size: 24,
            ),
            SizedBox(width: 2.w),
            const Text("ฉุกเฉิน"),
          ],
        ),
        content: const Text(
          "คุณอยู่ในสถานการณ์ฉุกเฉินหรือไม่? ระบบจะติดต่อหน่วยฉุกเฉินและแจ้งเจ้าหน้าที่รุ่งโรจน์คาร์เร้นท์ทันที",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("ยกเลิก"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _contactEmergencyServices();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
            ),
            child: const Text("โทรฉุกเฉิน"),
          ),
        ],
      ),
    );
  }

  void _contactEmergencyServices() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'phone',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 2.w),
            const Expanded(
              child: Text("กำลังติดต่อหน่วยฉุกเฉิน..."),
            ),
          ],
        ),
        backgroundColor: AppTheme.errorLight,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _callDriver() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("กำลังโทรหา ${_driverData["name"]}..."),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _messageDriver() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("กำลังเปิดแชทกับ ${_driverData["name"]}..."),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _changeDestination() {
    Navigator.pushNamed(context, '/ride-request-screen');
  }

  void _addStop() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("ฟีเจอร์เพิ่มจุดแวะพักจะเปิดให้ใช้เร็วๆ นี้..."),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _cancelRide() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("ยกเลิกการเดินทาง"),
        content: const Text(
          "คุณแน่ใจหรือไม่ว่าต้องการยกเลิกการเดินทาง? อาจมีค่าธรรมเนียมการยกเลิก",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("ดำเนินการต่อ"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/ride-request-screen',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
            ),
            child: const Text("ยกเลิกการเดินทาง"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // Dummy Map (replaced Google Map)
          DummyMapWidget(
            // Changed from GoogleMap
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _currentLocation,
              zoom: 14,
            ),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            compassEnabled: false,
            trafficEnabled: true,
            buildingsEnabled: true,
            mapType: MapType.normal,
            style: theme.brightness == Brightness.dark ? _darkMapStyle : null,
          ),

          // Loading Animation
          if (_isLoading)
            Container(
              color: theme.scaffoldBackgroundColor.withValues(alpha: 0.9),
              child: const LoadingSearchAnimation(
                message: "กำลังค้นหาคนขับ...",
              ),
            ),

          // Top Overlay
          if (_isDriverAssigned)
            MapTopOverlay(
              rideId: _rideData["rideId"] as String,
              eta: _rideData["eta"] as String,
              onEmergencyPressed: _handleEmergency,
              onBackPressed: () => Navigator.of(context).pop(),
            ),

          // Floating Action Buttons
          if (_isDriverAssigned)
            MapFloatingActionButton(
              onMyLocationPressed: _centerOnMyLocation,
              onNavigationPressed: _openExternalNavigation,
            ),

          // Driver Info Card
          if (_isDriverAssigned && !_hasDriverArrived)
            Positioned(
              top: 25.h,
              left: 0,
              right: 0,
              child: DriverInfoCard(
                driverData: _driverData,
                onCallPressed: _callDriver,
                onMessagePressed: _messageDriver,
              ),
            ),

          // Arrival Animation
          if (_hasDriverArrived)
            AnimatedBuilder(
              animation: _arrivalAnimationController,
              builder: (context, child) {
                return Positioned(
                  top: 25.h,
                  left: 4.w,
                  right: 4.w,
                  child: Transform.scale(
                    scale: 1.0 + (_arrivalAnimationController.value * 0.1),
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: AppTheme.successLight,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.successLight.withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          CustomIconWidget(
                            iconName: 'check_circle',
                            color: Colors.white,
                            size: 48,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            "คนขับมาถึงแล้ว!",
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            "${_driverData["name"]} กำลังรอคุณอยู่",
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

          // Bottom Sheet
          if (_isDriverAssigned)
            RideStatusBottomSheet(
              rideData: _rideData,
              onChangeDestination: _changeDestination,
              onAddStop: _addStop,
              onCancelRide: _cancelRide,
              onEmergency: _handleEmergency,
            ),
        ],
      ),
      // Standard bottom navigation bar - consistent with other screens
      bottomNavigationBar: CustomBottomBar(
        variant: CustomBottomBarVariant.standard,
        currentIndex: 1, // Track tab
        onTap: (index) {
          HapticFeedback.lightImpact();
          switch (index) {
            case 0:
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/ride-request-screen',
                (route) => false,
              );
              break;
            case 1:
              // Already on live tracking screen
              break;
            case 2:
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/ride-history-screen',
                (route) => false,
              );
              break;
            case 3:
              Navigator.pushNamed(context, '/user-profile-screen');
              break;
          }
        },
      ),
    );
  }

  // Dark mode map style
  static const String _darkMapStyle = '''
  [
    {
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#1d2c4d"
        }
      ]
    },
    {
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#8ec3b9"
        }
      ]
    },
    {
      "elementType": "labels.text.stroke",
      "stylers": [
        {
          "color": "#1a3646"
        }
      ]
    },
    {
      "featureType": "administrative.country",
      "elementType": "geometry.stroke",
      "stylers": [
        {
          "color": "#4b6878"
        }
      ]
    },
    {
      "featureType": "administrative.land_parcel",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#64779e"
        }
      ]
    },
    {
      "featureType": "administrative.province",
      "elementType": "geometry.stroke",
      "stylers": [
        {
          "color": "#4b6878"
        }
      ]
    },
    {
      "featureType": "landscape.man_made",
      "elementType": "geometry.stroke",
      "stylers": [
        {
          "color": "#334e87"
        }
      ]
    },
    {
      "featureType": "landscape.natural",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#023e58"
        }
      ]
    },
    {
      "featureType": "poi",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#283d6a"
        }
      ]
    },
    {
      "featureType": "poi",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#6f9ba5"
        }
      ]
    },
    {
      "featureType": "poi",
      "elementType": "labels.text.stroke",
      "stylers": [
        {
          "color": "#1d2c4d"
        }
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "geometry.fill",
      "stylers": [
        {
          "color": "#023e58"
        }
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#3C7680"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#304a7d"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#98a5be"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "labels.text.stroke",
      "stylers": [
        {
          "color": "#1d2c4d"
        }
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#2c6675"
        }
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry.stroke",
      "stylers": [
        {
          "color": "#255763"
        }
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#b0d5ce"
        }
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "labels.text.stroke",
      "stylers": [
        {
          "color": "#023e58"
        }
      ]
    },
    {
      "featureType": "transit",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#98a5be"
        }
      ]
    },
    {
      "featureType": "transit",
      "elementType": "labels.text.stroke",
      "stylers": [
        {
          "color": "#1d2c4d"
        }
      ]
    },
    {
      "featureType": "transit.line",
      "elementType": "geometry.fill",
      "stylers": [
        {
          "color": "#283d6a"
        }
      ]
    },
    {
      "featureType": "transit.station",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#3a4762"
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#0e1626"
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#4e6d70"
        }
      ]
    }
  ]
  ''';
}
