import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../services/checkout_service.dart';
import './widgets/payment_status_card.dart';
import './widgets/rental_status_card.dart';
import './widgets/rental_timeline_widget.dart';
import './widgets/vehicle_info_card.dart';

class RentalStatusScreen extends StatefulWidget {
  const RentalStatusScreen({super.key});

  @override
  State<RentalStatusScreen> createState() => _RentalStatusScreenState();
}

class _RentalStatusScreenState extends State<RentalStatusScreen> {
  final AuthService _authService = AuthService();
  final CheckoutService _checkoutService = CheckoutService();

  List<Map<String, dynamic>> _rentals = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadRentals();
  }

  Future<void> _loadRentals() async {
    if (!_authService.isAuthenticated) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'กรุณาเข้าสู่ระบบเพื่อดูสถานะการเช่า';
      });
      return;
    }

    try {
      final userEmail = _authService.currentUser!.email!;
      final rentals = await _checkoutService.getUserReservations(userEmail);

      setState(() {
        _rentals = rentals;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _handleCancelReservation(String reservationId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยืนยันการยกเลิก'),
        content: const Text('คุณต้องการยกเลิกการจองนี้ใช่หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('ไม่'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('ยกเลิก'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _checkoutService.cancelReservation(reservationId);
        _loadRentals();
        _showSuccessSnackBar('ยกเลิกการจองสำเร็จ');
      } catch (error) {
        _showErrorSnackBar(error.toString());
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('สถานะการเช่า'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            '/ride-request-screen',
            (route) => false,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadRentals,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_authService.isAuthenticated) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline, size: 64.0, color: Colors.grey[400]),
            SizedBox(height: 2.h),
            Text('กรุณาเข้าสู่ระบบ',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 1.h),
            Text('เพื่อดูสถานะการเช่าของคุณ',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.authentication),
              child: const Text('เข้าสู่ระบบ'),
            ),
          ],
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.0, color: Colors.red[300]),
            SizedBox(height: 2.h),
            Text('เกิดข้อผิดพลาด', style: TextStyle(fontSize: 18.sp)),
            SizedBox(height: 1.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
              ),
            ),
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: _loadRentals,
              child: const Text('ลองอีกครั้ง'),
            ),
          ],
        ),
      );
    }

    if (_rentals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.car_rental, size: 64.0, color: Colors.grey[400]),
            SizedBox(height: 2.h),
            Text('ไม่มีการเช่า', style: TextStyle(fontSize: 18.sp)),
            SizedBox(height: 1.h),
            Text('คุณยังไม่มีประวัติการเช่ารถ',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.rideRequest),
              child: const Text('เริ่มจองรถ'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadRentals,
      child: ListView.builder(
        padding: EdgeInsets.all(4.w),
        itemCount: _rentals.length,
        itemBuilder: (context, index) {
          final rental = _rentals[index];
          return _buildRentalCard(rental);
        },
      ),
    );
  }

  Widget _buildRentalCard(Map<String, dynamic> rental) {
    final vehicle = rental['vehicles'];
    final payments = rental['payment_transactions'] as List?;

    return Card(
      elevation: 2.0,
      margin: EdgeInsets.only(bottom: 2.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        children: [
          RentalStatusCard(rental: rental),
          Divider(height: 1.h),
          VehicleInfoCard(vehicle: vehicle),
          Divider(height: 1.h),
          RentalTimelineWidget(rental: rental),
          if (payments != null && payments.isNotEmpty) ...[
            Divider(height: 1.h),
            PaymentStatusCard(payments: payments),
          ],
          if (rental['status'] == 'pending') ...[
            Divider(height: 1.h),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _handleCancelReservation(rental['id']),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('ยกเลิกการจอง'),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
