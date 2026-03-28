import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../theme/dsl_colors.dart';

/// Page 2: Property Dashboard — Main list of all rental properties with status badges
class PropertyDashboardScreen extends StatefulWidget {
  const PropertyDashboardScreen({super.key});

  @override
  State<PropertyDashboardScreen> createState() =>
      _PropertyDashboardScreenState();
}

class _PropertyDashboardScreenState extends State<PropertyDashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'ทั้งหมด';

  final List<String> _filters = ['ทั้งหมด', 'ว่าง', 'ถูกเช่าอยู่', 'บำรุงรักษา'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                  // Brand header
                  _buildBrandHeader(),
                  const SizedBox(height: DslColors.spacingLg),

                  // Search + Filter row
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: GoogleFonts.poppins(
                            color: DslColors.primaryText,
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            hintText: 'ค้นหาทะเบียนรถ หรือ รุ่นรถ...',
                            hintStyle: GoogleFonts.poppins(
                              color: DslColors.hint,
                              fontSize: 14,
                            ),
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              color: DslColors.secondaryText,
                            ),
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
                              borderSide:
                                  const BorderSide(color: DslColors.primary, width: 2),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: DslColors.spacingMd),
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: DslColors.surface,
                          borderRadius:
                              BorderRadius.circular(DslColors.radiusMd),
                          border:
                              Border.all(color: DslColors.divider, width: 1),
                        ),
                        child: const Icon(
                          Icons.tune_rounded,
                          color: DslColors.primaryText,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: DslColors.spacingLg),

                  // Stat cards row
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          label: 'รายได้รวม',
                          value: '฿142.5k',
                          icon: Icons.payments_rounded,
                          iconBg: const Color(0x1AFF2D87),
                          iconColor: DslColors.secondary,
                          valueColor: DslColors.primaryText,
                          trendText: '+8%',
                          trendUp: true,
                        ),
                      ),
                      const SizedBox(width: DslColors.spacingMd),
                      Expanded(
                        child: _StatCard(
                          label: 'อัตราการเช่า',
                          value: '88%',
                          icon: Icons.directions_car_rounded,
                          iconBg: const Color(0x1A0066FF),
                          iconColor: DslColors.primary,
                          valueColor: DslColors.primary,
                          trendText: '+5%',
                          trendUp: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: DslColors.spacingLg),

                  // Section header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'รายการรถทั้งหมด',
                        style: GoogleFonts.urbanist(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: DslColors.primaryText,
                          height: 1.2,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'ดูทั้งหมด',
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: DslColors.primary,
                          ),
                        ),
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
                                  ? DslColors.primary
                                  : DslColors.surface,
                              borderRadius: BorderRadius.circular(
                                  DslColors.radiusFull),
                              border: Border.all(
                                color: selected
                                    ? DslColors.primary
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

                  // Car list
                  _CarCard(
                    name: 'Toyota Camry 2.5V',
                    price: '฿3,200/วัน',
                    transmission: 'เกียร์อัตโนมัติ',
                    seats: '5 ที่นั่ง',
                    fuel: 'เบนซิน',
                    status: 'ว่าง',
                    statusBg: DslColors.success,
                    statusTextColor: DslColors.background,
                    imageUrl:
                        'https://dimg.dreamflow.cloud/v1/image/white+luxury+sedan+toyota+camry',
                    branch: 'สาขากรุงเทพ',
                    branchInit: 'BK',
                  ),
                  const SizedBox(height: DslColors.spacingMd),
                  _CarCard(
                    name: 'BMW X5 M Sport',
                    price: '฿5,900/วัน',
                    transmission: 'เกียร์อัตโนมัติ',
                    seats: '5 ที่นั่ง',
                    fuel: 'ดีเซล',
                    status: 'ถูกเช่าอยู่',
                    statusBg: DslColors.secondary,
                    statusTextColor: Colors.white,
                    imageUrl:
                        'https://dimg.dreamflow.cloud/v1/image/black+luxury+suv+bmw+x5',
                    branch: 'สาขาสุขุมวิท',
                    branchInit: 'SK',
                  ),
                  const SizedBox(height: DslColors.spacingMd),
                  _CarCard(
                    name: 'Mercedes C-Class AMG',
                    price: '฿4,500/วัน',
                    transmission: 'เกียร์อัตโนมัติ',
                    seats: '5 ที่นั่ง',
                    fuel: 'เบนซิน',
                    status: 'ว่าง',
                    statusBg: DslColors.success,
                    statusTextColor: DslColors.background,
                    imageUrl:
                        'https://dimg.dreamflow.cloud/v1/image/silver+mercedes+benz+c+class+luxury+car',
                    branch: 'สาขาเชียงใหม่',
                    branchInit: 'CM',
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),

            // Bottom FAB
            Positioned(
              bottom: DslColors.spacingLg,
              right: DslColors.spacingLg,
              child: FloatingActionButton.extended(
                onPressed: () {},
                backgroundColor: DslColors.primary,
                icon: const Icon(Icons.add_rounded, color: Colors.white),
                label: Text(
                  'เพิ่มรถใหม่',
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

  Widget _buildBrandHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: DslColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: DslColors.secondary, width: 2),
              ),
              child: Center(
                child: Text(
                  'R',
                  style: GoogleFonts.urbanist(
                    fontSize: 18,
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
                  'RENTAL-R',
                  style: GoogleFonts.urbanist(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: DslColors.primaryText,
                  ),
                ),
                Text(
                  'แดชบอร์ดการจัดการ',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: DslColors.secondaryText,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_rounded,
                  color: DslColors.primaryText),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: DslColors.secondary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  'K',
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final Color valueColor;
  final String trendText;
  final bool trendUp;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.valueColor,
    required this.trendText,
    required this.trendUp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DslColors.spacingMd),
      decoration: BoxDecoration(
        color: DslColors.surface,
        borderRadius: BorderRadius.circular(DslColors.radiusMd),
        border: Border.all(color: DslColors.divider, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(DslColors.radiusSm),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: trendUp
                      ? DslColors.success.withAlpha(26)
                      : DslColors.error.withAlpha(26),
                  borderRadius: BorderRadius.circular(DslColors.radiusFull),
                ),
                child: Row(
                  children: [
                    Icon(
                      trendUp
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      color: trendUp ? DslColors.success : DslColors.error,
                      size: 12,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      trendText,
                      style: GoogleFonts.urbanist(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: trendUp ? DslColors.success : DslColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: DslColors.spacingSm),
          Text(
            value,
            style: GoogleFonts.urbanist(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: valueColor,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: DslColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class _CarCard extends StatelessWidget {
  final String name;
  final String price;
  final String transmission;
  final String seats;
  final String fuel;
  final String status;
  final Color statusBg;
  final Color statusTextColor;
  final String imageUrl;
  final String branch;
  final String branchInit;

  const _CarCard({
    required this.name,
    required this.price,
    required this.transmission,
    required this.seats,
    required this.fuel,
    required this.status,
    required this.statusBg,
    required this.statusTextColor,
    required this.imageUrl,
    required this.branch,
    required this.branchInit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: DslColors.surface,
        borderRadius: BorderRadius.circular(DslColors.radiusLg),
        border: Border.all(color: DslColors.divider, width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0x40000000),
            offset: const Offset(0, 8),
            blurRadius: 20,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Car image + status badge
          SizedBox(
            height: 180,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: DslColors.background,
                    child: const Center(
                      child: CircularProgressIndicator(
                          color: DslColors.primary, strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: DslColors.background,
                    child: const Icon(Icons.directions_car,
                        color: DslColors.secondaryText, size: 48),
                  ),
                ),
                Positioned(
                  top: DslColors.spacingMd,
                  right: DslColors.spacingMd,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius:
                          BorderRadius.circular(DslColors.radiusFull),
                    ),
                    child: Text(
                      status,
                      style: GoogleFonts.urbanist(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: statusTextColor,
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Car info
          Padding(
            padding: const EdgeInsets.all(DslColors.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: DslColors.primaryText,
                          height: 1.3,
                        ),
                      ),
                    ),
                    Text(
                      price,
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: DslColors.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: DslColors.spacingSm),
                Row(
                  children: [
                    _CarSpec(
                        icon: Icons.settings_input_component_rounded,
                        label: transmission),
                    const SizedBox(width: DslColors.spacingMd),
                    _CarSpec(icon: Icons.group_rounded, label: seats),
                    const SizedBox(width: DslColors.spacingMd),
                    _CarSpec(
                        icon: Icons.local_gas_station_rounded, label: fuel),
                  ],
                ),
                const Divider(
                    color: DslColors.divider, height: DslColors.spacingMd * 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: DslColors.primary.withAlpha(26),
                            borderRadius:
                                BorderRadius.circular(DslColors.radiusSm),
                          ),
                          child: Center(
                            child: Text(
                              branchInit,
                              style: GoogleFonts.urbanist(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: DslColors.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: DslColors.spacingSm),
                        Text(
                          branch,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: DslColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'ดูรายละเอียด',
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: DslColors.primary,
                        ),
                      ),
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

class _CarSpec extends StatelessWidget {
  final IconData icon;
  final String label;

  const _CarSpec({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: DslColors.secondaryText, size: 16),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: DslColors.secondaryText,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
