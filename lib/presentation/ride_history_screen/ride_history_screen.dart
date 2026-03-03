import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_tab_bar.dart';
import './widgets/ride_history_card.dart';
import './widgets/ride_history_empty_state.dart';
import './widgets/ride_history_filter_sheet.dart';
import './widgets/ride_history_search_bar.dart';
import './widgets/ride_history_skeleton_loader.dart';

class RideHistoryScreen extends StatefulWidget {
  const RideHistoryScreen({super.key});

  @override
  State<RideHistoryScreen> createState() => _RideHistoryScreenState();
}

class _RideHistoryScreenState extends State<RideHistoryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late CustomTabBarController _customTabController;
  late ScrollController _scrollController;

  String _searchQuery = '';
  Map<String, dynamic> _activeFilters = {
    'status': 'All',
    'paymentMethod': 'All',
    'rating': 'All',
    'startDate': null,
    'endDate': null,
  };

  bool _isLoading = false;
  bool _isRefreshing = false;
  List<Map<String, dynamic>> _allRides = [];
  List<Map<String, dynamic>> _filteredRides = [];

  final List<TabItem> _tabs = const [
    TabItem(label: 'ทั้งหมด', icon: Icons.list_rounded),
    TabItem(label: 'เสร็จสิ้น', icon: Icons.check_circle_rounded),
    TabItem(label: 'ยกเลิก', icon: Icons.cancel_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _customTabController = CustomTabBarController();
    _scrollController = ScrollController();

    _tabController.addListener(_handleTabChange);
    _loadRideHistory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _customTabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      _customTabController.selectTab(_tabController.index);
      _applyTabFilter();
    }
  }

  void _applyTabFilter() {
    String statusFilter = 'All';
    switch (_tabController.index) {
      case 1:
        statusFilter = 'Completed';
        break;
      case 2:
        statusFilter = 'Cancelled';
        break;
      default:
        statusFilter = 'All';
    }

    setState(() {
      _activeFilters['status'] = statusFilter;
    });
    _filterRides();
  }

  Future<void> _loadRideHistory() async {
    setState(() => _isLoading = true);

    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      _allRides = _generateMockRideData();
      _isLoading = false;
    });

    _filterRides();
  }

  Future<void> _refreshRideHistory() async {
    setState(() => _isRefreshing = true);

    // Simulate refresh delay
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _allRides = _generateMockRideData();
      _isRefreshing = false;
    });

    _filterRides();
  }

  void _filterRides() {
    List<Map<String, dynamic>> filtered = List.from(_allRides);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((ride) {
        final destination =
            (ride['destinationAddress'] as String).toLowerCase();
        final pickup = (ride['pickupAddress'] as String).toLowerCase();
        final driverName = (ride['driverName'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();

        return destination.contains(query) ||
            pickup.contains(query) ||
            driverName.contains(query);
      }).toList();
    }

    // Apply status filter
    if (_activeFilters['status'] != 'All') {
      filtered = filtered
          .where((ride) =>
              (ride['status'] as String).toLowerCase() ==
              (_activeFilters['status'] as String).toLowerCase())
          .toList();
    }

    // Apply payment method filter
    if (_activeFilters['paymentMethod'] != 'All') {
      filtered = filtered
          .where((ride) =>
              (ride['paymentMethod'] as String) ==
              _activeFilters['paymentMethod'])
          .toList();
    }

    // Apply rating filter
    if (_activeFilters['rating'] != 'All') {
      final ratingFilter = _activeFilters['rating'] as String;
      if (ratingFilter.contains('Stars')) {
        final minRating =
            int.parse(ratingFilter.split(' ')[0].replaceAll('+', ''));
        filtered = filtered
            .where((ride) => (ride['driverRating'] as double) >= minRating)
            .toList();
      }
    }

    // Apply date range filter
    if (_activeFilters['startDate'] != null ||
        _activeFilters['endDate'] != null) {
      filtered = filtered.where((ride) {
        final rideDate = ride['date'] as DateTime;
        final startDate = _activeFilters['startDate'] as DateTime?;
        final endDate = _activeFilters['endDate'] as DateTime?;

        if (startDate != null && rideDate.isBefore(startDate)) return false;
        if (endDate != null &&
            rideDate.isAfter(endDate.add(const Duration(days: 1))))
          return false;

        return true;
      }).toList();
    }

    // Sort by date (newest first)
    filtered.sort(
        (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));

    setState(() {
      _filteredRides = filtered;
    });
  }

  void _handleSearchChanged(String query) {
    setState(() => _searchQuery = query);
    _filterRides();
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: RideHistoryFilterSheet(
          currentFilters: _activeFilters,
          onFiltersApplied: (filters) {
            setState(() => _activeFilters = filters);
            _filterRides();
          },
        ),
      ),
    );
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _activeFilters = {
        'status': _activeFilters['status'], // Keep current tab filter
        'paymentMethod': 'All',
        'rating': 'All',
        'startDate': null,
        'endDate': null,
      };
    });
    _filterRides();
  }

  bool get _hasActiveFilters {
    return _activeFilters['paymentMethod'] != 'All' ||
        _activeFilters['rating'] != 'All' ||
        _activeFilters['startDate'] != null ||
        _activeFilters['endDate'] != null;
  }

  void _handleRideCardTap(Map<String, dynamic> rideData) {
    // Navigate to detailed ride view
    _showRideDetails(rideData);
  }

  void _showRideDetails(Map<String, dynamic> rideData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildRideDetailsSheet(rideData),
    );
  }

  Widget _buildRideDetailsSheet(Map<String, dynamic> rideData) {
    final theme = Theme.of(context);

    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'รายละเอียดการเดินทาง',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'สรุปการเดินทาง',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'นี่คือรายละเอียดการเดินทางของคุณ ในแอปจริงจะแสดงใบเสร็จ แผนที่เส้นทาง ข้อมูลคนขับ และรายละเอียดเพิ่มเติม',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        variant: CustomAppBarVariant.standard,
        title: 'ประวัติการเช่า',
        showBackButton: false,
      ),
      body: Column(
        children: [
          RideHistorySearchBar(
            initialQuery: _searchQuery,
            onSearchChanged: _handleSearchChanged,
            onFilterTap: _showFilterSheet,
            hasActiveFilters: _hasActiveFilters,
          ),
          CustomTabBar(
            variant: CustomTabBarVariant.standard,
            tabs: _tabs,
            selectedIndex: _customTabController.selectedIndex,
            onTap: (index) {
              _tabController.animateTo(index);
              _customTabController.selectTab(index);
            },
          ),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        variant: CustomBottomBarVariant.standard,
        currentIndex: 2, // History tab
        onTap: (index) {
          HapticFeedback.lightImpact();
          // Handle navigation based on index
          switch (index) {
            case 0:
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/ride-request-screen',
                (route) => false,
              );
              break;
            case 1:
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/live-tracking-screen',
                (route) => false,
              );
              break;
            case 2:
              // Already on history screen
              break;
            case 3:
              Navigator.pushNamed(context, '/user-profile-screen');
              break;
          }
        },
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const RideHistorySkeletonLoader();
    }

    if (_filteredRides.isEmpty) {
      return RideHistoryEmptyState(
        isSearchResult: _searchQuery.isNotEmpty || _hasActiveFilters,
        searchQuery: _searchQuery,
        onTakeFirstRide: () {
          Navigator.pushNamed(context, '/ride-request-screen');
        },
        onClearSearch: _clearSearch,
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshRideHistory,
      color: AppTheme.lightTheme.primaryColor,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.only(bottom: 2.h),
        itemCount: _filteredRides.length,
        itemBuilder: (context, index) {
          final ride = _filteredRides[index];

          return RideHistoryCard(
            rideData: ride,
            onTap: () => _handleRideCardTap(ride),
            onViewReceipt: () => _showRideDetails(ride),
            onRebook: () {
              // Navigate to ride request with pre-filled data
              Navigator.pushNamed(context, '/ride-request-screen');
            },
            onRateDriver: () {
              _showRatingDialog(ride);
            },
            onReportIssue: () {
              _showReportIssueDialog(ride);
            },
          );
        },
      ),
    );
  }

  void _showRatingDialog(Map<String, dynamic> rideData) {
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        int selectedRating = rideData['rating'] as int? ?? 0;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('ให้คะแนนคนขับ'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'การเดินทางกับ ${rideData['driverName']} เป็นอย่างไร?',
                    style: theme.textTheme.bodyMedium,
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() => selectedRating = index + 1);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1.w),
                          child: CustomIconWidget(
                            iconName:
                                index < selectedRating ? 'star' : 'star_border',
                            color: index < selectedRating
                                ? AppTheme.warningLight
                                : theme.colorScheme.onSurfaceVariant,
                            size: 32,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('ยกเลิก'),
                ),
                ElevatedButton(
                  onPressed: selectedRating > 0
                      ? () {
                          rideData['rating'] = selectedRating;
                          Navigator.pop(context);
                          setState(() {});
                        }
                      : null,
                  child: const Text('ยืนยัน'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showReportIssueDialog(Map<String, dynamic> rideData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('แจ้งปัญหา'),
          content: const Text(
              'แจ้งปัญหาเกี่ยวกับการเดินทางนี้ ในแอปจริงจะเปิดฟอร์มแจ้งปัญหาแบบละเอียด'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ยกเลิก'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('แจ้ง'),
            ),
          ],
        );
      },
    );
  }

  List<Map<String, dynamic>> _generateMockRideData() {
    final now = DateTime.now();

    return [
      {
        'id': 1,
        'date': now.subtract(const Duration(hours: 2)),
        'pickupAddress': '123 Main Street, Downtown',
        'destinationAddress': 'Central Park Mall, Shopping District',
        'driverName': 'Michael Rodriguez',
        'driverPhoto':
            'https://images.unsplash.com/photo-1596717951382-a3cbbdd4b8fd',
        'driverPhotoSemanticLabel':
            'Professional headshot of a Hispanic man with short dark hair wearing a navy blue shirt',
        'driverRating': 4.8,
        'vehicleModel': 'Toyota Camry',
        'fare': '\$24.50',
        'duration': '18 min',
        'status': 'Completed',
        'paymentMethod': 'Credit Card',
        'rating': 5,
      },
      {
        'id': 2,
        'date': now.subtract(const Duration(days: 1, hours: 5)),
        'pickupAddress': 'Airport Terminal 2, Departure Gate',
        'destinationAddress': '456 Oak Avenue, Residential Area',
        'driverName': 'Sarah Johnson',
        'driverPhoto':
            'https://images.unsplash.com/photo-1725271765764-669af9988700',
        'driverPhotoSemanticLabel':
            'Professional headshot of a young woman with blonde hair and a warm smile wearing a light blue top',
        'driverRating': 4.9,
        'vehicleModel': 'Honda Accord',
        'fare': '\$45.75',
        'duration': '32 min',
        'status': 'Completed',
        'paymentMethod': 'Digital Wallet',
        'rating': 4,
      },
      {
        'id': 3,
        'date': now.subtract(const Duration(days: 2, hours: 3)),
        'pickupAddress': 'City Hospital, Emergency Entrance',
        'destinationAddress': '789 Pine Street, Medical District',
        'driverName': 'David Chen',
        'driverPhoto':
            'https://images.unsplash.com/photo-1687256457585-3608dfa736c5',
        'driverPhotoSemanticLabel':
            'Professional headshot of an Asian man with glasses and short black hair wearing a white collared shirt',
        'driverRating': 4.7,
        'vehicleModel': 'Nissan Altima',
        'fare': '\$18.25',
        'duration': '12 min',
        'status': 'Completed',
        'paymentMethod': 'Cash',
        'rating': 5,
      },
      {
        'id': 4,
        'date': now.subtract(const Duration(days: 3, hours: 8)),
        'pickupAddress': 'University Campus, Student Center',
        'destinationAddress': 'Downtown Library, Main Branch',
        'driverName': 'Emma Wilson',
        'driverPhoto':
            'https://images.unsplash.com/photo-1674388725660-7727411a47e4',
        'driverPhotoSemanticLabel':
            'Professional headshot of a young woman with curly brown hair and friendly expression wearing a green sweater',
        'driverRating': 4.6,
        'vehicleModel': 'Hyundai Elantra',
        'fare': '\$15.00',
        'duration': '15 min',
        'status': 'Cancelled',
        'paymentMethod': 'Credit Card',
        'rating': 0,
      },
      {
        'id': 5,
        'date': now.subtract(const Duration(days: 4, hours: 6)),
        'pickupAddress': 'Business District, Office Tower',
        'destinationAddress': 'Riverside Restaurant, Waterfront',
        'driverName': 'James Thompson',
        'driverPhoto':
            'https://images.unsplash.com/photo-1555869716-7c8fceeac263',
        'driverPhotoSemanticLabel':
            'Professional headshot of a middle-aged man with beard and brown hair wearing a dark jacket',
        'driverRating': 4.5,
        'vehicleModel': 'Ford Fusion',
        'fare': '\$28.90',
        'duration': '22 min',
        'status': 'Completed',
        'paymentMethod': 'Digital Wallet',
        'rating': 4,
      },
      {
        'id': 6,
        'date': now.subtract(const Duration(days: 5, hours: 4)),
        'pickupAddress': 'Shopping Mall, Main Entrance',
        'destinationAddress': 'Home Address, Suburban Area',
        'driverName': 'Lisa Martinez',
        'driverPhoto':
            'https://images.unsplash.com/photo-1597725096039-7a277e984835',
        'driverPhotoSemanticLabel':
            'Professional headshot of a Latina woman with long dark hair and bright smile wearing a red blouse',
        'driverRating': 4.9,
        'vehicleModel': 'Chevrolet Malibu',
        'fare': '\$22.40',
        'duration': '19 min',
        'status': 'Completed',
        'paymentMethod': 'Cash',
        'rating': 5,
      },
      {
        'id': 7,
        'date': now.subtract(const Duration(days: 6, hours: 7)),
        'pickupAddress': 'Train Station, Platform 3',
        'destinationAddress': 'Hotel Grand Plaza, Lobby',
        'driverName': 'Robert Kim',
        'driverPhoto':
            'https://images.unsplash.com/photo-1698072556534-40ec6e337311',
        'driverPhotoSemanticLabel':
            'Professional headshot of an Asian man with short black hair and glasses wearing a blue button-up shirt',
        'driverRating': 4.8,
        'vehicleModel': 'Mazda 6',
        'fare': '\$31.20',
        'duration': '25 min',
        'status': 'Completed',
        'paymentMethod': 'Credit Card',
        'rating': 4,
      },
    ];
  }
}
