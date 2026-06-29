import 'package:flutter/material.dart';
import 'package:front_pi/components/alert.dart';
import 'package:front_pi/components/expandable-section.dart';
import 'package:front_pi/models/professional.dart';
import 'package:front_pi/services/auth_service.dart';
import 'package:front_pi/services/professional_service.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../theme/styles.dart';
import '../../../widgets/custom_row_item.dart';

class MultidisciplinaryTeamSection extends StatefulWidget {
  final String responsibleProfessionalId;
  final List<String> professionalsIds;
  final bool _canEditMultidisciplinaryTeam;

  MultidisciplinaryTeamSection({
    super.key,
    required this.responsibleProfessionalId,
    required this.professionalsIds,
  }) : _canEditMultidisciplinaryTeam = AuthService.professionalProfiles.any((
         profile,
       ) {
         final id = profile["professionalId"] as String;
         return id == responsibleProfessionalId;
       });

  @override
  State<StatefulWidget> createState() {
    return _MultidisciplinaryTeamSectionState();
  }
}

class _MultidisciplinaryTeamSectionState
    extends State<MultidisciplinaryTeamSection> {
  int _currentPage = 1;
  final List<ProfessionalDto> _multidisciplinaryTeam = [];
  String? _error;
  bool _hasNextPage = false;
  bool _isLoading = false;

  Future<void> _fetchNextMultidisciplinaryTeamPage(BuildContext context) async {
    setState(() => _isLoading = true);

    try {
      final response = await ProfessionalService.getProfessionals(
        ids: widget.professionalsIds,
        page: _currentPage,
      );

      setState(() {
        _multidisciplinaryTeam.addAll(response.items);
        _hasNextPage = _multidisciplinaryTeam.length < response.totalElements;
      });
      _currentPage++;
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchNextMultidisciplinaryTeamPage(context);
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    final error = _error;
    if (error != null) {
      child = Alert(message: error, type: AlertType.error);
    } else {
      child = _multidisciplinaryTeamListView();
    }

    return ExpandableSection(
      title: "Equipe multidisciplinar",
      actions: [
        if (widget._canEditMultidisciplinaryTeam)
          IconButton(
            icon: Icon(
              PhosphorIcons.pencilSimpleLine(PhosphorIconsStyle.bold),
              size: 24,
              color: Styles.widgetBlack,
            ),
            onPressed: () {},
            style: IconButton.styleFrom(
              backgroundColor: Styles.widgetYellow,
              padding: const EdgeInsets.all(0),
              shape: CircleBorder(),
            ),
          ),
      ],
      children: [child],
    );
  }

  Widget _multidisciplinaryTeamListView() {
    if (_multidisciplinaryTeam.isEmpty) {
      return Alert(
        message: "Não há profissionais na equipe multidisciplinar deste PTS.",
        type: AlertType.info,
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _multidisciplinaryTeam.length + 1,
      separatorBuilder: (_, _) => SizedBox(height: 8),
      itemBuilder: (context, index) {
        final isProfessionalRow = index < _multidisciplinaryTeam.length;

        if (isProfessionalRow) {
          final professional = _multidisciplinaryTeam[index];

          return CustomRowItem(
            title: professional.name,
            subtitle: mapSpecialism(professional.specialism),
            isCircularImage: true,
            placeholderIcon: Icons.person,
          );
        }

        if (!_hasNextPage) return null;

        // TODO: add primary button
        // put _isLoading in it
        return Padding(
          padding: EdgeInsets.only(top: 4),
          child: ElevatedButton(
            onPressed: () {},
            child: const Text("Carregar mais"),
          ),
        );
      },
    );
  }
}
