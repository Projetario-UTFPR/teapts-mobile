import 'package:flutter/material.dart';
import 'package:front_pi/create_pts.dart';
import 'package:go_router/go_router.dart';
import 'package:front_pi/login.dart';
import 'package:front_pi/view_pts.dart';
import 'package:front_pi/create_account.dart';
import 'package:front_pi/debug_page_routes.dart';
import 'package:front_pi/services/auth_service.dart';
import 'package:front_pi/widgets/upload_file.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/debug-page',

  refreshListenable: AuthService.authNotifier,

  redirect: (BuildContext context, GoRouterState state) {
    final loggedIn = AuthService.accessToken != null;

    final publicRoutes = ['/login', '/create-account'];
    final isPublic = publicRoutes.contains(state.matchedLocation);

    if (!loggedIn && !isPublic) {
      return '/login';
    }

    if (loggedIn && isPublic) {
      return '/debug-page';
    }

    return null;
  },

  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const Login(),
    ),
    GoRoute(
      path: '/create-account',
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: '/view-pts',
      builder: (context, state) => ViewPtsPage(),
    ),
    GoRoute(
      path: '/create-pts',
      builder: (context, state) => const CreatePtsPage(),
    ),
    GoRoute(
      path: '/debug-page',
      builder: (context, state) => DebugPage(),
    ),
    GoRoute(
      path: '/upload-doc/:patientId',
      builder: (context, state) {
        final patientId = state.pathParameters['patientId']!;
        return UploadDocPage(patientId: patientId);
      },
    ),
  ],
);