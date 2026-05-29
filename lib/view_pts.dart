import 'package:flutter/material.dart';
import 'package:front_pi/theme/styles.dart';
import 'package:front_pi/widgets/expandableEquipeMultidiciplinar.dart';
import 'package:front_pi/widgets/expandableText.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'widgets/imageSideCard.dart';
import 'widgets/expandableAtividades.dart';

class ViewPtsPage extends StatelessWidget {
  ViewPtsPage({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.bgColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const CustomRowItem(
                title: 'John Doe',
                isCircularImage: true,
              ),
            ),
            const expandableTextfield(),

            const SizedBox(height: 24),
            
            const ExpandableAtividades(),

            const SizedBox(height: 24),
            
            const ExpandableEquipeMultidiciplinar(),

            const SizedBox(height: 24),

            SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {},
                    label: const Text('Prontuario'),
                    icon: Icon(PhosphorIcons.arrowRight())
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
