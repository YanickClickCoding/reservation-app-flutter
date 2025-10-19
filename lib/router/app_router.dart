import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hotels/screens/home_screen.dart';
import 'package:hotels/screens/login_screen.dart';
import 'package:hotels/screens/register_screen.dart';
import 'package:hotels/screens/hotel_detail_screen.dart';
import 'package:hotels/screens/booking_screen.dart';
import 'package:hotels/screens/payment_screen.dart';
import 'package:hotels/screens/profile_screen.dart';
import 'package:hotels/screens/favorites_screen.dart';
import 'package:hotels/screens/notifications_screen.dart';
import 'package:hotels/models/hotel.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/hotel/:id',
        builder: (context, state) {
          final hotel = state.extra as Hotel;
          return HotelDetailScreen(hotel: hotel);
        },
      ),
      GoRoute(
        path: '/booking',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return BookingScreen(hotel: args['hotel'] as Hotel);
        },
      ),
      GoRoute(
        path: '/payment',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return PaymentScreen(
            hotel: args['hotel'] as Hotel,
            checkInDate: args['checkInDate'] as DateTime,
            checkOutDate: args['checkOutDate'] as DateTime,
            adults: args['adults'] as int,
            children: args['children'] as int,
            rooms: args['rooms'] as int,
          );
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Erreur: ${state.error}'),
      ),
    ),
  );
}
