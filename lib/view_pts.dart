import 'package:flutter/material.dart';
import 'package:front_pi/theme/styles.dart';
import 'package:front_pi/widgets/expandableEquipeMultidiciplinar.dart';
import 'package:front_pi/widgets/expandableText.dart';
import 'package:front_pi/widgets/mainAppBar.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:go_router/go_router.dart';
import 'widgets/imageSideCard.dart';
import 'widgets/expandableActivities.dart';

class ViewPtsPage extends StatelessWidget {
  final String patientId;
  final String patientName;

  const ViewPtsPage({
    super.key,
    required this.patientId,
    required this.patientName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.bgColor,
      appBar: MainAppBar(
        title: 'Visualizar PTS',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomRowItem(
                title: patientName,
                isCircularImage: true,
                isProfileImage: true,
              ),
            ),

            Divider(
              color: Styles.widgetBlack40,
              thickness: 1,
            ),

            const ExpandableTextDisplay(),

            ExpandableActivities(patientId: patientId),

            const ExpandableEquipeMultidiciplinar(),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: () => context.push('/prontuario/$patientId'),
                style: Styles.buttonWhite,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Prontuario', style: Styles.midSizeBold),
                      Icon(
                        PhosphorIcons.arrowRight(PhosphorIconsStyle.bold),
                        size: 18,
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
