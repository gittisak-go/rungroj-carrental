import 'package:flutter/material.dart';

import '../presentation/admin_dashboard_screen/admin_dashboard_screen.dart';
import '../presentation/admin_reservations_screen/admin_reservations_screen.dart';
import '../presentation/about_app_screen/about_app_screen.dart';
import '../presentation/authentication_screen/authentication_screen.dart';
import '../presentation/bank_info_screen/bank_info_screen.dart';
import '../presentation/checkout_screen/checkout_screen.dart';
import '../presentation/driver_management_screen/driver_management_screen.dart';
import '../presentation/driver_profile_screen/driver_profile_screen.dart';
import '../presentation/fleet_inventory_screen/fleet_inventory_screen.dart';
import '../presentation/live_tracking_screen/live_tracking_screen.dart';
import '../presentation/location_detection_screen/location_detection_screen.dart';
import '../presentation/payment_screen/payment_screen.dart';
import '../presentation/rental_status_screen/rental_status_screen.dart';
import '../presentation/ride_history_screen/ride_history_screen.dart';
import '../presentation/ride_request_screen/ride_request_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/user_profile_screen/user_profile_screen.dart';
import '../presentation/vehicle_management_screen/vehicle_management_screen.dart';
import '../presentation/notification_preferences_screen/notification_preferences_screen.dart';
import '../presentation/onboarding_screen/onboarding_screen.dart';
import '../presentation/new_screen_1_screen/new_screen_1_screen.dart';
import '../presentation/property_dashboard_screen/property_dashboard_screen.dart';
import '../presentation/property_details_screen/property_details_screen.dart';
import '../presentation/tenant_directory_screen/tenant_directory_screen.dart';
import '../presentation/maintenance_requests_screen/maintenance_requests_screen.dart';
import '../presentation/payment_history_screen/payment_history_screen.dart';
import '../presentation/add_new_property_screen/add_new_property_screen.dart';
import '../presentation/financial_reports_screen/financial_reports_screen.dart';
import '../presentation/settings_screen/settings_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String propertyDashboard = '/property-dashboard';
  static const String propertyDetails = '/property-details';
  static const String tenantDirectory = '/tenant-directory';
  static const String maintenanceRequests = '/maintenance-requests';
  static const String paymentHistory = '/payment-history';
  static const String addNewProperty = '/add-new-property';
  static const String financialReports = '/financial-reports';
  static const String settingsScreen = '/settings';
  static const String rideRequest = '/ride-request-screen';
  static const String liveTracking = '/live-tracking-screen';
  static const String splash = '/splash-screen';
  static const String payment = '/payment-screen';
  static const String userProfile = '/user-profile-screen';
  static const String driverProfile = '/driver-profile-screen';
  static const String authentication = '/authentication-screen';
  static const String rideHistory = '/ride-history-screen';
  static const String locationDetection = '/location-detection-screen';
  static const String vehicleManagement = '/vehicle-management-screen';
  static const String adminReservations = '/admin-reservations-screen';
  static const String bankInfoScreen = '/bank-info-screen';
  static const String adminDashboardScreen = '/admin-dashboard-screen';
  static const String driverManagementScreen = '/driver-management-screen';
  static const String fleetInventoryScreen = '/fleet-inventory-screen';
  static const String checkoutScreen = '/checkout-screen';
  static const String rentalStatusScreen = '/rental-status-screen';
  static const String aboutAppScreen = '/about-app-screen';
  static const String notificationPreferencesScreen =
      '/notification-preferences-screen';

  static Map<String, WidgetBuilder> get routes => {
    initial: (context) => const OnboardingScreen(),
    onboarding: (context) => const OnboardingScreen(),
    home: (context) => const NewScreen1Screen(),
    propertyDashboard: (context) => const PropertyDashboardScreen(),
    propertyDetails: (context) => const PropertyDetailsScreen(),
    tenantDirectory: (context) => const TenantDirectoryScreen(),
    maintenanceRequests: (context) => const MaintenanceRequestsScreen(),
    paymentHistory: (context) => const PaymentHistoryScreen(),
    addNewProperty: (context) => const AddNewPropertyScreen(),
    financialReports: (context) => const FinancialReportsScreen(),
    settingsScreen: (context) => const SettingsScreen(),
    rideRequest: (context) => const RideRequestScreen(),
    liveTracking: (context) => const LiveTrackingScreen(),
    splash: (context) => const SplashScreen(),
    payment: (context) => const PaymentScreen(),
    userProfile: (context) => const UserProfileScreen(),
    driverProfile: (context) => const DriverProfileScreen(),
    authentication: (context) => const AuthenticationScreen(),
    rideHistory: (context) => const RideHistoryScreen(),
    locationDetection: (context) => const LocationDetectionScreen(),
    vehicleManagement: (context) => const VehicleManagementScreen(),
    adminReservations: (context) => const AdminReservationsScreen(),
    bankInfoScreen: (context) => const BankInfoScreen(),
    adminDashboardScreen: (context) => const AdminDashboardScreen(),
    driverManagementScreen: (context) => const DriverManagementScreen(),
    fleetInventoryScreen: (context) => const FleetInventoryScreen(),
    checkoutScreen: (context) => const CheckoutScreen(),
    rentalStatusScreen: (context) => const RentalStatusScreen(),
    aboutAppScreen: (context) => const AboutAppScreen(),
    notificationPreferencesScreen: (context) =>
        const NotificationPreferencesScreen(),
    // TODO: Add your other routes here
  };
}
