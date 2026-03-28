import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/dsl_colors.dart';

/// Page 10: New Screen 1 — Car Rental Home/Search Screen
class NewScreen1Screen extends StatefulWidget {
  const NewScreen1Screen({super.key});

  @override
  State<NewScreen1Screen> createState() => _NewScreen1ScreenState();
}

class _NewScreen1ScreenState extends State<NewScreen1Screen> {
  final _pickupController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  @override
  void dispose() {
    _pickupController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DslColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: DslColors.secondary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'จองรถใหม่',
          style: GoogleFonts.urbanist(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Brand header
              Container(
                padding: const EdgeInsets.all(DslColors.spacingLg),
                color: DslColors.surface,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: DslColors.background,
                            shape: BoxShape.circle,
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
                        Text(
                          'RENTAL-R',
                          style: GoogleFonts.urbanist(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: DslColors.primaryText,
                          ),
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
                          decoration: const BoxDecoration(
                            color: DslColors.secondary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              'ก',
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
                  ],
                ),
              ),

              // Search card
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: DslColors.spacingLg,
                  vertical: DslColors.spacingLg,
                ),
                child: Container(
                  padding: const EdgeInsets.all(DslColors.spacingMd),
                  decoration: BoxDecoration(
                    color: DslColors.surface,
                    borderRadius: BorderRadius.circular(DslColors.radiusLg),
                    border: Border.all(color: DslColors.divider),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x40000000),
                        offset: const Offset(0, 8),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Pickup location
                      _SearchTextField(
                        label: 'สถานที่รับรถ',
                        hint: 'เลือกจุดรับรถ...',
                        icon: Icons.location_on_rounded,
                        controller: _pickupController,
                      ),
                      const SizedBox(height: DslColors.spacingMd),
                      // Date row
                      Row(
                        children: [
                          Expanded(
                            child: _SearchTextField(
                              label: 'วันที่รับ',
                              hint: '24 ต.ค.',
                              icon: Icons.calendar_today_rounded,
                              controller: _startDateController,
                            ),
                          ),
                          const SizedBox(width: DslColors.spacingMd),
                          Expanded(
                            child: _SearchTextField(
                              label: 'วันที่คืน',
                              hint: '26 ต.ค.',
                              icon: Icons.event_available_rounded,
                              controller: _endDateController,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: DslColors.spacingMd),
                      // Search button
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.search_rounded, size: 18),
                        label: Text(
                          'ค้นหารถว่าง',
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DslColors.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 52),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(DslColors.radiusLg),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Overview stats
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: DslColors.spacingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ภาพรวมการใช้งาน',
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: DslColors.primaryText,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: DslColors.spacingMd),
                    Row(
                      children: [
                        Expanded(
                          child: _MiniStatCard(
                            label: 'จองแล้ว',
                            count: '12',
                            bg: const Color(0xFFFDF2F8),
                            border: const Color(0xFFFCE7F3),
                            textColor: DslColors.secondary,
                          ),
                        ),
                        const SizedBox(width: DslColors.spacingMd),
                        Expanded(
                          child: _MiniStatCard(
                            label: 'รถว่าง',
                            count: '45',
                            bg: const Color(0xFFF0FDF4),
                            border: const Color(0xFFDCFCE7),
                            textColor: DslColors.success,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: DslColors.spacingLg),

              // Quick actions
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: DslColors.spacingLg),
                child: Row(
                  children: [
                    Expanded(
                      child: _QuickAction(
                        icon: Icons.directions_car_filled_rounded,
                        label: 'รถของฉัน',
                        bg: const Color(0xFFEBF5FF),
                        color: DslColors.primary,
                      ),
                    ),
                    const SizedBox(width: DslColors.spacingMd),
                    Expanded(
                      child: _QuickAction(
                        icon: Icons.history_rounded,
                        label: 'ประวัติการเช่า',
                        bg: const Color(0xFFFDF2F8),
                        color: DslColors.secondary,
                      ),
                    ),
                    const SizedBox(width: DslColors.spacingMd),
                    Expanded(
                      child: _QuickAction(
                        icon: Icons.support_agent_rounded,
                        label: 'ความช่วยเหลือ',
                        bg: const Color(0xFFF0FDF4),
                        color: DslColors.success,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: DslColors.spacingLg),

              // Recommended cars
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: DslColors.spacingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'รถแนะนำยอดนิยม',
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: DslColors.primaryText,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'ดูทั้งหมด',
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: DslColors.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: DslColors.spacingMd),
                    _PopularCarCard(
                      model: 'BMW Series 5',
                      brand: 'Luxury Sedan • 2024',
                      price: '4,500',
                      providerName: 'R Premium Rental',
                      status: 'พร้อมใช้งาน',
                      imageUrl:
                          'https://dimg.dreamflow.cloud/v1/image/bmw+5+series+luxury+sedan+silver+studio',
                    ),
                    const SizedBox(height: DslColors.spacingMd),
                    _PopularCarCard(
                      model: 'Tesla Model Y',
                      brand: 'EV • 2023',
                      price: '3,800',
                      providerName: 'R Electric',
                      status: 'พร้อมใช้งาน',
                      imageUrl:
                          'https://dimg.dreamflow.cloud/v1/image/tesla+model+y+white+electric+car+studio',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: DslColors.spacingLg),

              // Current booking
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: DslColors.spacingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'รายการจองปัจจุบัน',
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: DslColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: DslColors.spacingMd),
                    _BookingTicket(),
                  ],
                ),
              ),
              const SizedBox(height: DslColors.spacingLg),

              // Weekly stats chart
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: DslColors.spacingLg),
                child: Container(
                  padding: const EdgeInsets.all(DslColors.spacingLg),
                  decoration: BoxDecoration(
                    color: DslColors.surface,
                    borderRadius: BorderRadius.circular(DslColors.radiusLg),
                    border: Border.all(color: DslColors.divider),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'สถิติการเช่ารายสัปดาห์',
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: DslColors.primaryText,
                        ),
                      ),
                      const SizedBox(height: DslColors.spacingMd),
                      SizedBox(
                        height: 180,
                        child: LineChart(
                          LineChartData(
                            backgroundColor: Colors.transparent,
                            borderData: FlBorderData(show: false),
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              getDrawingHorizontalLine: (value) => FlLine(
                                color: DslColors.divider,
                                strokeWidth: 1,
                              ),
                            ),
                            titlesData: FlTitlesData(
                              leftTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    const days = [
                                      'จ',
                                      'อ',
                                      'พ',
                                      'พฤ',
                                      'ศ',
                                      'ส',
                                      'อา'
                                    ];
                                    final idx = value.toInt();
                                    if (idx >= 0 && idx < days.length) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 4),
                                        child: Text(
                                          days[idx],
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            color: DslColors.secondaryText,
                                          ),
                                        ),
                                      );
                                    }
                                    return const SizedBox();
                                  },
                                ),
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: const [
                                  FlSpot(0, 20),
                                  FlSpot(1, 45),
                                  FlSpot(2, 30),
                                  FlSpot(3, 60),
                                  FlSpot(4, 55),
                                  FlSpot(5, 80),
                                  FlSpot(6, 70),
                                ],
                                isCurved: true,
                                color: DslColors.secondary,
                                barWidth: 3,
                                dotData: const FlDotData(show: false),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color:
                                      DslColors.secondary.withAlpha(26),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: DslColors.spacingLg),

              // Footer
              Padding(
                padding: const EdgeInsets.all(DslColors.spacingXl),
                child: Column(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A0A0F),
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: DslColors.secondary, width: 1),
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
                    const SizedBox(height: DslColors.spacingSm),
                    Text(
                      '© 2024 R Rental Thailand. All Rights Reserved.',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: DslColors.hint,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;

  const _SearchTextField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: DslColors.secondaryText,
          ),
        ),
        const SizedBox(height: DslColors.spacingXs),
        TextField(
          controller: controller,
          style: GoogleFonts.poppins(
              color: DslColors.primaryText, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                GoogleFonts.poppins(color: DslColors.hint, fontSize: 14),
            prefixIcon: Icon(icon, color: DslColors.secondaryText, size: 18),
            filled: true,
            fillColor: DslColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DslColors.radiusMd),
              borderSide: const BorderSide(color: DslColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DslColors.radiusMd),
              borderSide: const BorderSide(color: DslColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DslColors.radiusMd),
              borderSide:
                  const BorderSide(color: DslColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  final String label;
  final String count;
  final Color bg;
  final Color border;
  final Color textColor;

  const _MiniStatCard({
    required this.label,
    required this.count,
    required this.bg,
    required this.border,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DslColors.spacingMd),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(DslColors.radiusMd),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: GoogleFonts.urbanist(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: textColor,
              height: 1.2,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: textColor.withAlpha(180),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bg;
  final Color color;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.bg,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: DslColors.spacingMd),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(DslColors.radiusMd),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: DslColors.spacingXs),
            Text(
              label,
              style: GoogleFonts.urbanist(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _PopularCarCard extends StatelessWidget {
  final String model;
  final String brand;
  final String price;
  final String providerName;
  final String status;
  final String imageUrl;

  const _PopularCarCard({
    required this.model,
    required this.brand,
    required this.price,
    required this.providerName,
    required this.status,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: DslColors.surface,
        borderRadius: BorderRadius.circular(DslColors.radiusMd),
        border: Border.all(color: DslColors.divider),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          // Car image
          SizedBox(
            width: 100,
            height: 90,
            child: CachedNetworkImage(
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
                    color: DslColors.secondaryText, size: 36),
              ),
            ),
          ),
          // Car info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(DslColors.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        model,
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: DslColors.primaryText,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: DslColors.success.withAlpha(26),
                          borderRadius:
                              BorderRadius.circular(DslColors.radiusFull),
                        ),
                        child: Text(
                          status,
                          style: GoogleFonts.urbanist(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: DslColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    brand,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: DslColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: DslColors.spacingXs),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        providerName,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: DslColors.hint,
                        ),
                      ),
                      Text(
                        '฿$price/วัน',
                        style: GoogleFonts.urbanist(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: DslColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingTicket extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DslColors.spacingMd),
      decoration: BoxDecoration(
        color: DslColors.surface,
        borderRadius: BorderRadius.circular(DslColors.radiusMd),
        border: Border.all(color: DslColors.primary.withAlpha(80)),
        gradient: LinearGradient(
          colors: [
            DslColors.primary.withAlpha(10),
            DslColors.surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Porsche Taycan • กข 9999',
                style: GoogleFonts.urbanist(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: DslColors.primaryText,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: DslColors.success.withAlpha(26),
                  borderRadius:
                      BorderRadius.circular(DslColors.radiusFull),
                ),
                child: Text(
                  'ยืนยันแล้ว',
                  style: GoogleFonts.urbanist(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: DslColors.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: DslColors.spacingSm),
          Row(
            children: [
              const Icon(Icons.location_on_rounded,
                  color: DslColors.secondaryText, size: 14),
              const SizedBox(width: 4),
              Text(
                'จุดรับรถ: สยามพารากอน',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: DslColors.secondaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: DslColors.spacingXs),
          Row(
            children: [
              const Icon(Icons.person_outline_rounded,
                  color: DslColors.secondaryText, size: 14),
              const SizedBox(width: 4),
              Text(
                'วิรุฬห์ สุขสวัสดิ์',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: DslColors.secondaryText,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: DslColors.primary.withAlpha(26),
                  borderRadius:
                      BorderRadius.circular(DslColors.radiusFull),
                ),
                child: Text(
                  'กำลังดำเนินการ',
                  style: GoogleFonts.urbanist(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: DslColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
