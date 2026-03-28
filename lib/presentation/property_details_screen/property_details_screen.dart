import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../theme/dsl_colors.dart';

/// Page 3: Property Details — Detailed view of a specific unit including tenant info and lease dates
class PropertyDetailsScreen extends StatelessWidget {
  const PropertyDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DslColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero image stack (300px)
              SizedBox(
                height: 300,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl:
                          'https://dimg.dreamflow.cloud/v1/image/luxury+white+sedan+car+parked+in+modern+showroom+with+glass+windows',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                          color: DslColors.surface,
                          child: const Center(
                              child: CircularProgressIndicator(
                                  color: DslColors.primary))),
                      errorWidget: (context, url, error) => Container(
                        color: DslColors.surface,
                        child: const Icon(Icons.directions_car,
                            color: DslColors.secondaryText, size: 64),
                      ),
                    ),
                    // Gradient
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Color(0xEE000000), Colors.transparent],
                        ),
                      ),
                    ),
                    // Top bar: back + actions
                    Positioned(
                      top: DslColors.spacingLg,
                      left: DslColors.spacingMd,
                      right: DslColors.spacingMd,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _GlassIconButton(
                            icon: Icons.arrow_back_ios_new_rounded,
                            onTap: () => Navigator.maybePop(context),
                          ),
                          Row(
                            children: [
                              _GlassIconButton(
                                icon: Icons.favorite_border_rounded,
                                onTap: () {},
                              ),
                              const SizedBox(width: DslColors.spacingSm),
                              _GlassIconButton(
                                icon: Icons.share_rounded,
                                onTap: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Bottom overlay: name + price
                    Positioned(
                      bottom: DslColors.spacingLg,
                      left: DslColors.spacingMd,
                      right: DslColors.spacingMd,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image indicators
                          Row(
                            children: List.generate(
                              3,
                              (i) => Container(
                                width: i == 0 ? 24 : 8,
                                height: 8,
                                margin: const EdgeInsets.only(right: 4),
                                decoration: BoxDecoration(
                                  color: i == 0
                                      ? DslColors.secondary
                                      : Colors.white.withAlpha(100),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: DslColors.spacingSm),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Toyota Camry 2.5V',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on_rounded,
                                          color: DslColors.secondary, size: 14),
                                      const SizedBox(width: 4),
                                      Text(
                                        'สาขากรุงเทพ',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: DslColors.secondaryText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '฿3,200',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: DslColors.secondary,
                                    ),
                                  ),
                                  Text(
                                    'ต่อวัน',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: DslColors.secondaryText,
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
              ),

              Padding(
                padding: const EdgeInsets.all(DslColors.spacingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Rating + availability row
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: DslColors.surface,
                            borderRadius:
                                BorderRadius.circular(DslColors.radiusFull),
                            border: Border.all(color: DslColors.divider),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star_rounded,
                                  color: DslColors.accent, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '4.9',
                                style: GoogleFonts.urbanist(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: DslColors.primaryText,
                                ),
                              ),
                              Text(
                                ' (128 รีวิว)',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: DslColors.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: DslColors.spacingSm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: DslColors.success.withAlpha(26),
                            borderRadius:
                                BorderRadius.circular(DslColors.radiusFull),
                            border: Border.all(
                                color: DslColors.success.withAlpha(80)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: DslColors.success,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'ว่าง',
                                style: GoogleFonts.urbanist(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: DslColors.success,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: DslColors.spacingLg),

                    // Spec grid
                    Container(
                      padding: const EdgeInsets.all(DslColors.spacingMd),
                      decoration: BoxDecoration(
                        color: DslColors.surface,
                        borderRadius: BorderRadius.circular(DslColors.radiusMd),
                        border: Border.all(color: DslColors.divider),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          _SpecItem(
                              icon: Icons.settings_input_component_rounded,
                              label: 'เกียร์',
                              value: 'อัตโนมัติ'),
                          _SpecItem(
                              icon: Icons.group_rounded,
                              label: 'ที่นั่ง',
                              value: '5 คน'),
                          _SpecItem(
                              icon: Icons.local_gas_station_rounded,
                              label: 'เชื้อเพลิง',
                              value: 'เบนซิน'),
                          _SpecItem(
                              icon: Icons.speed_rounded,
                              label: 'เครื่อง',
                              value: '2.5L'),
                        ],
                      ),
                    ),
                    const SizedBox(height: DslColors.spacingLg),

                    // Description
                    Text(
                      'รายละเอียดรถ',
                      style: GoogleFonts.urbanist(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: DslColors.primaryText,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: DslColors.spacingSm),
                    Text(
                      'Toyota Camry 2.5V รุ่นท็อปสุด ปี 2023 สภาพใหม่เอี่ยม พร้อมระบบความปลอดภัยครบครัน Toyota Safety Sense ติดตั้งกล้องมองหลัง 360 องศา และระบบนำทาง GPS ในตัว เหมาะสำหรับการเดินทางทางธุรกิจและท่องเที่ยว',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: DslColors.secondaryText,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: DslColors.spacingLg),

                    // Current tenant info
                    Text(
                      'ข้อมูลผู้เช่าปัจจุบัน',
                      style: GoogleFonts.urbanist(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: DslColors.primaryText,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: DslColors.spacingMd),
                    _TenantInfoCard(),
                    const SizedBox(height: DslColors.spacingLg),

                    // Lease dates
                    Text(
                      'ระยะเวลาการเช่า',
                      style: GoogleFonts.urbanist(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: DslColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: DslColors.spacingMd),
                    _LeaseDateCard(),
                    const SizedBox(height: DslColors.spacingXl),

                    // Book button
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DslColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(DslColors.radiusLg),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.calendar_today_rounded, size: 18),
                          const SizedBox(width: DslColors.spacingSm),
                          Text(
                            'จองรถคันนี้',
                            style: GoogleFonts.urbanist(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: DslColors.spacingMd),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: DslColors.secondary,
                        side: const BorderSide(color: DslColors.secondary),
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(DslColors.radiusLg),
                        ),
                      ),
                      child: Text(
                        'ติดต่อเจ้าหน้าที่',
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xCCFFFFFF),
          borderRadius: BorderRadius.circular(DslColors.radiusMd),
        ),
        child: Icon(icon, color: DslColors.background, size: 20),
      ),
    );
  }
}

class _SpecItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SpecItem(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: DslColors.primary.withAlpha(26),
            borderRadius: BorderRadius.circular(DslColors.radiusMd),
          ),
          child: Icon(icon, color: DslColors.primary, size: 22),
        ),
        const SizedBox(height: DslColors.spacingXs),
        Text(
          value,
          style: GoogleFonts.urbanist(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: DslColors.primaryText,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: DslColors.secondaryText,
          ),
        ),
      ],
    );
  }
}

