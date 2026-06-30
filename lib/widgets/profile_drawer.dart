import 'package:flutter/material.dart';
import 'package:front_pi/theme/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:front_pi/services/auth_service.dart';
import 'package:front_pi/components/buttons/primary_button.dart';
import 'package:front_pi/widgets/specialism_chip.dart';

Future<void> showProfilePanel(
  BuildContext context,
  String name,
  List<String> roles,
) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Styles.bgColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => ProfilePanel(name: name, roles: roles),
  );
}

class ProfilePanel extends StatelessWidget {
  final String name;
  final List<String> roles;

  const ProfilePanel({super.key, required this.name, required this.roles});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Meu Perfil', style: Styles.midSizeBold),
            const Gap(24),
            Row(
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.grey,
                  backgroundImage: AssetImage("assets/imagens/dog.png"),
                ),
                const Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: Styles.midSizeBold),
                      const Gap(4),
                      Wrap(
                        direction: Axis.horizontal,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ...roles.map((role) => SpecialismChip(label: role)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(24),
            const Divider(color: Color(0x1A000000)),

            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                title: 'Sair da conta',
                icon: PhosphorIconsRegular.signOut,
                onPressed: () {
                  AuthService.logout();
                  Navigator.pop(context);
                  context.go('/login');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
