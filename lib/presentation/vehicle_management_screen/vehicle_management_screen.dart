import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../models/vehicle_model.dart';
import '../../services/vehicle_service.dart';
import './widgets/add_edit_vehicle_dialog.dart';
import './widgets/vehicle_card_widget.dart';

class VehicleManagementScreen extends StatefulWidget {
  const VehicleManagementScreen({Key? key}) : super(key: key);

  @override
  State<VehicleManagementScreen> createState() =>
      _VehicleManagementScreenState();
}

class _VehicleManagementScreenState extends State<VehicleManagementScreen> {
  final VehicleService _vehicleService = VehicleService();
  List<VehicleModel> _vehicles = [];
  List<VehicleModel> _filteredVehicles = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    setState(() => _isLoading = true);
    try {
      final vehicles = await _vehicleService.getAllVehicles();
      setState(() {
        _vehicles = vehicles;
        _filteredVehicles = vehicles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackbar('ไม่สามารถโหลดรถยนต์ได้: $e');
    }
  }

  void _filterVehicles() {
    setState(() {
      _filteredVehicles = _vehicles.where((vehicle) {
        final matchesSearch = _searchQuery.isEmpty ||
            vehicle.brand.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            vehicle.model.toLowerCase().contains(_searchQuery.toLowerCase());

        final matchesFilter = _selectedFilter == 'ทั้งหมด' ||
            (_selectedFilter == 'ว่าง' && vehicle.isAvailable) ||
            (_selectedFilter == 'ไม่ว่าง' && !vehicle.isAvailable);

        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  void _showAddVehicleDialog() {
    showDialog(
      context: context,
      builder: (context) => AddEditVehicleDialog(
        onSave: (vehicle) async {
          try {
            await _vehicleService.addVehicle(vehicle);
            _loadVehicles();
            _showSuccessSnackbar('เพิ่มรถยนต์สำเร็จ');
          } catch (e) {
            _showErrorSnackbar('ไม่สามารถเพิ่มรถยนต์ได้: $e');
          }
        },
      ),
    );
  }

  void _showEditVehicleDialog(VehicleModel vehicle) {
    showDialog(
      context: context,
      builder: (context) => AddEditVehicleDialog(
        vehicle: vehicle,
        onSave: (updatedVehicle) async {
          try {
            await _vehicleService.updateVehicle(vehicle.id!, updatedVehicle);
            _loadVehicles();
            _showSuccessSnackbar('อัปเดตรถยนต์สำเร็จ');
          } catch (e) {
            _showErrorSnackbar('ไม่สามารถอัปเดตรถยนต์ได้: $e');
          }
        },
      ),
    );
  }

  Future<void> _deleteVehicle(VehicleModel vehicle) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ลบรถยนต์'),
        content: Text(
            'คุณแน่ใจหรือไม่ว่าต้องการลบ ${vehicle.brand} ${vehicle.model}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('ลบ'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _vehicleService.deleteVehicle(vehicle.id!);
        _loadVehicles();
        _showSuccessSnackbar('ลบรถยนต์สำเร็จ');
      } catch (e) {
        _showErrorSnackbar('ไม่สามารถลบรถยนต์ได้: $e');
      }
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'จัดการรถยนต์',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
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
            onPressed: _loadVehicles,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: EdgeInsets.all(3.w),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'ค้นหาด้วยยี่ห้อหรือรุ่น...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                    _filterVehicles();
                  },
                ),
                SizedBox(height: 2.h),
                // Filter Chips
                Row(
                  children: [
                    Text(
                      'กรอง:',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: ['ทั้งหมด', 'ว่าง', 'ไม่ว่าง']
                              .map((filter) => Padding(
                                    padding: EdgeInsets.only(right: 2.w),
                                    child: FilterChip(
                                      label: Text(filter),
                                      selected: _selectedFilter == filter,
                                      onSelected: (selected) {
                                        setState(
                                            () => _selectedFilter = filter);
                                        _filterVehicles();
                                      },
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Vehicle List
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredVehicles.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.directions_car_outlined,
                              size: 80,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'ไม่พบรถยนต์',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadVehicles,
                        child: ListView.builder(
                          padding: EdgeInsets.all(3.w),
                          itemCount: _filteredVehicles.length,
                          itemBuilder: (context, index) {
                            final vehicle = _filteredVehicles[index];
                            return VehicleCardWidget(
                              vehicle: vehicle,
                              onEdit: () => _showEditVehicleDialog(vehicle),
                              onDelete: () => _deleteVehicle(vehicle),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddVehicleDialog,
        icon: Icon(Icons.add),
        label: Text('เพิ่มรถยนต์'),
      ),
    );
  }
}
