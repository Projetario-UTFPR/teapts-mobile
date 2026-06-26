import 'package:flutter/material.dart';
import 'package:front_pi/home.dart';
import 'package:front_pi/create_pts.dart';
import 'package:go_router/go_router.dart';
import 'package:front_pi/login.dart';
import 'package:front_pi/view_pts.dart';
import 'package:front_pi/create_account.dart';
import 'package:front_pi/debug_page_routes.dart';
import 'package:front_pi/services/auth_service.dart';
import 'package:front_pi/widgets/mainLayout.dart';
import 'package:front_pi/widgets/upload_file.dart';
import 'package:front_pi/screens/timeline/index.dart';
import 'package:front_pi/prontuario.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',

  refreshListenable: AuthService.authNotifier,

  redirect: (BuildContext context, GoRouterState state) {
    final loggedIn = AuthService.accessToken != null;

    final publicRoutes = ['/login', '/create-account'];
    final isPublic = publicRoutes.contains(state.matchedLocation);

    if (!loggedIn && !isPublic) return '/login';
    if (loggedIn && isPublic) return '/home';

    return null;
  },

  routes: [
    GoRoute(path: '/login', builder: (context, state) => const Login()),
    GoRoute(
      path: '/create-account',
      builder: (context, state) => const SignUpPage(),
    ),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainLayout(navigationShell: navigationShell),

      branches: [
        // Branch 0 — aba "casa"
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomePage(),
            ),
            GoRoute(
              path: '/view-pts/:patientId',
              builder: (context, state) {
                final patientId = state.pathParameters['patientId']!;
                return ViewPtsPage(patientId: patientId);
              },
            ),

            GoRoute(
              path: '/create-pts',
              builder: (context, state) => const CreatePtsPage(),
            ),
            GoRoute(
              path: '/upload-doc/:patientId',
              builder: (context, state) {
                final patientId = state.pathParameters['patientId']!;
                return UploadDocPage(patientId: patientId);
              },
            ),
            GoRoute(
              path: '/prontuario/:patientId',
              builder: (context, state) {
                final patientId = state.pathParameters['patientId']!;
                return ProntuarioPage(patientId: patientId);
              },
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/timeline',
              builder: (context, state) => const TimelinePage(),
            ),
          ],
        ),

        // Branch 2 — aba "lista"
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/debug-page-2',
              builder: (context, state) => DebugPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
