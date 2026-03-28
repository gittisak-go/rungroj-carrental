import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/dsl_colors.dart';

/// Page 4: Tenant Directory — A searchable list of all current and past tenants
class TenantDirectoryScreen extends StatefulWidget {
  const TenantDirectoryScreen({super.key});

  @override
  State<TenantDirectoryScreen> createState() => _TenantDirectoryScreenState();
}

class _TenantDirectoryScreenState extends State<TenantDirectoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  final List<_TenantData> _activeTenants = [
    _TenantData(
      name: 'สมชาย ใจดี',
      initials: 'ส',
      initBg: DslColors.secondary,
      phone: '+66 81-234-5678',
      carName: 'Toyota Camry 2.5V',
      status: 'กำลังเช่า',
      statusBg: DslColors.success,
      startDate: '15 มี.ค. 2026',
      endDate: '22 มี.ค. 2026',
      totalAmount: '฿22,400',
    ),
    _TenantData(
      name: 'วิภา รักสะอาด',
      initials: 'ว',
      initBg: DslColors.primary,
      phone: '+66 89-456-7890',
      carName: 'BMW X5 M Sport',
      status: 'กำลังเช่า',
      statusBg: DslColors.success,
      startDate: '10 มี.ค. 2026',
      endDate: '17 มี.ค. 2026',
      totalAmount: '฿41,300',
    ),
    _TenantData(
      name: 'ประเสริฐ มีทรัพย์',
      initials: 'ป',
      initBg: DslColors.accent,
      phone: '+66 62-789-0123',
      carName: 'Mercedes C-Class',
      status: 'กำลังเช่า',
      statusBg: DslColors.success,
      startDate: '18 มี.ค. 2026',
      endDate: '25 มี.ค. 2026',
      totalAmount: '฿31,500',
    ),
  ];

  final List<_TenantData> _pastTenants = [
    _TenantData(
      name: 'อนุชา พรสวรรค์',
      initials: 'อ',
      initBg: const Color(0xFF636366),
      phone: '+66 83-321-0987',
      carName: 'Honda Accord 2.0EL',
      status: 'เสร็จสิ้น',
      statusBg: DslColors.secondaryText,
      startDate: '1 มี.ค. 2026',
      endDate: '8 มี.ค. 2026',
      totalAmount: '฿17,500',
    ),
    _TenantData(
      name: 'จันทร์ศรี สดใส',
      initials: 'จ',
      initBg: const Color(0xFF636366),
      phone: '+66 91-234-5678',
      carName: 'Toyota Fortuner 2.8',
      status: 'เสร็จสิ้น',
      statusBg: DslColors.secondaryText,
      startDate: '5 มี.ค. 2026',
      endDate: '10 มี.ค. 2026',
      totalAmount: '฿19,500',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DslColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(
                DslColors.spacingLg,
                DslColors.spacingLg,
                DslColors.spacingLg,
                DslColors.spacingMd,
              ),
              color: DslColors.background,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: DslColors.surface,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: DslColors.secondary, width: 2),
                            ),
                            child: Center(
                              child: Text(
                                'R',
                                style: GoogleFonts.urbanist(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: DslColors.secondary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: DslColors.spacingMd),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'RENTAL PREMIUM',
                                style: GoogleFonts.urbanist(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: DslColors.secondary,
                                  letterSpacing: 1,
                                ),
                              ),
                              Text(
                                'เลือกสิ่งที่ดีที่สุดให้คุณ',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: DslColors.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: DslColors.surface,
                          borderRadius:
                              BorderRadius.circular(DslColors.radiusMd),
                          border: Border.all(color: DslColors.divider),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.notifications_none_rounded,
                            color: DslColors.primaryText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: DslColors.spacingLg),

                  // Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'ทะเบียนผู้เช่า',
                        style: GoogleFonts.urbanist(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: DslColors.primaryText,
                          height: 1.2,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: DslColors.primary.withAlpha(26),
                          borderRadius:
                              BorderRadius.circular(DslColors.radiusFull),
                        ),
                        child: Text(
                          '${_activeTenants.length + _pastTenants.length} คน',
                          style: GoogleFonts.urbanist(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: DslColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: DslColors.spacingMd),

                  // Search bar
                  TextField(
                    controller: _searchController,
                    style: GoogleFonts.poppins(
                        color: DslColors.primaryText, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'ค้นหาชื่อผู้เช่า หรือ เบอร์โทร...',
                      hintStyle: GoogleFonts.poppins(
                          color: DslColors.hint, fontSize: 14),
                      prefixIcon: const Icon(Icons.search_rounded,
                          color: DslColors.secondaryText),
                      suffixIcon: const Icon(Icons.tune_rounded,
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
                  const SizedBox(height: DslColors.spacingMd),

                  // Tabs
                  Container(
                    decoration: BoxDecoration(
                      color: DslColors.surface,
                      borderRadius:
                          BorderRadius.circular(DslColors.radiusMd),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      labelStyle: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      unselectedLabelStyle: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      labelColor: DslColors.primary,
                      unselectedLabelColor: DslColors.secondaryText,
                      indicator: BoxDecoration(
                        color: DslColors.primary.withAlpha(26),
                        borderRadius:
                            BorderRadius.circular(DslColors.radiusMd),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      tabs: [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('กำลังเช่า'),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: DslColors.success,
                                  borderRadius: BorderRadius.circular(
                                      DslColors.radiusFull),
                                ),
                                child: Text(
                                  '${_activeTenants.length}',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: DslColors.background,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('ประวัติ'),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: DslColors.secondaryText,
                                  borderRadius: BorderRadius.circular(
                                      DslColors.radiusFull),
                                ),
                                child: Text(
                                  '${_pastTenants.length}',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _TenantList(tenants: _activeTenants),
                  _TenantList(tenants: _pastTenants),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: DslColors.secondary,
        child: const Icon(Icons.person_add_rounded, color: Colors.white),
      ),
    );
  }
}

class _TenantList extends StatelessWidget {
  final List<_TenantData> tenants;

  const _TenantList({required this.tenants});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(DslColors.spacingLg),
      itemCount: tenants.length,
      separatorBuilder: (_, __) =>
          const SizedBox(height: DslColors.spacingMd),
      itemBuilder: (context, i) => _TenantCard(data: tenants[i]),
    );
  }
}

class _TenantData {
  final String name;
  final String initials;
  final Color initBg;
  final String phone;
  final String carName;
  final String status;
  final Color statusBg;
  final String startDate;
  final String endDate;
  final String totalAmount;

  const _TenantData({
    required this.name,
    required this.initials,
    required this.initBg,
    required this.phone,
    required this.carName,
    required this.status,
    required this.statusBg,
    required this.startDate,
    required this.endDate,
    required this.totalAmount,
  });
}

class _TenantCard extends StatelessWidget {
  final _TenantData data;

  const _TenantCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DslColors.spacingMd),
      decoration: BoxDecoration(
        color: DslColors.surface,
        borderRadius: BorderRadius.circular(DslColors.radiusMd),
        border: Border.all(color: DslColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tenant header
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: data.initBg,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    data.initials,
                    style: GoogleFonts.urbanist(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: DslColors.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name,
                      style: GoogleFonts.urbanist(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: DslColors.primaryText,
                      ),
                    ),
                    Text(
                      data.phone,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: DslColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: data.statusBg.withAlpha(26),
                  borderRadius: BorderRadius.circular(DslColors.radiusFull),
                  border: Border.all(color: data.statusBg.withAlpha(80)),
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
          const Divider(color: DslColors.divider, height: DslColors.spacingLg),
          // Car + dates
          Row(
            children: [
              const Icon(Icons.directions_car_rounded,
                  color: DslColors.secondaryText, size: 16),
              const SizedBox(width: 6),
              Text(
                data.carName,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: DslColors.primaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: DslColors.spacingSm),
          Row(
            children: [
              const Icon(Icons.calendar_today_rounded,
                  color: DslColors.secondaryText, size: 14),
              const SizedBox(width: 6),
              Text(
                '${data.startDate} – ${data.endDate}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: DslColors.secondaryText,
                ),
              ),
              const Spacer(),
              Text(
                data.totalAmount,
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
    );
  }
}
