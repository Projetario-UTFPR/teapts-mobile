import 'package:flutter/material.dart';
import 'package:front_pi/components/buttons/secondary_button.dart';
import 'package:front_pi/theme/styles.dart';
import 'package:front_pi/widgets/expandableEquipeMultidiciplinar.dart';
import 'package:front_pi/widgets/expandableText.dart';
import 'package:front_pi/widgets/mainAppBar.dart';
import 'package:go_router/go_router.dart';
import 'widgets/custom_row_item.dart';
import 'widgets/expandable_activities.dart';

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
      appBar: MainAppBar(title: 'Visualizar PTS', showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomRowItem(
              title: patientName,
              isCircularImage: true,
              isProfileImage: true,
            ),

            Divider(color: Styles.widgetBlack40, thickness: 1),

            const ExpandableTextDisplay(),

            ExpandableActivities(patientId: patientId),

            const ExpandableEquipeMultidisciplinar(),

            SizedBox(
              width: double.infinity,
              child: SecondaryButton(
                title: "Prontuário",
                isLinkButton: true,
                onPressed: () => context.push('/prontuario/$patientId'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
