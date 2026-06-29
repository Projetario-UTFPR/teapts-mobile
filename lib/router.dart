import 'package:flutter/material.dart';
import 'package:front_pi/home.dart';
import 'package:front_pi/create_pts.dart';
import 'package:front_pi/screens/pts/view/screen.dart';
import 'package:front_pi/screens/timeline/screen.dart';
import 'package:go_router/go_router.dart';
import 'screens/login/login.dart';
import 'screens/login/create_account.dart';
import 'package:front_pi/services/auth_service.dart';
import 'package:front_pi/widgets/mainLayout.dart';
import 'package:front_pi/screens/upload_file.dart';
import 'package:front_pi/prontuario.dart';
import 'package:front_pi/screens/social_situation.dart';
import 'package:front_pi/screens/create_patient_profile.dart';
import 'package:front_pi/screens/approve_pts.dart';

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
        // home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              name: "home",
              builder: (context, state) => const HomePage(),
            ),
            GoRoute(
              path: "/timeline",
              name: "timeline",
              builder: (context, state) => const TimelinePage(),
            ),
            GoRoute(
              path: '/view-pts/:patientId',
              name: "patient's pts",
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
              name: "create pts",
              builder: (context, state) => const CreatePtsPage(),
            ),
            GoRoute(
              path: '/create-patient-profile',
              name: "create patient profile",
              builder: (context, state) => const CreatePatientProfilePage(),
            ),
            GoRoute(
              path: '/upload-doc/:patientId',
              name: "upload document to prontuario",
              builder: (context, state) {
                final patientId = state.pathParameters['patientId']!;
                return UploadDocPage(patientId: patientId);
              },
            ),
            GoRoute(
              path: '/prontuario/:patientId',
              name: "patient's prontuario",
              builder: (context, state) {
                final patientId = state.pathParameters['patientId']!;
                return ProntuarioPage(patientId: patientId);
              },
            ),
            GoRoute(
              path: '/social-situation/:patientId',
              name: "patient's social situation",
              builder: (context, state) {
                final extra = state.extra as Map<String, dynamic>?;
                return SocialSituationPage(
                  patientName: extra?['patientName'] as String? ?? 'Paciente',
                  socialSituation: extra?['socialSituation'] as String? ?? '',
                );
              },
            ),
            GoRoute(
              path: '/approve-pts/:patientId',
              name: 'approve pts',
              builder: (context, state) {
                final patientId = state.pathParameters['patientId']!;
                return PtsProposalsPage(patientId: patientId);
              },
            ),
          ],
        ),
      ],
    ),
  ],
);