import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'dart:async';

import '../../core/app_export.dart';
import '../../models/reservation_model.dart';
import '../../models/vehicle_model.dart';
import '../../routes/app_routes.dart';
import '../../services/reservation_service.dart';
import '../../services/vehicle_service.dart';
import '../../services/supabase_service.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final ReservationService _reservationService = ReservationService();
  final VehicleService _vehicleService = VehicleService();
  final SupabaseService _supabaseService = SupabaseService.instance;

  bool _isLoading = true;
  String? _errorMessage;

  List<ReservationModel> _allReservations = [];
  List<VehicleModel> _allVehicles = [];

  DateTime _startDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime _endDate = DateTime.now();

  // Real-time subscription streams
  StreamSubscription? _reservationsSubscription;
  StreamSubscription? _vehiclesSubscription;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
    _setupRealtimeSubscriptions();
  }

  @override
  void dispose() {
    _reservationsSubscription?.cancel();
    _vehiclesSubscription?.cancel();
    super.dispose();
  }

  Future<void> _setupRealtimeSubscriptions() async {
    try {
      // Subscribe to reservations table changes
      _reservationsSubscription = _supabaseService.client
          .from('reservations')
          .stream(primaryKey: ['id']).listen((List<Map<String, dynamic>> data) {
        if (mounted) {
          setState(() {
            _allReservations =
                data.map((json) => ReservationModel.fromJson(json)).toList();
          });
        }
      }, onError: (error) {
        if (mounted) {
          setState(() {
            _errorMessage = 'การเชื่อมต่อแบบเรียลไทม์ล้มเหลว: $error';
          });
        }
      });

      // Subscribe to vehicles table changes
      _vehiclesSubscription = _supabaseService.client
          .from('vehicles')
          .stream(primaryKey: ['id']).listen((List<Map<String, dynamic>> data) {
        if (mounted) {
          setState(() {
            _allVehicles =
                data.map((json) => VehicleModel.fromJson(json)).toList();
          });
        }
      }, onError: (error) {
        if (mounted) {
          setState(() {
            _errorMessage = 'การเชื่อมต่อแบบเรียลไทม์ล้มเหลว: $error';
          });
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'ไม่สามารถตั้งค่าการเชื่อมต่อแบบเรียลไทม์: $e';
        });
      }
    }
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final reservations = await _reservationService.getAllReservations();
      final vehicles = await _vehicleService.getAllVehicles();

      setState(() {
        _allReservations = reservations;
        _allVehicles = vehicles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'เกิดข้อผิดพลาดในการโหลดข้อมูล: $e';
        _isLoading = false;
      });
    }
  }

  int get _todayBookingsCount {
    final today = DateTime.now();
    return _allReservations.where((r) {
      final createdDate = r.createdAt;
      return createdDate.year == today.year &&
          createdDate.month == today.month &&
          createdDate.day == today.day;
    }).length;
  }

  double get _totalRevenue {
    return _allReservations
        .where((r) =>
            r.status == ReservationStatus.completed ||
            r.status == ReservationStatus.confirmed ||
            r.status == ReservationStatus.active)
        .fold(0.0, (sum, r) => sum + (r.totalAmount.toDouble() ?? 0.0));
  }

  double get _vehicleUtilizationRate {
    if (_allVehicles.isEmpty) return 0.0;
    final unavailableCount = _allVehicles.where((v) => !v.isAvailable).length;
    return (unavailableCount / _allVehicles.length) * 100;
  }

  int get _activeCustomersCount {
    return _allReservations
        .where((r) =>
            r.status == ReservationStatus.active ||
            r.status == ReservationStatus.confirmed)
        .map((r) => r.customerEmail)
        .toSet()
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.pink),
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            '/ride-request-screen',
            (route) => false,
          ),
        ),
        title: Row(
          children: [
            Text(
              'แดชบอร์ดผู้ดูแลระบบ',
              style: TextStyle(
                color: Colors.grey[900],
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 2.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
              decoration: BoxDecoration(
                color: Colors.green.withAlpha(26),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'สด',
                    style: TextStyle(
                      fontSize: 9.sp,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range, color: Colors.pink),
            onPressed: _showDateRangePicker,
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.pink),
            onPressed: _loadDashboardData,
          ),
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.pink),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _errorMessage != null
              ? _buildErrorState()
              : _buildDashboardContent(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.pink),
          SizedBox(height: 2.h),
          Text(
            'กำลังโหลดข้อมูล...',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
          SizedBox(height: 2.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
            ),
          ),
          SizedBox(height: 3.h),
          ElevatedButton.icon(
            onPressed: _loadDashboardData,
            icon: const Icon(Icons.refresh),
            label: const Text('ลองอีกครั้ง'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent() {
    return RefreshIndicator(
      onRefresh: _loadDashboardData,
      color: Colors.pink,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMetricsCards(),
            SizedBox(height: 2.h),
            _buildRevenueChart(),
            SizedBox(height: 2.h),
            _buildVehicleUtilizationGrid(),
            SizedBox(height: 2.h),
            _buildCustomerMetrics(),
            SizedBox(height: 2.h),
            _buildRealtimeBookingFeed(),
            SizedBox(height: 2.h),
            _buildQuickActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsCards() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 3.w,
      mainAxisSpacing: 2.h,
      childAspectRatio: 1.5,
      children: [
        _buildMetricCard(
          'จองวันนี้',
          _todayBookingsCount.toString(),
          Icons.calendar_today,
          Colors.blue,
          '+12%',
        ),
        _buildMetricCard(
          'รายได้รวม',
          '฿${NumberFormat('#,##0').format(_totalRevenue)}',
          Icons.attach_money,
          Colors.green,
          '+8%',
        ),
        _buildMetricCard(
          'อัตราการใช้งานรถ',
          '${_vehicleUtilizationRate.toStringAsFixed(1)}%',
          Icons.directions_car,
          Colors.orange,
          '+5%',
        ),
        _buildMetricCard(
          'ลูกค้าที่ใช้งาน',
          _activeCustomersCount.toString(),
          Icons.people,
          Colors.purple,
          '+15%',
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String trend,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(26),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(3.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: color.withAlpha(26),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(26),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  trend,
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(26),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'กราฟรายได้',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                onSelected: (value) {},
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'week', child: Text('รายสัปดาห์')),
                  const PopupMenuItem(value: 'month', child: Text('รายเดือน')),
                  const PopupMenuItem(value: 'year', child: Text('รายปี')),
                ],
              ),
            ],
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 25.h,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1000,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey[200]!,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['จ', 'อ', 'พ', 'พฤ', 'ศ', 'ส', 'อา'];
                        return Text(
                          days[value.toInt() % 7],
                          style: TextStyle(
                              fontSize: 10.sp, color: Colors.grey[600]),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${(value / 1000).toInt()}K',
                          style: TextStyle(
                              fontSize: 10.sp, color: Colors.grey[600]),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _generateRevenueSpots(),
                    isCurved: true,
                    color: Colors.pink,
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: Colors.pink,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.pink.withAlpha(26),
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

  List<FlSpot> _generateRevenueSpots() {
    // Generate revenue data based on actual reservations
    final spots = <FlSpot>[];
    for (int i = 0; i < 7; i++) {
      final date = DateTime.now().subtract(Duration(days: 6 - i));
      final dayRevenue = _allReservations.where((r) {
        final rDate = r.createdAt;
        return rDate.year == date.year &&
            rDate.month == date.month &&
            rDate.day == date.day &&
            (r.status == ReservationStatus.completed ||
                r.status == ReservationStatus.confirmed ||
                r.status == ReservationStatus.active);
      }).fold(0.0, (sum, r) => sum + (r.totalAmount.toDouble() ?? 0.0));
      spots.add(FlSpot(i.toDouble(), dayRevenue));
    }
    return spots;
  }

  Widget _buildVehicleUtilizationGrid() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(26),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'สถานะรถยนต์',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
          SizedBox(height: 2.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2.w,
              mainAxisSpacing: 1.h,
              childAspectRatio: 1.2,
            ),
            itemCount: _allVehicles.length,
            itemBuilder: (context, index) {
              final vehicle = _allVehicles[index];
              return _buildVehicleStatusCard(vehicle);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleStatusCard(VehicleModel vehicle) {
    final isAvailable = vehicle.isAvailable;
    return Container(
      decoration: BoxDecoration(
        color:
            isAvailable ? Colors.green.withAlpha(26) : Colors.red.withAlpha(26),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: isAvailable ? Colors.green : Colors.red,
          width: 1,
        ),
      ),
      padding: EdgeInsets.all(2.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_car,
            color: isAvailable ? Colors.green : Colors.red,
            size: 24,
          ),
          SizedBox(height: 0.5.h),
          Text(
            '${vehicle.brand} ${vehicle.model}',
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            isAvailable ? 'ว่าง' : 'ไม่ว่าง',
            style: TextStyle(
              fontSize: 9.sp,
              color: isAvailable ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerMetrics() {
    final uniqueCustomers =
        _allReservations.map((r) => r.customerEmail).toSet().length;
    final completedReservations = _allReservations
        .where((r) => r.status == ReservationStatus.completed)
        .length;
    final retentionRate = _allReservations.isEmpty
        ? 0.0
        : (completedReservations / _allReservations.length) * 100;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(26),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'สถิติลูกค้า',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildCustomerMetricItem(
                  'ลูกค้าทั้งหมด',
                  uniqueCustomers.toString(),
                  Icons.people,
                  Colors.blue,
                ),
              ),
              Expanded(
                child: _buildCustomerMetricItem(
                  'อัตราความสำเร็จ',
                  '${retentionRate.toStringAsFixed(1)}%',
                  Icons.trending_up,
                  Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerMetricItem(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(3.w),
      margin: EdgeInsets.symmetric(horizontal: 1.w),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          SizedBox(height: 1.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRealtimeBookingFeed() {
    final recentReservations = _allReservations.take(5).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(26),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'การจองล่าสุด',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(26),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'เรียลไทม์',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          recentReservations.isEmpty
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                    child: Column(
                      children: [
                        Icon(Icons.event_busy,
                            size: 48, color: Colors.grey[300]),
                        SizedBox(height: 1.h),
                        Text(
                          'ยังไม่มีการจอง',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentReservations.length,
                  separatorBuilder: (context, index) => Divider(height: 2.h),
                  itemBuilder: (context, index) {
                    final reservation = recentReservations[index];
                    final vehicle = _allVehicles.firstWhere(
                      (v) => v.id == reservation.vehicleId,
                      orElse: () => VehicleModel(
                        id: '',
                        brand: 'ไม่ทราบ',
                        model: '',
                        year: 0,
                        seats: 0,
                        transmission: '',
                        fuelType: '',
                        pricePerDay: 0,
                        imageUrl: '',
                        isAvailable: true,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                      ),
                    );

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: _getStatusColor(
                                reservation.status.toString().split('.').last)
                            .withAlpha(51),
                        child: Icon(
                          Icons.directions_car,
                          color: _getStatusColor(
                              reservation.status.toString().split('.').last),
                        ),
                      ),
                      title: Text(
                        reservation.customerName,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${vehicle.brand} ${vehicle.model} • ${DateFormat('dd MMM yyyy', 'th').format(reservation.startDate)}',
                        style:
                            TextStyle(fontSize: 11.sp, color: Colors.grey[600]),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '฿${NumberFormat('#,##0').format(reservation.totalAmount)}',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.3.h),
                            decoration: BoxDecoration(
                              color: _getStatusColor(reservation.status
                                      .toString()
                                      .split('.')
                                      .last)
                                  .withAlpha(26),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              _getStatusText(reservation.status
                                  .toString()
                                  .split('.')
                                  .last),
                              style: TextStyle(
                                fontSize: 9.sp,
                                color: _getStatusColor(reservation.status
                                    .toString()
                                    .split('.')
                                    .last),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(26),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'การดำเนินการด่วน',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
          SizedBox(height: 2.h),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 2.h,
            childAspectRatio: 2,
            children: [
              _buildQuickActionButton(
                'เพิ่มรถใหม่',
                Icons.add_circle,
                Colors.blue,
                () => Navigator.pushNamed(context, AppRoutes.vehicleManagement),
              ),
              _buildQuickActionButton(
                'จัดการการจอง',
                Icons.event_note,
                Colors.orange,
                () => Navigator.pushNamed(context, AppRoutes.adminReservations),
              ),
              _buildQuickActionButton(
                'สร้างรายงาน',
                Icons.assessment,
                Colors.purple,
                () {},
              ),
              _buildQuickActionButton(
                'ตั้งค่า',
                Icons.settings,
                Colors.grey,
                () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: color.withAlpha(26),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: color.withAlpha(77)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(width: 2.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.blue;
      case 'active':
        return Colors.green;
      case 'completed':
        return Colors.grey;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'confirmed':
        return 'ยืนยันแล้ว';
      case 'active':
        return 'กำลังใช้งาน';
      case 'completed':
        return 'เสร็จสิ้น';
      case 'cancelled':
        return 'ยกเลิก';
      default:
        return 'รอดำเนินการ';
    }
  }

  Future<void> _showDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.pink),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      await _loadDashboardData();
    }
  }
}
