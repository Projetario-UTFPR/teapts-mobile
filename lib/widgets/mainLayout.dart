import 'package:flutter/material.dart';
import 'package:front_pi/theme/styles.dart';
import 'package:front_pi/widgets/profile_drawer.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:front_pi/services/auth_service.dart';

class MainLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainLayout({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.widgetWhite,
        elevation: 0,
        leadingWidth: 128,
        toolbarHeight: 64,

        automaticallyImplyLeading: false,
        titleSpacing: 0,
        shape: Border(
          bottom: BorderSide(
            color: Styles.widgetBlack.withOpacity(0.25),
            width: 1,
          ),
        ),

        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/imagens/infinito_laranja.png',
                height: 40,
                fit: BoxFit.contain,
              ),
              GestureDetector(
                onTap: () {
                  final userName =
                      AuthService.authCollection?.account.name ??
                      AuthService.currentUserName;

                  final isPatient =
                      AuthService.authCollection?.isPatient ?? false;
                  final role = isPatient ? 'Paciente' : AuthService.currentRole;

                  showProfilePanel(context, userName, role);
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Styles.widgetBlack.withAlpha(80),
                      width: 1,
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey,
                    backgroundImage: AssetImage("assets/imagens/dog.png"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: navigationShell,

      bottomNavigationBar: SizedBox(
        height: 68,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.black.withValues(alpha: 0.2)),
          ),
        ),
        child: ColoredBox(
          color: Styles.widgetWhite,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: children,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authCollection = AuthService.authCollection;
    final isPatient = authCollection?.isPatient ?? false;
    final isAdmin = authCollection?.account.role == 'admin';

    final currentLocation = GoRouterState.of(context).uri.toString();

    return _container([
      _NavButton(
        icon: PhosphorIconsFill.house,
        label: 'Home',
        isActive: currentLocation == '/home',
        onTap: () => context.pushNamed('home'),
      ),

      if (isPatient)
        ?navButtonDependingOnPtsCheck((hasActivePts) {
          return _NavButton(
            icon: PhosphorIconsFill.puzzlePiece,
            label: 'PTS',
            isActive:
                currentLocation.startsWith('/pts-proposals/') ||
                currentLocation.startsWith("/view-pts/"),
            onTap: () => hasActivePts
                ? context.push('/view-pts/${authCollection!.account.id}')
                : context.push('/approve-pts/${authCollection!.account.id}'),
          );
        }),

      ?navButtonDependingOnPtsCheck(
        (hasActivePts) => hasActivePts
            ? _NavButton(
                icon: PhosphorIconsFill.path,
                label: 'Timeline',
                isActive: currentLocation == '/timeline',
                onTap: () => context.pushNamed('timeline'),
              )
            : null,
      ),

      if (isAdmin)
        _NavButton(
          icon: PhosphorIconsFill.userCirclePlus,
          label: 'Novo paciente',
          isActive: currentLocation == '/create patient profile',
          onTap: () => context.pushNamed('create patient profile'),
        ),
    ]);
  }

        child: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          onTap: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },

          backgroundColor: Styles.widgetWhite,

          showSelectedLabels: false,
          showUnselectedLabels: false,

          selectedItemColor: Styles.widgetBlack,
          unselectedItemColor: Styles.widgetBlack,
          type: BottomNavigationBarType.fixed,

          items: const [
            BottomNavigationBarItem(
              icon: Icon(PhosphorIconsFill.house, size: 32),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(PhosphorIconsFill.path, size: 32),
              label: 'Timeline',
            ),
            BottomNavigationBarItem(
              icon: Icon(PhosphorIconsBold.list, size: 32),
              label: 'Mapa de telas (Debug)',
            ),
          ],
        ),
      ),
    );
  }
}
