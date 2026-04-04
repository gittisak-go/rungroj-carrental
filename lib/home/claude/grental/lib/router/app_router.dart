import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/onboarding_screen.dart';
import '../screens/home_screen.dart';
import '../screens/r_drive_dashboard.dart';
import '../screens/car_details_screen.dart';
import '../screens/add_listing_screen.dart';
import '../screens/financial_reports_screen.dart';
import '../screens/payment_history_screen.dart';
import '../screens/active_bookings_screen.dart';
import '../screens/car_directory_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/nfc_scan_screen.dart';
import '../screens/qr_scan_screen.dart';
import '../screens/promptpay_screen.dart';
import '../screens/national_id_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/bank_account_screen.dart';
import '../theme/app_colors.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(path: '/',          builder: (_, __) => const OnboardingScreen()),
    GoRoute(path: '/home',      builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/rdrive',    builder: (_, __) => const RDriveDashboard()),
    GoRoute(
      path: '/car/:id',
      builder: (_, state) => CarDetailsScreen(carId: state.pathParameters['id']!),
    ),
    GoRoute(path: '/add',       builder: (_, __) => const AddListingScreen()),
    GoRoute(path: '/finance',   builder: (_, __) => const FinancialReportsScreen()),
    GoRoute(path: '/payments',  builder: (_, __) => const PaymentHistoryScreen()),
    GoRoute(path: '/bookings',  builder: (_, __) => const ActiveBookingsScreen()),
    GoRoute(path: '/cars',      builder: (_, __) => const CarDirectoryScreen()),
    GoRoute(path: '/settings',  builder: (_, __) => const SettingsScreen()),
    GoRoute(path: '/cart',      builder: (_, __) => const CartScreen()),
    GoRoute(path: '/bank',      builder: (_, __) => const BankAccountScreen()),
    GoRoute(
      path: '/nfc/:bookingId',
      builder: (_, state) => NfcScanScreen(
        bookingId: state.pathParameters['bookingId']!,
        mode: state.uri.queryParameters['mode'] ?? 'checkin',
      ),
    ),
    GoRoute(
      path: '/qr/:bookingId',
      builder: (_, state) => QrScanScreen(bookingId: state.pathParameters['bookingId']!),
    ),
    GoRoute(
      path: '/promptpay',
      builder: (_, state) => PromptPayScreen(
        amount: double.tryParse(state.uri.queryParameters['amount'] ?? '0') ?? 0,
        bookingId: state.uri.queryParameters['bookingId'] ?? '',
      ),
    ),
    GoRoute(
      path: '/national-id/:bookingId',
      builder: (_, state) => NationalIdScreen(bookingId: state.pathParameters['bookingId']!),
    ),
  ],
  errorBuilder: (_, state) => Scaffold(
    backgroundColor: kBackground,
    body: Center(child: Text('ไม่พบหน้านี้', style: kHead(16))),
  ),
);
