import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../models/fleet_vehicle_model.dart';
import '../../services/fleet_service.dart';
import '../../routes/app_routes.dart';
import './widgets/fleet_filter_sheet.dart';
import './widgets/fleet_vehicle_card.dart';
import './widgets/vehicle_details_modal.dart';

class FleetInventoryScreen extends StatefulWidget {
  const FleetInventoryScreen({super.key});

  @override
  State<FleetInventoryScreen> createState() => _FleetInventoryScreenState();
}

class _FleetInventoryScreenState extends State<FleetInventoryScreen> {
  final FleetService _fleetService = FleetService();
  List<FleetVehicleModel> _vehicles = [];
  List<FleetVehicleModel> _filteredVehicles = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedStatus = 'all';
  double? _minPrice;
  double? _maxPrice;
  List<String> _selectedTransmissions = [];
  List<String> _selectedFuelTypes = [];
  int? _selectedSeats;
  DateTime? _availabilityStartDate;
  DateTime? _availabilityEndDate;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFleetVehicles();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFleetVehicles() async {
    setState(() => _isLoading = true);
    try {
      final vehicles = await _fleetService.getFleetVehicles();
      setState(() {
        _vehicles = vehicles;
        _filteredVehicles = vehicles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
      }
    }
  }

  Future<void> _filterVehicles() async {
    setState(() => _isLoading = true);

    try {
      List<FleetVehicleModel> filtered = List.from(_vehicles);

      // Search filter
      if (_searchQuery.isNotEmpty) {
        filtered = filtered.where((vehicle) {
          return vehicle.brand.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ||
              vehicle.model.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ||
              vehicle.licenseplate.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  );
        }).toList();
      }

      // Status filter
      if (_selectedStatus != 'all') {
        filtered = filtered
            .where((vehicle) => vehicle.status == _selectedStatus)
            .toList();
      }

      // Price range filter
      if (_minPrice != null || _maxPrice != null) {
        filtered = await _fleetService.filterByPriceRange(
          filtered.map((v) => v.id).toList(),
          _minPrice,
          _maxPrice,
        );
      }

      // Transmission filter
      if (_selectedTransmissions.isNotEmpty) {
        filtered = filtered.where((vehicle) {
          return _selectedTransmissions.contains(vehicle.transmission);
        }).toList();
      }

      // Fuel type filter
      if (_selectedFuelTypes.isNotEmpty) {
        filtered = filtered.where((vehicle) {
          return _selectedFuelTypes.contains(vehicle.fuelType);
        }).toList();
      }

      // Seats filter
      if (_selectedSeats != null) {
        filtered = filtered
            .where((vehicle) => vehicle.seats == _selectedSeats)
            .toList();
      }

      // Availability date filter
      if (_availabilityStartDate != null && _availabilityEndDate != null) {
        final availableVehicleIds = await _fleetService.checkAvailability(
          _availabilityStartDate!,
          _availabilityEndDate!,
        );
        filtered = filtered.where((vehicle) {
          return availableVehicleIds.contains(vehicle.id);
        }).toList();
      }

      setState(() {
        _filteredVehicles = filtered;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาดในการกรอง: $e')));
      }
    }
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: 80.h,
        child: FleetFilterSheet(
          currentStatus: _selectedStatus,
          minPrice: _minPrice,
          maxPrice: _maxPrice,
          selectedTransmissions: _selectedTransmissions,
          selectedFuelTypes: _selectedFuelTypes,
          selectedSeats: _selectedSeats,
          availabilityStartDate: _availabilityStartDate,
          availabilityEndDate: _availabilityEndDate,
          onApplyFilter: ({
            required String status,
            double? minPrice,
            double? maxPrice,
            List<String>? transmissions,
            List<String>? fuelTypes,
            int? seats,
            DateTime? startDate,
            DateTime? endDate,
          }) {
            setState(() {
              _selectedStatus = status;
              _minPrice = minPrice;
              _maxPrice = maxPrice;
              _selectedTransmissions = transmissions ?? [];
              _selectedFuelTypes = fuelTypes ?? [];
              _selectedSeats = seats;
              _availabilityStartDate = startDate;
              _availabilityEndDate = endDate;
            });
            _filterVehicles();
          },
        ),
      ),
    );
  }

  void _showVehicleDetails(FleetVehicleModel vehicle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VehicleDetailsModal(
        vehicle: vehicle,
        onStatusChanged: () => _loadFleetVehicles(),
      ),
    );
  }

  bool get _hasActiveFilters {
    return _selectedStatus != 'all' ||
        _minPrice != null ||
        _maxPrice != null ||
        _selectedTransmissions.isNotEmpty ||
        _selectedFuelTypes.isNotEmpty ||
        _selectedSeats != null ||
        _availabilityStartDate != null;
  }

  int get _activeFilterCount {
    int count = 0;
    if (_selectedStatus != 'all') count++;
    if (_minPrice != null || _maxPrice != null) count++;
    if (_selectedTransmissions.isNotEmpty) count++;
    if (_selectedFuelTypes.isNotEmpty) count++;
    if (_selectedSeats != null) count++;
    if (_availabilityStartDate != null) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0E5EC),
      appBar: AppBar(
        backgroundColor: Color(0xFFE0E5EC),
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: Color(0xFFE0E5EC),
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withAlpha(230),
                offset: Offset(-4, -4),
                blurRadius: 8.0,
              ),
              BoxShadow(
                color: Colors.black.withAlpha(38),
                offset: Offset(4, 4),
                blurRadius: 8.0,
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(Icons.home, color: Color(0xFF6B7A99), size: 20.sp),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.rideRequest,
                (route) => false,
              );
            },
            padding: EdgeInsets.zero,
          ),
        ),
        title: Text(
          'คลังยานพาหนะ',
          style: TextStyle(
            color: Color(0xFF2C3E50),
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: Color(0xFFE0E5EC),
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withAlpha(230),
                  offset: Offset(-4, -4),
                  blurRadius: 8.0,
                ),
                BoxShadow(
                  color: Colors.black.withAlpha(38),
                  offset: Offset(4, 4),
                  blurRadius: 8.0,
                ),
              ],
            ),
            child: Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.filter_list, color: Color(0xFF6B7A99)),
                  onPressed: _showFilterSheet,
                ),
                if (_hasActiveFilters)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: EdgeInsets.all(0.5.w),
                      decoration: BoxDecoration(
                        color: Color(0xFF5B9FED),
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 4.w,
                        minHeight: 4.w,
                      ),
                      child: Center(
                        child: Text(
                          '$_activeFilterCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 2.w, top: 1.h, bottom: 1.h),
            decoration: BoxDecoration(
              color: Color(0xFFE0E5EC),
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withAlpha(230),
                  offset: Offset(-4, -4),
                  blurRadius: 8.0,
                ),
                BoxShadow(
                  color: Colors.black.withAlpha(38),
                  offset: Offset(4, 4),
                  blurRadius: 8.0,
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.refresh, color: Color(0xFF6B7A99)),
              onPressed: _loadFleetVehicles,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Color(0xFFE0E5EC),
            padding: EdgeInsets.all(3.w),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFE0E5EC),
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(38),
                    offset: Offset(4, 4),
                    blurRadius: 10.0,
                  ),
                  BoxShadow(
                    color: Colors.white.withAlpha(230),
                    offset: Offset(-4, -4),
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() => _searchQuery = value);
                  _filterVehicles();
                },
                decoration: InputDecoration(
                  hintText: 'ค้นหารถ (ยี่ห้อ, รุ่น, ทะเบียน)',
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    color: Color(0xFF9BA8B8),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 20.sp,
                    color: Color(0xFF6B7A99),
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            size: 20.sp,
                            color: Color(0xFF6B7A99),
                          ),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                            _filterVehicles();
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                    vertical: 1.5.h,
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: Color(0xFFE0E5EC),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'พบ ${_filteredVehicles.length} คัน',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7A99),
                  ),
                ),
                if (_hasActiveFilters)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedStatus = 'all';
                        _minPrice = null;
                        _maxPrice = null;
                        _selectedTransmissions = [];
                        _selectedFuelTypes = [];
                        _selectedSeats = null;
                        _availabilityStartDate = null;
                        _availabilityEndDate = null;
                      });
                      _filterVehicles();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 0.5.h,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFE0E5EC),
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withAlpha(230),
                            offset: Offset(-3, -3),
                            blurRadius: 6.0,
                          ),
                          BoxShadow(
                            color: Colors.black.withAlpha(38),
                            offset: Offset(3, 3),
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'ตัวกรอง: $_activeFilterCount',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Color(0xFF5B9FED),
                            ),
                          ),
                          SizedBox(width: 1.w),
                          Icon(
                            Icons.close,
                            size: 16.sp,
                            color: Color(0xFF5B9FED),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(color: Color(0xFF5B9FED)),
                  )
                : _filteredVehicles.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.directions_car_outlined,
                              size: 60.sp,
                              color: Color(0xFF9BA8B8),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'ไม่พบรถที่ตรงกับเงื่อนไข',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Color(0xFF6B7A99),
                              ),
                            ),
                            SizedBox(height: 1.h),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _selectedStatus = 'all';
                                  _minPrice = null;
                                  _maxPrice = null;
                                  _selectedTransmissions = [];
                                  _selectedFuelTypes = [];
                                  _selectedSeats = null;
                                  _availabilityStartDate = null;
                                  _availabilityEndDate = null;
                                  _searchQuery = '';
                                  _searchController.clear();
                                });
                                _filterVehicles();
                              },
                              child: Text(
                                'ล้างตัวกรอง',
                                style: TextStyle(color: Color(0xFF5B9FED)),
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadFleetVehicles,
                        color: Color(0xFF5B9FED),
                        child: GridView.builder(
                          padding: EdgeInsets.all(3.w),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 4.w,
                            mainAxisSpacing: 2.5.h,
                            childAspectRatio: 0.68,
                          ),
                          itemCount: _filteredVehicles.length,
                          itemBuilder: (context, index) {
                            return FleetVehicleCard(
                              vehicle: _filteredVehicles[index],
                              onTap: () =>
                                  _showVehicleDetails(_filteredVehicles[index]),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
