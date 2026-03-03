import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import './widgets/driver_card_widget.dart';
import './widgets/driver_details_modal.dart';
import './widgets/driver_filter_sheet.dart';

class DriverManagementScreen extends StatefulWidget {
  const DriverManagementScreen({Key? key}) : super(key: key);

  @override
  State<DriverManagementScreen> createState() => _DriverManagementScreenState();
}

class _DriverManagementScreenState extends State<DriverManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'all';
  String _selectedSort = 'name';
  bool _isLoading = false;
  Set<String> _selectedDriverIds = {};

  // Mock data - will be replaced with actual Supabase data
  final List<Map<String, dynamic>> _drivers = [
    {
      'id': '1',
      'name': 'สมชาย ใจดี',
      'photo':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
      'status': 'online',
      'vehicle': 'Toyota Camry - 1ABC2345',
      'rating': 4.8,
      'totalTrips': 1248,
      'dailyEarnings': 3250.00,
      'license': {'status': 'verified', 'expiry': '2025-12-31'},
      'insurance': {'status': 'verified', 'expiry': '2025-06-30'},
      'backgroundCheck': {'status': 'verified', 'date': '2024-01-15'},
      'performance': {
        'completionRate': 98.5,
        'avgResponseTime': '2.5 นาที',
        'customerRating': 4.8
      }
    },
    {
      'id': '2',
      'name': 'วิชัย รักษ์ดี',
      'photo':
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400',
      'status': 'busy',
      'vehicle': 'Honda Accord - 2XYZ5678',
      'rating': 4.9,
      'totalTrips': 2156,
      'dailyEarnings': 4120.00,
      'license': {'status': 'verified', 'expiry': '2026-03-15'},
      'insurance': {'status': 'verified', 'expiry': '2025-09-20'},
      'backgroundCheck': {'status': 'verified', 'date': '2024-02-10'},
      'performance': {
        'completionRate': 99.2,
        'avgResponseTime': '1.8 นาที',
        'customerRating': 4.9
      }
    },
    {
      'id': '3',
      'name': 'สุรชัย มีสุข',
      'photo':
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400',
      'status': 'offline',
      'vehicle': 'Nissan Teana - 3DEF9012',
      'rating': 4.7,
      'totalTrips': 892,
      'dailyEarnings': 0.00,
      'license': {'status': 'expired', 'expiry': '2024-11-30'},
      'insurance': {'status': 'verified', 'expiry': '2025-08-15'},
      'backgroundCheck': {'status': 'verified', 'date': '2023-12-05'},
      'performance': {
        'completionRate': 95.3,
        'avgResponseTime': '3.2 นาที',
        'customerRating': 4.7
      }
    },
    {
      'id': '4',
      'name': 'ประเสริฐ สวัสดี',
      'photo':
          'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=400',
      'status': 'online',
      'vehicle': 'Mazda 6 - 4GHI3456',
      'rating': 4.6,
      'totalTrips': 654,
      'dailyEarnings': 2890.00,
      'license': {'status': 'verified', 'expiry': '2025-10-20'},
      'insurance': {'status': 'pending', 'expiry': '2025-01-10'},
      'backgroundCheck': {'status': 'verified', 'date': '2024-03-20'},
      'performance': {
        'completionRate': 97.1,
        'avgResponseTime': '2.8 นาที',
        'customerRating': 4.6
      }
    },
    {
      'id': '5',
      'name': 'บุญชู เจริญ',
      'photo':
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
      'status': 'busy',
      'vehicle': 'BMW 320i - 5JKL7890',
      'rating': 4.9,
      'totalTrips': 1876,
      'dailyEarnings': 5240.00,
      'license': {'status': 'verified', 'expiry': '2026-05-15'},
      'insurance': {'status': 'verified', 'expiry': '2025-12-30'},
      'backgroundCheck': {'status': 'verified', 'date': '2024-01-05'},
      'performance': {
        'completionRate': 99.5,
        'avgResponseTime': '1.5 นาที',
        'customerRating': 4.9
      }
    },
    {
      'id': '6',
      'name': 'อนุชา พัฒนา',
      'photo':
          'https://images.unsplash.com/photo-1504257432389-52343af06ae3?w=400',
      'status': 'offline',
      'vehicle': 'Chevrolet Cruze - 6MNO2345',
      'rating': 4.5,
      'totalTrips': 423,
      'dailyEarnings': 0.00,
      'license': {'status': 'verified', 'expiry': '2025-07-25'},
      'insurance': {'status': 'verified', 'expiry': '2025-04-18'},
      'backgroundCheck': {'status': 'pending', 'date': '2024-11-30'},
      'performance': {
        'completionRate': 94.8,
        'avgResponseTime': '3.5 นาที',
        'customerRating': 4.5
      }
    }
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredDrivers {
    List<Map<String, dynamic>> filtered = _drivers;

    // Search filter
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((driver) {
        return driver['name']
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            driver['vehicle']
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());
      }).toList();
    }

    // Status filter
    if (_selectedFilter != 'all') {
      filtered = filtered
          .where((driver) => driver['status'] == _selectedFilter)
          .toList();
    }

    // Sorting
    switch (_selectedSort) {
      case 'name':
        filtered.sort((a, b) => a['name'].compareTo(b['name']));
        break;
      case 'rating':
        filtered.sort((a, b) => b['rating'].compareTo(a['rating']));
        break;
      case 'earnings':
        filtered
            .sort((a, b) => b['dailyEarnings'].compareTo(a['dailyEarnings']));
        break;
      case 'trips':
        filtered.sort((a, b) => b['totalTrips'].compareTo(a['totalTrips']));
        break;
    }

    return filtered;
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DriverFilterSheet(
        selectedFilter: _selectedFilter,
        selectedSort: _selectedSort,
        onApply: (filter, sort) {
          setState(() {
            _selectedFilter = filter;
            _selectedSort = sort;
          });
        },
      ),
    );
  }

  void _showDriverDetails(Map<String, dynamic> driver) {
    showDialog(
      context: context,
      builder: (context) => DriverDetailsModal(
        driver: driver,
        onAction: (action) {
          _handleDriverAction(driver, action);
        },
      ),
    );
  }

  void _handleDriverAction(Map<String, dynamic> driver, String action) {
    switch (action) {
      case 'message':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('กำลังเปิดแชทกับ ${driver['name']}')),
        );
        break;
      case 'reassign':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('กำลังเปิดหน้าจัดสรรรถใหม่')),
        );
        break;
      case 'suspend':
        _showConfirmDialog(
          'ระงับบัญชี',
          'คุณต้องการระงับบัญชีของ ${driver['name']} หรือไม่?',
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('ระงับบัญชี ${driver['name']} สำเร็จ')),
            );
          },
        );
        break;
      case 'earnings':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('กำลังเปิดหน้าปรับยอดรายได้ของ ${driver['name']}')),
        );
        break;
    }
  }

  void _showConfirmDialog(
      String title, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('ยืนยัน'),
          ),
        ],
      ),
    );
  }

  void _handleBulkAction(String action) {
    if (_selectedDriverIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาเลือกคนขับอย่างน้อย 1 คน')),
      );
      return;
    }

    switch (action) {
      case 'message':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'กำลังส่งข้อความถึง ${_selectedDriverIds.length} คนขับ')),
        );
        break;
      case 'export':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('กำลังส่งออกข้อมูล ${_selectedDriverIds.length} คนขับ')),
        );
        break;
    }

    setState(() {
      _selectedDriverIds.clear();
    });
  }

  void _exportAllDrivers() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('กำลังส่งออกรายงานคนขับทั้งหมด')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('จัดการคนขับ'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
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
            icon: const Icon(Icons.file_download_outlined),
            onPressed: _exportAllDrivers,
            tooltip: 'ส่งออกรายงาน',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Header
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(2.w),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'ค้นหาคนขับหรือรถ...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                    });
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 1.5.h),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.filter_list, color: Colors.blue),
                        onPressed: _showFilterSheet,
                        tooltip: 'กรอง/เรียงลำดับ',
                      ),
                    ),
                  ],
                ),
                if (_selectedDriverIds.isNotEmpty) ...[
                  SizedBox(height: 1.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'เลือก ${_selectedDriverIds.length} คน',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue[800],
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () => _handleBulkAction('message'),
                          icon: const Icon(Icons.message, size: 18),
                          label: const Text('ส่งข้อความ'),
                        ),
                        TextButton.icon(
                          onPressed: () => _handleBulkAction('export'),
                          icon: const Icon(Icons.download, size: 18),
                          label: const Text('ส่งออก'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              _selectedDriverIds.clear();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Statistics Bar
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                    'ออนไลน์',
                    _drivers
                        .where((d) => d['status'] == 'online')
                        .length
                        .toString(),
                    Colors.green),
                _buildStatItem(
                    'กำลังทำงาน',
                    _drivers
                        .where((d) => d['status'] == 'busy')
                        .length
                        .toString(),
                    Colors.orange),
                _buildStatItem(
                    'ออฟไลน์',
                    _drivers
                        .where((d) => d['status'] == 'offline')
                        .length
                        .toString(),
                    Colors.grey),
                _buildStatItem(
                    'ทั้งหมด', _drivers.length.toString(), Colors.blue),
              ],
            ),
          ),

          // Drivers Grid
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredDrivers.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off,
                                size: 80, color: Colors.grey[400]),
                            SizedBox(height: 2.h),
                            Text(
                              'ไม่พบคนขับที่ค้นหา',
                              style: TextStyle(
                                  fontSize: 16.sp, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: EdgeInsets.all(2.w),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 2.w,
                          mainAxisSpacing: 2.w,
                        ),
                        itemCount: _filteredDrivers.length,
                        itemBuilder: (context, index) {
                          final driver = _filteredDrivers[index];
                          final isSelected =
                              _selectedDriverIds.contains(driver['id']);

                          return DriverCardWidget(
                            driver: driver,
                            isSelected: isSelected,
                            onTap: () => _showDriverDetails(driver),
                            onLongPress: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedDriverIds.remove(driver['id']);
                                } else {
                                  _selectedDriverIds.add(driver['id']);
                                }
                              });
                            },
                            onSelectionChanged: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedDriverIds.add(driver['id']);
                                } else {
                                  _selectedDriverIds.remove(driver['id']);
                                }
                              });
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
