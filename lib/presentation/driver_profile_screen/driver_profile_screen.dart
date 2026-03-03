import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/communication_widget.dart';
import './widgets/driver_header_widget.dart';
import './widgets/rating_breakdown_widget.dart';
import './widgets/safety_info_widget.dart';
import './widgets/trip_statistics_widget.dart';
import './widgets/vehicle_info_widget.dart';

class DriverProfileScreen extends StatefulWidget {
  const DriverProfileScreen({super.key});

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  bool _isLoading = true;

  // Mock driver data
  final Map<String, dynamic> _driverData = {
    "id": "driver_001",
    "name": "Michael Rodriguez",
    "photo": "https://images.unsplash.com/photo-1705645930353-0e335311ef20",
    "photoSemanticLabel":
        "Professional headshot of a Hispanic man with short dark hair and a friendly smile, wearing a navy blue collared shirt",
    "rating": 4.8,
    "totalRatings": 1247,
    "isVerified": true,
    "isProfessional": true,
    "phoneNumber": "+1 (555) 123-4567",
    "yearsExperience": 5,
    "joinDate": "March 2019",
  };

  final Map<String, dynamic> _vehicleData = {
    "make": "Toyota",
    "model": "Camry",
    "year": 2022,
    "color": "Silver",
    "licensePlate": "ABC-1234",
    "photo": "https://images.unsplash.com/photo-1705357760542-9aef89fa2910",
    "photoSemanticLabel":
        "Silver Toyota Camry sedan parked on a clean street, showing the front and side profile of the vehicle",
  };

  final Map<String, dynamic> _ratingData = {
    "overall": 4.8,
    "totalRatings": 1247,
    "distribution": [85.0, 12.0, 2.0, 1.0, 0.0], // 5-star to 1-star percentages
  };

  final List<Map<String, dynamic>> _recentComments = [
    {
      "id": 1,
      "passengerName": "Sarah Johnson",
      "rating": 5,
      "comment":
          "Excellent driver! Very professional and the car was spotless. Arrived exactly on time and took the most efficient route.",
      "date": "2 days ago",
    },
    {
      "id": 2,
      "passengerName": "David Chen",
      "rating": 5,
      "comment":
          "Michael is fantastic! Great conversation and made me feel very safe during the ride. Highly recommend!",
      "date": "1 week ago",
    },
    {
      "id": 3,
      "passengerName": "Emma Wilson",
      "rating": 4,
      "comment":
          "Good driver, smooth ride. Only minor issue was the music was a bit loud, but overall great experience.",
      "date": "2 weeks ago",
    },
    {
      "id": 4,
      "passengerName": "James Martinez",
      "rating": 5,
      "comment":
          "Perfect ride! Michael was waiting when I arrived and helped with my luggage. Very courteous and professional.",
      "date": "3 weeks ago",
    },
  ];

  final Map<String, dynamic> _statisticsData = {
    "totalRides": 2847,
    "yearsExperience": 5,
    "specializations": [
      "Airport Transfers",
      "Business Travel",
      "Night Rides",
      "Long Distance"
    ],
    "acceptanceRate": 98,
    "cancellationRate": 2,
    "avgResponseTime": 3,
  };

  final Map<String, dynamic> _safetyData = {
    "backgroundCheck": true,
    "insuranceVerified": true,
    "platformCertified": true,
    "vehicleInspected": true,
    "lastUpdated": "October 15, 2024",
  };

  final List<Map<String, dynamic>> _previousRides = [
    {
      "id": "ride_001",
      "date": "September 28, 2024",
      "from": "Downtown Office",
      "to": "Airport Terminal 2",
      "rating": 5,
      "fare": "\$45.50",
    },
    {
      "id": "ride_002",
      "date": "August 15, 2024",
      "from": "Hotel Plaza",
      "to": "Convention Center",
      "rating": 5,
      "fare": "\$28.75",
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadDriverData();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _slideController.forward();
  }

  Future<void> _loadDriverData() async {
    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SlideTransition(
        position: _slideAnimation,
        child: _isLoading ? _buildLoadingState(theme) : _buildContent(theme),
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: theme.colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: theme.colorScheme.primary,
          ),
          SizedBox(height: 3.h),
          Text(
            'กำลังโหลดโปรไฟล์คนขับ...',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        // Handle drag to dismiss
        if (details.delta.dy > 0) {
          final sensitivity = 300;
          if (details.delta.dy > sensitivity / 100) {
            _handleClose();
          }
        }
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            // Driver header with photo and basic info
            DriverHeaderWidget(
              driverData: _driverData,
              onClose: _handleClose,
            ),

            // Scrollable content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                color: theme.colorScheme.primary,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: 2.h),

                      // Vehicle information
                      VehicleInfoWidget(
                        vehicleData: _vehicleData,
                      ),

                      // Rating breakdown
                      RatingBreakdownWidget(
                        ratingData: _ratingData,
                        recentComments: _recentComments,
                      ),

                      // Trip statistics
                      TripStatisticsWidget(
                        statisticsData: _statisticsData,
                      ),

                      // Communication options
                      CommunicationWidget(
                        driverData: _driverData,
                      ),

                      // Safety information
                      SafetyInfoWidget(
                        safetyData: _safetyData,
                      ),

                      // Previous rides (if any)
                      if (_previousRides.isNotEmpty)
                        _buildPreviousRidesSection(theme),

                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviousRidesSection(ThemeData theme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'การเดินทางก่อนหน้ากับ ${_driverData["name"]}',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 3.h),
          Column(
            children: _previousRides.map((ride) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 1.h),
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ride["date"] as String,
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            '${ride["from"]} → ${ride["to"]}',
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSurface,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(5, (index) {
                            return CustomIconWidget(
                              iconName: index < (ride["rating"] as int)
                                  ? 'star'
                                  : 'star_border',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 12,
                            );
                          }),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          ride["fare"] as String,
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRefresh() async {
    HapticFeedback.lightImpact();

    setState(() {
      _isLoading = true;
    });

    await _loadDriverData();
  }

  void _handleClose() {
    HapticFeedback.lightImpact();

    _slideController.reverse().then((_) {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }
}
