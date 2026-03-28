import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../theme/dsl_colors.dart';

/// Page 1: Onboarding — Welcome page highlighting key features for landlords
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DslColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Image Stack (420px)
              SizedBox(
                height: 420,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background image
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://dimg.dreamflow.cloud/v1/image/luxury+black+sports+car+driving+through+bangkok+city+at+night+with+neon+lights',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 420,
                        placeholder: (context, url) => Container(
                          color: DslColors.surface,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: DslColors.primary,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: DslColors.surface,
                          child: const Icon(Icons.directions_car,
                              color: DslColors.secondaryText, size: 64),
                        ),
                      ),
                    ),
                    // Gradient overlay bottom
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          stops: [0.0, 0.4, 1.0],
                          colors: [
                            Color(0xFF0A0A0F),
                            Color(0x880A0A0F),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    // Top: Brand Logo Row
                    Positioned(
                      top: DslColors.spacingXl,
                      left: DslColors.spacingLg,
                      right: DslColors.spacingLg,
                      child: Row(
                        children: [
                          // Logo container
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0A0A0F),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: DslColors.secondary,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0x40000000),
                                  offset: const Offset(0, 8),
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: CachedNetworkImage(
                              imageUrl:
                                  'https://dimg.dreamflow.cloud/v1/image/pink+circular+logo+with+handwritten+R+on+dark+background',
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => Center(
                                child: Text(
                                  'R',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: DslColors.secondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: DslColors.spacingMd),
                          // Brand name
                          Text(
                            'RENTAL-R',
                            style: GoogleFonts.urbanist(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Bottom: Hero text
                    Positioned(
                      bottom: DslColors.spacingXl,
                      left: DslColors.spacingLg,
                      right: DslColors.spacingLg,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: DslColors.secondary,
                              borderRadius:
                                  BorderRadius.circular(DslColors.radiusFull),
                            ),
                            child: Text(
                              'PREMIUM CAR RENTAL',
                              style: GoogleFonts.urbanist(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 1.1,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: DslColors.spacingSm),
                          Text(
                            'สัมผัสประสบการณ์การขับขี่ที่เหนือระดับ',
                            style: GoogleFonts.urbanist(
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Content section
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: DslColors.spacingLg,
                  vertical: DslColors.spacingXl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Welcome text
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ยินดีต้อนรับสู่ Rental-R',
                          style: GoogleFonts.urbanist(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: DslColors.primaryText,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: DslColors.spacingSm),
                        Text(
                          'ยกระดับทุกการเดินทางของคุณด้วยรถยนต์หรูและบริการระดับพรีเมียมทั่วไทย',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: DslColors.secondaryText,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: DslColors.spacingXl),

                    // Feature cards
                    _FeatureCard(
                      icon: Icons.diamond_rounded,
                      iconColor: DslColors.secondary,
                      iconBg: const Color(0xFFFFF0F6),
                      title: 'รถหรูระดับพรีเมียม',
                      desc:
                          'คัดสรรเฉพาะรถยนต์รุ่นท็อป สภาพใหม่เอี่ยม เพื่อภาพลักษณ์ที่โดดเด่นของคุณ',
                    ),
                    const SizedBox(height: DslColors.spacingMd),
                    _FeatureCard(
                      icon: Icons.flash_on_rounded,
                      iconColor: DslColors.success,
                      iconBg: const Color(0xFFE8F5E9),
                      title: 'จองง่ายเพียงปลายนิ้ว',
                      desc:
                          'ระบบจองออนไลน์ที่รวดเร็วและปลอดภัย พร้อมทีมงานดูแลตลอด 24 ชั่วโมง',
                    ),
                    const SizedBox(height: DslColors.spacingMd),
                    _FeatureCard(
                      icon: Icons.workspace_premium_rounded,
                      iconColor: DslColors.primary,
                      iconBg: const Color(0xFFE3F2FD),
                      title: 'บริการรับ-ส่ง VIP',
                      desc:
                          'บริการส่งรถถึงที่หมาย ไม่ว่าจะเป็นสนามบิน โรงแรม หรือบ้านพักของคุณ',
                    ),
                    const SizedBox(height: DslColors.spacingXl),

                    // Social proof card
                    Container(
                      padding: const EdgeInsets.all(DslColors.spacingMd),
                      decoration: BoxDecoration(
                        color: DslColors.surface,
                        borderRadius:
                            BorderRadius.circular(DslColors.radiusLg),
                        border: Border.all(color: DslColors.divider, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0066FF26),
                            offset: const Offset(0, 4),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Avatar stack
                          SizedBox(
                            width: 36 * 3 - 14 * 2,
                            height: 36,
                            child: Stack(
                              children: [
                                _Avatar(label: 'R', bg: DslColors.secondary, fg: Colors.white, left: 0),
                                _Avatar(label: 'A', bg: DslColors.primary, fg: Colors.white, left: 22),
                                _Avatar(label: 'M', bg: DslColors.accent, fg: DslColors.background, left: 44),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ความประทับใจจากลูกค้า',
                                style: GoogleFonts.urbanist(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: DslColors.primaryText,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'ได้รับความไว้วางใจกว่า 50,000+ ราย',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: DslColors.secondaryText,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: DslColors.spacingXl),

                    // CTA Search Button
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: DslColors.secondary,
                          borderRadius:
                              BorderRadius.circular(DslColors.radiusLg),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF33FF2D87),
                              offset: const Offset(0, 12),
                              blurRadius: 24,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_rounded,
                                color: Colors.white, size: 20),
                            const SizedBox(width: DslColors.spacingSm),
                            Text(
                              'ค้นหารถเช่าของคุณ',
                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: DslColors.spacingMd),

                    // Outline button
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: DslColors.primary, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(DslColors.radiusLg),
                        ),
                        padding:
                            const EdgeInsets.symmetric(vertical: 16),
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      child: Text(
                        'เข้าสู่ระบบ / สมัครสมาชิก',
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: DslColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: DslColors.spacingXl),

                    // Footer links
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'นโยบายความเป็นส่วนตัว',
                          style: GoogleFonts.urbanist(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: DslColors.primary,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(width: DslColors.spacingMd),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: DslColors.divider,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: DslColors.spacingMd),
                        Text(
                          'ข้อกำหนดและเงื่อนไข',
                          style: GoogleFonts.urbanist(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: DslColors.primary,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: DslColors.spacingXl),
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

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String desc;

  const _FeatureCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.desc,
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
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(DslColors.radiusMd),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: DslColors.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: DslColors.primaryText,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: DslColors.secondaryText,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  final double left;

  const _Avatar({
    required this.label,
    required this.bg,
    required this.fg,
    required this.left,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          border: Border.all(color: DslColors.surface, width: 2),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ),
      ),
    );
  }
}
