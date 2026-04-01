// ════════════════ settings_screen.dart ════════════════
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Row(
                  children: [
                    GestureDetector(onTap: () => context.pop(), child: Container(width: 40, height: 40, decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.arrow_back_rounded, color: kTextHigh, size: 20))),
                    const SizedBox(width: 16),
                    Text('ตั้งค่า', style: kHead(22)),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Profile card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF1A1A2E), Color(0xFF16213E)]),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: kPrimary.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60, height: 60,
                            decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFFF2D78), Color(0xFFFF6B6B)]), shape: BoxShape.circle),
                            child: Center(child: Text('ด', style: kHead(24, color: Colors.white))),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ดรายฟ์โฟลว์ จำกัด', style: kHead(16)),
                              Text('admin@driveflow.co.th', style: kBody(13, color: kTextMed)),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(color: kPrimary.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                                child: Text('เจ้าของ', style: kBody(11, color: kPrimary, w: FontWeight.w600)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _Section('บัญชีของฉัน', [
                      _SettingRow(Icons.person_rounded, 'โปรไฟล์', subtitle: 'แก้ไขข้อมูลส่วนตัว'),
                      _SettingRow(Icons.notifications_rounded, 'การแจ้งเตือน', subtitle: 'ตั้งค่าการแจ้งเตือน'),
                      _SettingRow(Icons.credit_card_rounded, 'วิธีชำระเงิน', subtitle: 'บัตรเครดิต / พร้อมเพย์'),
                    ]),
                    const SizedBox(height: 20),
                    _Section('แอปพลิเคชัน', [
                      _SettingRow(Icons.language_rounded, 'ภาษา', subtitle: 'ไทย'),
                      _SettingRow(Icons.dark_mode_rounded, 'โหมดมืด', subtitle: 'เปิดอยู่', trailing: Switch(value: true, onChanged: (_) {}, activeColor: kPrimary)),
                      _SettingRow(Icons.lock_rounded, 'ความเป็นส่วนตัว', subtitle: 'นโยบาย PDPA'),
                    ]),
                    const SizedBox(height: 20),
                    _Section('ช่วยเหลือ', [
                      _SettingRow(Icons.help_rounded, 'ศูนย์ช่วยเหลือ'),
                      _SettingRow(Icons.info_rounded, 'เกี่ยวกับแอป', subtitle: 'v1.0.0'),
                    ]),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => context.go('/'),
                      child: Container(
                        width: double.infinity, height: 52,
                        decoration: BoxDecoration(
                          color: kError.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: kError.withOpacity(0.3)),
                        ),
                        child: Center(child: Text('ออกจากระบบ', style: kHead(16, color: kError))),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section(this.title, this.children);
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: kBody(13, color: kTextMed, w: FontWeight.w600)),
      const SizedBox(height: 10),
      Container(
        decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(16), border: Border.all(color: kDivider)),
        child: Column(children: children),
      ),
    ],
  );
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Widget? trailing;
  const _SettingRow(this.icon, this.label, {this.subtitle, this.trailing});
  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon, color: kSecondary, size: 22),
    title: Text(label, style: kBody(14, color: kTextHigh)),
    subtitle: subtitle != null ? Text(subtitle!, style: kBody(12, color: kTextMed)) : null,
    trailing: trailing ?? const Icon(Icons.chevron_right_rounded, color: kTextLow),
  );
}
