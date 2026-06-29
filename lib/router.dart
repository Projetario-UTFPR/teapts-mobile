import 'package:flutter/material.dart';
import 'package:front_pi/home.dart';
import 'package:front_pi/create_pts.dart';
import 'package:front_pi/screens/pts/view/screen.dart';
import 'package:front_pi/screens/timeline/screen.dart';
import 'package:go_router/go_router.dart';
import 'package:front_pi/login.dart';
import 'package:front_pi/create_account.dart';
import 'package:front_pi/services/auth_service.dart';
import 'package:front_pi/widgets/mainLayout.dart';
import 'package:front_pi/screens/upload_file.dart';
import 'package:front_pi/prontuario.dart';
import 'package:front_pi/screens/social_situation.dart';

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
    // public routes
    GoRoute(path: '/login', builder: (context, state) => const Login()),
    GoRoute(
      path: '/create-account',
      builder: (context, state) => const SignUpPage(),
    ),

    // protected routes
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainLayout(navigationShell: navigationShell),

      branches: [
        // home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomePage(),
              routes: [
              ]
            ),
            GoRoute(
              path: '/view-pts/:patientId',
              builder: (context, state) {
                final patientId = state.pathParameters['patientId']!;
                final patientName = (state.extra as String?) ?? 'Paciente';
                return ViewPtsPage(
                  patientId: patientId,
                  patientName: patientName,
                );
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
            GoRoute(
              path: '/social-situation/:patientId',
              builder: (context, state) {
                final extra = state.extra as Map<String, dynamic>?;
                return SocialSituationPage(
                  patientName: extra?['patientName'] as String? ?? 'Paciente',
                  socialSituation: extra?['socialSituation'] as String? ?? '',
                );
              },
            ),
          ],
        ),
        // timeline
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/timeline",
              builder: (context, state) => const TimelinePage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
