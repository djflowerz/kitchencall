import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../screens/splash/splash_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/signup_screen.dart';
import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/main_nav/main_navigation_screen.dart';
import '../../screens/search/search_screen.dart';
import '../../screens/search/search_results_screen.dart';
import '../../screens/cook/cook_profile_screen.dart';
import '../../screens/booking/select_service_screen.dart';
import '../../screens/booking/select_datetime_screen.dart';
import '../../screens/booking/choose_menu_screen.dart';
import '../../screens/booking/ingredients_screen.dart';
import '../../screens/booking/booking_summary_screen.dart';
import '../../screens/booking/payment_screen.dart';
import '../../screens/booking/booking_confirmed_screen.dart';
import '../../screens/tracking/live_tracking_screen.dart';
import '../../screens/chat/chat_screen.dart';
import '../../screens/bookings/booking_details_screen.dart';
import '../../screens/favorites/favorites_screen.dart';
import '../../screens/notifications/notifications_screen.dart';
import '../../screens/subscription/subscription_plans_screen.dart';
import '../../screens/wallet/wallet_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/profile/edit_profile_screen.dart';
import '../../screens/profile/addresses_screen.dart';
import '../../screens/profile/payment_methods_screen.dart';
import '../../screens/profile/dietary_preferences_screen.dart';
import '../../screens/profile/settings_screen.dart';
import '../../screens/profile/help_support_screen.dart';
import '../../screens/review/rating_review_screen.dart';
import '../../models/booking_model.dart';

/// Route names as constants so `context.pushNamed(...)` calls
/// throughout the app never rely on hand-typed strings.
class Routes {
  Routes._();
  static const splash = 'splash';
  static const onboarding = 'onboarding';
  static const login = 'login';
  static const signup = 'signup';
  static const forgotPassword = 'forgotPassword';
  static const home = 'home';
  static const search = 'search';
  static const searchResults = 'searchResults';
  static const cookProfile = 'cookProfile';
  static const selectService = 'selectService';
  static const selectDateTime = 'selectDateTime';
  static const chooseMenu = 'chooseMenu';
  static const ingredients = 'ingredients';
  static const bookingSummary = 'bookingSummary';
  static const payment = 'payment';
  static const bookingConfirmed = 'bookingConfirmed';
  static const liveTracking = 'liveTracking';
  static const chat = 'chat';
  static const bookingDetails = 'bookingDetails';
  static const favorites = 'favorites';
  static const notifications = 'notifications';
  static const subscriptionPlans = 'subscriptionPlans';
  static const wallet = 'wallet';
  static const profile = 'profile';
  static const ratingReview = 'ratingReview';
  static const editProfile = 'editProfile';
  static const addresses = 'addresses';
  static const paymentMethods = 'paymentMethods';
  static const dietaryPreferences = 'dietaryPreferences';
  static const settings = 'settings';
  static const helpSupport = 'helpSupport';
}

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', name: Routes.splash, builder: (c, s) => const SplashScreen()),
    GoRoute(path: '/onboarding', name: Routes.onboarding, builder: (c, s) => const OnboardingScreen()),
    GoRoute(path: '/login', name: Routes.login, builder: (c, s) => const LoginScreen()),
    GoRoute(path: '/signup', name: Routes.signup, builder: (c, s) => const SignUpScreen()),
    GoRoute(path: '/forgot-password', name: Routes.forgotPassword, builder: (c, s) => const ForgotPasswordScreen()),

    GoRoute(path: '/home', name: Routes.home, builder: (c, s) => const MainNavigationScreen()),

    GoRoute(path: '/search', name: Routes.search, builder: (c, s) => const SearchScreen()),
    GoRoute(path: '/search-results', name: Routes.searchResults, builder: (c, s) => const SearchResultsScreen()),
    GoRoute(
      path: '/cook/:cookId',
      name: Routes.cookProfile,
      builder: (c, s) => CookProfileScreen(cookId: s.pathParameters['cookId']!),
    ),

    // Booking wizard
    GoRoute(path: '/booking/service', name: Routes.selectService, builder: (c, s) => const SelectServiceScreen()),
    GoRoute(path: '/booking/datetime', name: Routes.selectDateTime, builder: (c, s) => const SelectDateTimeScreen()),
    GoRoute(path: '/booking/menu', name: Routes.chooseMenu, builder: (c, s) => const ChooseMenuScreen()),
    GoRoute(path: '/booking/ingredients', name: Routes.ingredients, builder: (c, s) => const IngredientsScreen()),
    GoRoute(path: '/booking/summary', name: Routes.bookingSummary, builder: (c, s) => const BookingSummaryScreen()),
    GoRoute(path: '/booking/payment', name: Routes.payment, builder: (c, s) => const PaymentScreen()),
    GoRoute(
      path: '/booking/confirmed',
      name: Routes.bookingConfirmed,
      builder: (c, s) => BookingConfirmedScreen(booking: s.extra as BookingModel),
    ),

    GoRoute(
      path: '/tracking/:bookingId',
      name: Routes.liveTracking,
      builder: (c, s) => LiveTrackingScreen(bookingId: s.pathParameters['bookingId']!),
    ),
    GoRoute(
      path: '/chat/:cookId',
      name: Routes.chat,
      builder: (c, s) => ChatScreen(cookId: s.pathParameters['cookId']!, cookName: (s.extra as String?) ?? 'Cook'),
    ),
    GoRoute(
      path: '/booking-details/:bookingId',
      name: Routes.bookingDetails,
      builder: (c, s) => BookingDetailsScreen(bookingId: s.pathParameters['bookingId']!),
    ),

    GoRoute(path: '/favorites', name: Routes.favorites, builder: (c, s) => const FavoritesScreen()),
    GoRoute(path: '/notifications', name: Routes.notifications, builder: (c, s) => const NotificationsScreen()),
    GoRoute(path: '/subscriptions', name: Routes.subscriptionPlans, builder: (c, s) => const SubscriptionPlansScreen()),
    GoRoute(path: '/wallet', name: Routes.wallet, builder: (c, s) => const WalletScreen()),
    GoRoute(path: '/profile', name: Routes.profile, builder: (c, s) => const ProfileScreen()),
    GoRoute(path: '/profile/edit', name: Routes.editProfile, builder: (c, s) => const EditProfileScreen()),
    GoRoute(path: '/profile/addresses', name: Routes.addresses, builder: (c, s) => const AddressesScreen()),
    GoRoute(path: '/profile/payment-methods', name: Routes.paymentMethods, builder: (c, s) => const PaymentMethodsScreen()),
    GoRoute(path: '/profile/dietary', name: Routes.dietaryPreferences, builder: (c, s) => const DietaryPreferencesScreen()),
    GoRoute(path: '/profile/settings', name: Routes.settings, builder: (c, s) => const SettingsScreen()),
    GoRoute(path: '/profile/help', name: Routes.helpSupport, builder: (c, s) => const HelpSupportScreen()),
    GoRoute(
      path: '/rate/:bookingId',
      name: Routes.ratingReview,
      builder: (c, s) => RatingReviewScreen(bookingId: s.pathParameters['bookingId']!),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Page not found: ${state.uri}')),
  ),
);