class _TenantInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DslColors.spacingMd),
      decoration: BoxDecoration(
        color: DslColors.surface,
        borderRadius: BorderRadius.circular(DslColors.radiusMd),
        border: Border.all(color: DslColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: DslColors.secondary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                'ส',
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
                  'สมชาย ใจดี',
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: DslColors.primaryText,
                  ),
                ),
                Text(
                  '+66 81-234-5678',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: DslColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.call_rounded,
                    color: DslColors.success, size: 20),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.message_rounded,
                    color: DslColors.primary, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LeaseDateCard extends StatelessWidget {
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
        children: [
          Row(
            children: [
              Expanded(
                child: _DateItem(
                    label: 'วันรับรถ', date: '15 มี.ค. 2026', isStart: true),
              ),
              Container(
                width: 1,
                height: 40,
                color: DslColors.divider,
              ),
              Expanded(
                child: _DateItem(
                    label: 'วันคืนรถ',
                    date: '22 มี.ค. 2026',
                    isStart: false),
              ),
            ],
          ),
          const Divider(color: DslColors.divider, height: DslColors.spacingLg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'รวม 7 วัน',
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: DslColors.primaryText,
                ),
              ),
              Text(
                '฿22,400',
                style: GoogleFonts.urbanist(
                  fontSize: 17,
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

class _DateItem extends StatelessWidget {
  final String label;
  final String date;
  final bool isStart;

  const _DateItem(
      {required this.label, required this.date, required this.isStart});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isStart ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: DslColors.secondaryText,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          date,
          style: GoogleFonts.urbanist(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: DslColors.primaryText,
          ),
        ),
      ],
    );
  }
}
