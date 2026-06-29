import 'package:flutter/material.dart';
import 'package:front_pi/components/alert.dart';
import 'package:front_pi/components/buttons/secondary_button.dart';
import 'package:front_pi/models/pts.dart';
import 'package:front_pi/services/pts_service.dart';
import 'package:front_pi/theme/styles.dart';
import 'package:front_pi/screens/pts/view/expandable_multidisciplinary_team.dart';
import 'package:front_pi/screens/pts/view/social_situation.dart';
import 'package:front_pi/widgets/mainAppBar.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/custom_row_item.dart';
import 'activities.dart';

class ViewPtsPage extends StatefulWidget {
  final String patientId;
  final String patientName;

  const ViewPtsPage({
    super.key,
    required this.patientId,
    required this.patientName,
  });

  @override
  ViewPtsPageState createState() => ViewPtsPageState();
}

class ViewPtsPageState extends State<ViewPtsPage> {
  bool _isLoading = false;
  PTSDto? _pts;
  String? _error;

  Future<void> _loadPts() async {
    _isLoading = true;

    try {
      final pts = await PtsService.getPts(widget.patientId);
      if (!context.mounted) return;
      setState(() => _pts = pts);
    } catch (e) {
      if (!context.mounted) return;
      setState(() => _error = e.toString());
    }

    _isLoading = false;
  }

  @override
  void initState() {
    super.initState();
    _loadPts();
  }

  @override
  Widget build(BuildContext context) {
    final error = _error;
    final pts = _pts;
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
              title: widget.patientName,
              isCircularImage: true,
              isProfileImage: true,
            ),

            Divider(color: Styles.widgetBlack40, thickness: 1),

            if (_isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: CircularProgressIndicator(color: Colors.amber),
                ),
              )
            else
              SitualSociationSection(
                patientId: widget.patientId,
                patientName: widget.patientName,
                socialSituation: pts?.socialSituation,
                error: _error,
              ),

            ActivitiesSection(patientId: widget.patientId),

            if (error != null)
              Alert(message: error, type: AlertType.error)
            else if (pts != null)
              MultidisciplinaryTeamSection(
                professionalsIds: pts.multidisciplinaryTeam,
                responsibleProfessionalId:
                    pts.responsibleProfessional.professionalId,
              ),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: SecondaryButton(
                title: "Prontuário",
                isLinkButton: true,
                onPressed: () =>
                    context.push('/prontuario/${widget.patientId}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
