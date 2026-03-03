import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../models/reservation_model.dart';
import '../../models/vehicle_model.dart';
import '../../services/reservation_service.dart';
import '../../services/vehicle_service.dart';
import './widgets/reservation_card_widget.dart';
import './widgets/reservation_details_dialog.dart';
import './widgets/reservation_filter_sheet.dart';

class AdminReservationsScreen extends StatefulWidget {
  const AdminReservationsScreen({Key? key}) : super(key: key);

  @override
  State<AdminReservationsScreen> createState() =>
      _AdminReservationsScreenState();
}

class _AdminReservationsScreenState extends State<AdminReservationsScreen> {
  final ReservationService _reservationService = ReservationService();
  final VehicleService _vehicleService = VehicleService();

  List<ReservationModel> _reservations = [];
  List<ReservationModel> _filteredReservations = [];
  Map<String, VehicleModel> _vehiclesMap = {};
  bool _isLoading = true;
  String _searchQuery = '';
  ReservationStatus? _selectedStatusFilter;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final reservations = await _reservationService.getAllReservations();
      final vehicles = await _vehicleService.getAllVehicles();

      final vehiclesMap = <String, VehicleModel>{};
      for (var vehicle in vehicles) {
        if (vehicle.id != null) {
          vehiclesMap[vehicle.id!] = vehicle;
        }
      }

      setState(() {
        _reservations = reservations;
        _filteredReservations = reservations;
        _vehiclesMap = vehiclesMap;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackbar('ไม่สามารถโหลดข้อมูลจองได้: $e');
    }
  }

  void _filterReservations() {
    setState(() {
      _filteredReservations = _reservations.where((reservation) {
        final matchesSearch = _searchQuery.isEmpty ||
            reservation.customerName
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            reservation.customerEmail
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            reservation.customerPhone.contains(_searchQuery);

        final matchesStatus = _selectedStatusFilter == null ||
            reservation.status == _selectedStatusFilter;

        return matchesSearch && matchesStatus;
      }).toList();
    });
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ReservationFilterSheet(
        selectedStatus: _selectedStatusFilter,
        onFilterApplied: (status) {
          setState(() => _selectedStatusFilter = status);
          _filterReservations();
        },
      ),
    );
  }

  void _showReservationDetails(ReservationModel reservation) {
    final vehicle = _vehiclesMap[reservation.vehicleId];
    showDialog(
      context: context,
      builder: (context) => ReservationDetailsDialog(
        reservation: reservation,
        vehicle: vehicle,
        onStatusChanged: (newStatus) async {
          try {
            await _reservationService.updateReservationStatus(
                reservation.id!, newStatus);
            _loadData();
            _showSuccessSnackbar('อัปเดตสถานะสำเร็จ');
          } catch (e) {
            _showErrorSnackbar('ไม่สามารถอัปเดตสถานะได้: $e');
          }
        },
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  int _getStatusCount(ReservationStatus status) {
    return _reservations.where((r) => r.status == status).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'จัดการการจอง',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            '/admin-dashboard-screen',
            (route) => false,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterSheet,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: EdgeInsets.all(3.w),
            color: Colors.grey[100],
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ค้นหาด้วยชื่อ อีเมล หรือเบอร์โทร...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
                _filterReservations();
              },
            ),
          ),

          // Status Summary Cards
          Container(
            height: 12.h,
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildStatusCard('รอดำเนินการ',
                    _getStatusCount(ReservationStatus.pending), Colors.orange),
                SizedBox(width: 2.w),
                _buildStatusCard('ยืนยันแล้ว',
                    _getStatusCount(ReservationStatus.confirmed), Colors.blue),
                SizedBox(width: 2.w),
                _buildStatusCard('กำลังใช้งาน',
                    _getStatusCount(ReservationStatus.active), Colors.green),
                SizedBox(width: 2.w),
                _buildStatusCard('เสร็จสิ้น',
                    _getStatusCount(ReservationStatus.completed), Colors.grey),
              ],
            ),
          ),

          // Filter Indicator
          if (_selectedStatusFilter != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              child: Row(
                children: [
                  Chip(
                    label: Text(
                      'กรอง: ${_selectedStatusFilter!.displayName}',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    deleteIcon: Icon(Icons.close, size: 18),
                    onDeleted: () {
                      setState(() => _selectedStatusFilter = null);
                      _filterReservations();
                    },
                  ),
                ],
              ),
            ),

          // Reservations List
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredReservations.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.event_busy,
                              size: 80,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'ไม่พบข้อมูลการจอง',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadData,
                        child: ListView.builder(
                          padding: EdgeInsets.all(3.w),
                          itemCount: _filteredReservations.length,
                          itemBuilder: (context, index) {
                            final reservation = _filteredReservations[index];
                            final vehicle = _vehiclesMap[reservation.vehicleId];
                            return ReservationCardWidget(
                              reservation: reservation,
                              vehicle: vehicle,
                              onTap: () => _showReservationDetails(reservation),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(String title, int count, Color color) {
    return Container(
      width: 30.w,
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: color.withAlpha(77)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
