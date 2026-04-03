# CLAUDE.md — grental (Flutter Car Rental App)

> อ่านไฟล์นี้ก่อนทุกครั้ง — ห้ามเขียนทับงานที่ทำแล้ว

---

## Project

- **ชื่อโครงการ**: grental
- **Path**: `C:\Users\usEr\grental`
- **pubspec name**: rungrojcarrental
- **Flutter**: 3.38.9 stable ✅ (No issues found)
- **Android SDK**: 36.1.0 ✅
- **State management**: flutter_riverpod
- **Router**: go_router ^14.0.0
- **Design spec**: `C:\Users\usEr\Documents\rungroj-carrental\recovered\selected-frames-agent-prompt.md`

---

## สีจริง (lib/theme/app_colors.dart) — อ่านจากไฟล์จริง ห้าม hardcode ใหม่

```dart
kPrimary    = Color(0xFFFF2D78)   // ชมพู
kSecondary  = Color(0xFF2979FF)   // น้ำเงิน
kBackground = Color(0xFF0A0A12)
kSurface    = Color(0xFF16161E)
kSurface2   = Color(0xFF1E1E28)
kAccent     = Color(0xFFFFE500)
kSuccess    = Color(0xFF00FFC2)
kError      = Color(0xFFFF453A)
kTextHigh   = Color(0xFFFFFFFF)
kTextMed    = Color(0xFFAAAAAA)
kTextLow    = Color(0xFF555560)
kGradientPrimary  // pink gradient
kGradientBlue     // blue gradient
kHead(size)  // Urbanist / NotoSansThai
kBody(size)  // Poppins / NotoSansThai
```

---

## Screens ที่เขียนแล้ว — ห้ามเขียนใหม่ทับ

| File | Route | สถานะ |
|------|-------|--------|
| onboarding_screen.dart | `/` | ✅ |
| home_screen.dart | `/home` | ✅ |
| r_drive_dashboard.dart | `/rdrive` | ✅ |
| car_details_screen.dart | `/car/:id` | ✅ |
| car_directory_screen.dart | `/cars` | ✅ |
| add_listing_screen.dart | `/add` | ✅ |
| financial_reports_screen.dart | `/finance` | ✅ |
| payment_history_screen.dart | `/payments` | ✅ |
| active_bookings_screen.dart | `/bookings` | ✅ |
| settings_screen.dart | `/settings` | ✅ |
| cart_screen.dart | `/cart` | ✅ |
| bank_account_screen.dart | `/bank` | ✅ |
| nfc_scan_screen.dart | `/nfc/:bookingId` | ✅ |
| qr_scan_screen.dart | `/qr/:bookingId` | ✅ |
| promptpay_screen.dart | `/promptpay` | ✅ |
| national_id_screen.dart | `/national-id/:bookingId` | ✅ |
| payment_screen.dart | ⚠️ ไม่มีใน router | ⚠️ ต้องเพิ่ม route |

**รวม: 17 screens**

---

## สิ่งที่ยังขาด

| รายการ | หมายเหตุ |
|--------|----------|
| payment_screen.dart | มีไฟล์แล้ว แต่ยังไม่มี route ใน app_router.dart |
| บันทึกเจ้าของร้าน (owner notes screen) | ยังไม่มี screen เลย |

---

## Environment (ยืนยันแล้ว 2026-04-03)

```
Flutter 3.38.9 stable ✅
Android SDK 36.1.0    ✅
Windows 11            ✅
flutter doctor        → No issues found ✅
Java                  → Android Studio JBR ✅
```

---

## กฎสำหรับ Claude

1. **อ่านไฟล์จริงก่อนเขียนเสมอ** — ไม่เดาสี ไม่เดา route
2. **ห้ามเขียนทับ screen ที่ทำแล้ว** — ดูตารางด้านบนก่อนทุกครั้ง
3. **ถ้าทำไม่ได้ → บอกตรงๆ** ไม่โยนงาน
4. **ทำได้ → ลุยเลย** ไม่ถามซ้ำ
5. **ชื่อโครงการ = grental เท่านั้น**
