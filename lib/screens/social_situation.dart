import 'package:flutter/material.dart';
import 'package:front_pi/theme/styles.dart';
import 'package:front_pi/widgets/mainAppBar.dart';

class SocialSituationPage extends StatelessWidget {
  final String patientName;
  final String socialSituation;

  const SocialSituationPage({
    super.key,
    required this.patientName,
    required this.socialSituation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.bgColor,
      appBar: MainAppBar(
        title: 'Situação social de $patientName',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Text(socialSituation, style: Styles.normalText),
      ),
    );
  }
}