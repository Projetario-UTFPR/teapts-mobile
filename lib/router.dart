import 'package:flutter/material.dart';
import 'package:front_pi/create_pts.dart';
import 'package:go_router/go_router.dart';
import 'package:front_pi/login.dart';
import 'package:front_pi/view_pts.dart';
import 'package:front_pi/create_account.dart';
import 'package:front_pi/debug_page_routes.dart';
import 'package:front_pi/services/auth_service.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/debug-page', 

  refreshListenable: AuthService.authNotifier,

  redirect: (BuildContext context, GoRouterState state) {
    final bool loggedIn = AuthService.accessToken != null; //esta logado?

    final List<String> publicRoutes = ['/login', '/create-account', '/debug-page', '/create-pts', '/view-pts']; //rotas públicas
    
    final bool isGoingToPublicRoute = publicRoutes.contains(state.matchedLocation);

    if (!loggedIn && !isGoingToPublicRoute) {// não está logado em uma página q não é pública
      return '/login'; 
    }

    if (loggedIn && isGoingToPublicRoute) { //logado tentando acessar uma página pública
      return '/debug-page'; 
    }
    return null;
  },

  routes: [
    /*
     GoRoute(
      path: '/',
      builder: (context, state) => const Home(),
    ),*/
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
      builder: (context, state) =>  DebugPage(),
    ),
  ],
);