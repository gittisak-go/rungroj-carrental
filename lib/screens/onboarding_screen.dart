import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _ctrl = PageController();
  int _page = 0;

  static const _pages = [
    _OData(
      icon: Icons.directions_car_rounded,
      gradient: [Color(0xFFFF2D78), Color(0xFFFF6B6B)],
      title: 'เช่ารถง่าย\nในไม่กี่คลิก',
      sub: 'เลือกรถ กำหนดวัน จ่ายเงิน\nรับกุญแจได้ทันที',
    ),
    _OData(
      icon: Icons.insert_chart_rounded,
      gradient: [Color(0xFF2979FF), Color(0xFF00C2FF)],
      title: 'ติดตามรายรับ\nReal-time',
      sub: 'ดูรายงานการเงิน การจอง\nและสถิติกองรถในที่เดียว',
    ),
    _OData(
      icon: Icons.shield_rounded,
      gradient: [Color(0xFF00FFC2), Color(0xFF2979FF)],
      title: 'ปลอดภัย\nเชื่อถือได้',
      sub: 'ยืนยันตัวตนทุกการเช่า\nมาตรฐาน Rental-R',
    ),
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < _pages.length - 1) {
      _ctrl.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.go('/home'),
                child: Text('ข้าม', style: kBody(14, color: kTextMed)),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _ctrl,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) => _PageView(data: _pages[i]),
              ),
            ),
            // Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _page == i ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _page == i ? kPrimary : kDivider,
                  borderRadius: BorderRadius.circular(4),
                ),
              )),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GestureDetector(
                onTap: _next,
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF2D78), Color(0xFFFF6B6B)],
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: kPrimary.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _page < _pages.length - 1 ? 'ถัดไป' : 'เริ่มใช้งาน',
                      style: kHead(16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _PageView extends StatelessWidget {
  final _OData data;
  const _PageView({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: data.gradient),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: data.gradient.first.withOpacity(0.35),
                  blurRadius: 40,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Icon(data.icon, size: 64, color: Colors.white),
          ),
          const SizedBox(height: 48),
          Text(data.title, textAlign: TextAlign.center, style: kHead(32)),
          const SizedBox(height: 16),
          Text(data.sub, textAlign: TextAlign.center, style: kBody(16, color: kTextMed)),
        ],
      ),
    );
  }
}

class _OData {
  final IconData icon;
  final List<Color> gradient;
  final String title;
  final String sub;
  const _OData({required this.icon, required this.gradient, required this.title, required this.sub});
}
