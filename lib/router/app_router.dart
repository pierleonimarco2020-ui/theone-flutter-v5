import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/index.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/app',
      builder: (context, state) => const AppScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Error: ${state.error}'),
    ),
  ),
);
