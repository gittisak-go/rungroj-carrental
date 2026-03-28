import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/dsl_colors.dart';

/// Page 5: Maintenance Requests — A feed of active repair tickets and their priority levels
class MaintenanceRequestsScreen extends StatefulWidget {
  const MaintenanceRequestsScreen({super.key});

  @override
  State<MaintenanceRequestsScreen> createState() =>
      _MaintenanceRequestsScreenState();
}

class _MaintenanceRequestsScreenState
    extends State<MaintenanceRequestsScreen> {
  String _selectedFilter = 'ทั้งหมด';
  final List<String> _filters = [
    'ทั้งหมด',
    'รอยืนยัน',
    'กำลังดำเนินการ',
    'เสร็จสิ้น'
  ];

  final List<_RequestData> _requests = [
    _RequestData(
      id: 'MR-2026-001',
      carName: 'BMW X5 M Sport',
      plate: 'กข 1234',
      issue: 'เปลี่ยนยาง — ยางหน้าซ้ายรั่ว',
      priority: 'สูง',
      priorityColor: DslColors.error,
      status: 'รอยืนยัน',
      statusBg: DslColors.error,
      submittedBy: 'สมชาย ใจดี',
      date: '28 มี.ค. 2026',
      estimatedCost: '฿2,800',
    ),
    _RequestData(
      id: 'MR-2026-002',
      carName: 'Toyota Camry 2.5V',
      plate: 'กค 5678',
      issue: 'เปลี่ยนน้ำมันเครื่อง + กรองอากาศ',
      priority: 'ปานกลาง',
      priorityColor: DslColors.accent,
      status: 'กำลังดำเนินการ',
      statusBg: DslColors.primary,
      submittedBy: 'วิภา รักสะอาด',
      date: '27 มี.ค. 2026',
      estimatedCost: '฿1,500',
    ),
    _RequestData(
      id: 'MR-2026-003',
      carName: 'Mercedes C-Class AMG',
      plate: 'งง 9012',
      issue: 'ทำความสะอาดภายใน + ดูดฝุ่น',
      priority: 'ต่ำ',
      priorityColor: DslColors.success,
      status: 'กำลังดำเนินการ',
      statusBg: DslColors.primary,
      submittedBy: 'ประเสริฐ มีทรัพย์',
      date: '26 มี.ค. 2026',
      estimatedCost: '฿800',
    ),
    _RequestData(
      id: 'MR-2026-004',
      carName: 'Honda Accord 2.0EL',
      plate: 'จฉ 3456',
      issue: 'ระบบ AC ไม่เย็น — ตรวจสอบน้ำยา',
      priority: 'สูง',
      priorityColor: DslColors.error,
      status: 'รอยืนยัน',
      statusBg: DslColors.error,
      submittedBy: 'อนุชา พรสวรรค์',
      date: '25 มี.ค. 2026',
      estimatedCost: '฿3,200',
    ),
  ];

  List<_RequestData> get _filteredRequests {
    if (_selectedFilter == 'ทั้งหมด') return _requests;
    return _requests.where((r) => r.status == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DslColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(DslColors.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'การซ่อมบำรุง',
                            style: GoogleFonts.urbanist(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: DslColors.primaryText,
                              height: 1.2,
                            ),
                          ),
                          Text(
                            'ติดตามสถานะการซ่อมทุกคัน',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: DslColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.notifications_none_rounded,
                          color: DslColors.primaryText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: DslColors.spacingLg),

                  // Stat tiles
                  Row(
                    children: [
                      Expanded(
                        child: _StatTile(
                          label: 'รอยืนยัน',
                          count: '2',
                          color: DslColors.error,
                          isAlert: true,
                        ),
                      ),
                      const SizedBox(width: DslColors.spacingMd),
                      Expanded(
                        child: _StatTile(
                          label: 'กำลังเช่า',
                          count: '5',
                          color: DslColors.primary,
                          isAlert: false,
                        ),
                      ),
                      const SizedBox(width: DslColors.spacingMd),
                      Expanded(
                        child: _StatTile(
                          label: 'คืนรถแล้ว',
                          count: '14',
                          color: DslColors.success,
                          isAlert: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: DslColors.spacingLg),

                  // Search + filter
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: GoogleFonts.poppins(
                              color: DslColors.primaryText, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'ค้นหาหมายเลขทะเบียนหรือชื่อผู้เช่า...',
                            hintStyle: GoogleFonts.poppins(
                                color: DslColors.hint, fontSize: 13),
                            prefixIcon: const Icon(Icons.search_rounded,
                                color: DslColors.secondaryText),
                            filled: true,
                            fillColor: DslColors.surface,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(DslColors.radiusMd),
                              borderSide:
                                  const BorderSide(color: DslColors.divider),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(DslColors.radiusMd),
                              borderSide:
                                  const BorderSide(color: DslColors.divider),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(DslColors.radiusMd),
                              borderSide: const BorderSide(
                                  color: DslColors.primary, width: 2),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: DslColors.spacingMd),
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: DslColors.surface,
                          borderRadius:
                              BorderRadius.circular(DslColors.radiusMd),
                          border: Border.all(color: DslColors.divider),
                        ),
                        child: const Icon(Icons.tune_rounded,
                            color: DslColors.primaryText),
                      ),
                    ],
                  ),
                  const SizedBox(height: DslColors.spacingMd),

                  // Filter chips
                  SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filters.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: DslColors.spacingSm),
                      itemBuilder: (context, i) {
                        final selected = _filters[i] == _selectedFilter;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedFilter = _filters[i]),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: selected
                                  ? DslColors.secondary
                                  : DslColors.surface,
                              borderRadius: BorderRadius.circular(
                                  DslColors.radiusFull),
                              border: Border.all(
                                color: selected
                                    ? DslColors.secondary
                                    : DslColors.divider,
                              ),
                            ),
                            child: Text(
                              _filters[i],
                              style: GoogleFonts.urbanist(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: selected
                                    ? Colors.white
                                    : DslColors.secondaryText,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: DslColors.spacingLg),

                  // Request list
                  ..._filteredRequests.map(
                    (req) => Padding(
                      padding:
                          const EdgeInsets.only(bottom: DslColors.spacingMd),
                      child: _RequestCard(data: req),
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),

            // FAB
            Positioned(
              bottom: DslColors.spacingLg,
              right: DslColors.spacingLg,
              child: FloatingActionButton.extended(
                onPressed: () {},
                backgroundColor: DslColors.secondary,
                icon: const Icon(Icons.add_rounded, color: Colors.white),
                label: Text(
                  'แจ้งซ่อม',
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String count;
  final Color color;
  final bool isAlert;

  const _StatTile({
    required this.label,
    required this.count,
    required this.color,
    required this.isAlert,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DslColors.spacingMd),
      decoration: BoxDecoration(
        color: DslColors.surface,
        borderRadius: BorderRadius.circular(DslColors.radiusMd),
        border: Border.all(
          color: isAlert ? color.withAlpha(100) : DslColors.divider,
          width: isAlert ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          if (isAlert)
            Icon(Icons.warning_amber_rounded, color: color, size: 20),
          if (isAlert) const SizedBox(height: 4),
          Text(
            count,
            style: GoogleFonts.urbanist(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: color,
              height: 1.2,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: DslColors.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _RequestData {
  final String id;
  final String carName;
  final String plate;
  final String issue;
  final String priority;
  final Color priorityColor;
  final String status;
  final Color statusBg;
  final String submittedBy;
  final String date;
  final String estimatedCost;

  const _RequestData({
    required this.id,
    required this.carName,
    required this.plate,
    required this.issue,
    required this.priority,
    required this.priorityColor,
    required this.status,
    required this.statusBg,
    required this.submittedBy,
    required this.date,
    required this.estimatedCost,
  });
}

class _RequestCard extends StatelessWidget {
  final _RequestData data;

  const _RequestCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: DslColors.surface,
        borderRadius: BorderRadius.circular(DslColors.radiusMd),
        border: Border.all(color: DslColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Priority indicator bar
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: data.priorityColor,
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(DslColors.radiusMd)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(DslColors.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data.id,
                      style: GoogleFonts.urbanist(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: DslColors.secondaryText,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: data.priorityColor.withAlpha(26),
                            borderRadius: BorderRadius.circular(
                                DslColors.radiusFull),
                          ),
                          child: Text(
                            'ความเร่งด่วน: ${data.priority}',
                            style: GoogleFonts.urbanist(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: data.priorityColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: DslColors.spacingXs),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: data.statusBg.withAlpha(26),
                            borderRadius: BorderRadius.circular(
                                DslColors.radiusFull),
                          ),
                          child: Text(
                            data.status,
                            style: GoogleFonts.urbanist(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: data.statusBg,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: DslColors.spacingSm),
                Text(
                  data.issue,
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: DslColors.primaryText,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: DslColors.spacingXs),
                Row(
                  children: [
                    const Icon(Icons.directions_car_rounded,
                        color: DslColors.secondaryText, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${data.carName} (${data.plate})',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: DslColors.secondaryText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: DslColors.spacingMd),
                const Divider(color: DslColors.divider, height: 1),
                const SizedBox(height: DslColors.spacingMd),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person_outline_rounded,
                            color: DslColors.secondaryText, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          data.submittedBy,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: DslColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          data.date,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: DslColors.hint,
                          ),
                        ),
                        const SizedBox(width: DslColors.spacingMd),
                        Text(
                          data.estimatedCost,
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: DslColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
