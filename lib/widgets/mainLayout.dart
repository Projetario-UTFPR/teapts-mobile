import 'package:flutter/material.dart';
import 'package:front_pi/services/auth_service.dart';
import 'package:front_pi/services/pts_service.dart';
import 'package:front_pi/theme/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

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
            color: Colors.black.withValues(alpha: 0.25),
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
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black.withAlpha(80),
                    width: 1,
                  ),
                ),

                child: const CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey,
                  backgroundImage: AssetImage("assets/imagens/dog.png"),
                ),
              ),
            ],
          ),
        ),
      ),
      body: navigationShell,

      bottomNavigationBar: _BottomNav(navigationShell: navigationShell),
    );
  }
}

class _BottomNav extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const _BottomNav({required this.navigationShell});

  @override
  State<_BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<_BottomNav> {
  bool _hasActivePts = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPtsStatus();
  }

  Future<void> _loadPtsStatus() async {
    setState(() => _isLoading = true);

    final result = await PtsService.checkSelfHasActivePts();

    setState(() {
      _hasActivePts = result;
      _isLoading = false;
    });
  }

  Widget _container(List<Widget> children) {
    return SafeArea(
      child: Container(
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
                : context.push('/pts-proposals/${authCollection!.account.id}'),
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
          icon: PhosphorIconsFill.userCircle,
          label: 'Novo paciente',
          isActive: currentLocation == '/create-pts',
          onTap: () => context.pushNamed('create pts'),
        ),
    ]);
  }

  Widget? navButtonDependingOnPtsCheck(_NavButton? Function(bool) builder) {
    final ptsButtonSkeleton = SizedBox(
      width: 64,
      height: 68,
      child: Center(
        child: SizedBox(
          key: ValueKey("loading-spinner"),
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
        ),
      ),
    );

    Widget? ptsNavButton;
    if (_isLoading) {
      ptsNavButton = ptsButtonSkeleton;
    } else {
      ptsNavButton = builder(_hasActivePts);
    }

    return ptsNavButton;
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isActive ? null : onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        height: 68,
        child: Icon(
          icon,
          size: 32,
          color: isActive
              ? Colors.black
              : Styles.widgetBlack.withValues(alpha: 0.64),
        ),
      ),
    );
  }
}
