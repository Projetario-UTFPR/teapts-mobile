import 'package:flutter/material.dart';
import 'package:front_pi/theme/styles.dart';
import 'package:front_pi/widgets/expandableEquipeMultidiciplinar.dart';
import 'package:front_pi/widgets/expandableText.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:gap/gap.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 48.0),
        child: Column(
          spacing: 24,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const CustomRowItem(
                title: 'John Doe',
                isCircularImage: true,
                isProfileImage: true,
              ),
            ),

            Divider(
              color: Styles.widgetBlack40,
              thickness: 1,
              endIndent: 16,
              indent: 16,
            ),

            const ExpandableTextDisplay(),

            const ExpandableAtividades(),

            const ExpandableEquipeMultidiciplinar(),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed:
                    (
                      //TODO: fazer o navigator para pagina de
                    ) {},
                style: Styles.buttonWhite,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Prontuario'),
                      Icon(
                        PhosphorIcons.arrowRight(PhosphorIconsStyle.bold),
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
