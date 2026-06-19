import 'package:flutter/material.dart';
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
              Container(
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
            ],
          ),
        ),
      ),
      body: navigationShell,

      bottomNavigationBar: SizedBox(
        height: 68,

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
              label: 'pagina 1',
            ),
            BottomNavigationBarItem(
              icon: Icon(PhosphorIconsFill.path, size: 32),
              label: 'pagina 2',
            ),
            BottomNavigationBarItem(
              icon: Icon(PhosphorIconsBold.list, size: 32),
              label: 'pagina 3',
            ),
          ],
        ),
      ),
    );
  }
}
