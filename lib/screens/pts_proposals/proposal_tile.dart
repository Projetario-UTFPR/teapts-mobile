import 'package:flutter/material.dart';
import 'package:front_pi/components/buttons/primary_button.dart';
import 'package:front_pi/components/buttons/secondary_button.dart';
import 'package:front_pi/components/card.dart';
import 'package:front_pi/models/professional.dart';
import 'package:front_pi/models/pts.dart';
import 'package:front_pi/theme/styles.dart';

class ProposalTile extends StatelessWidget {
  final PTSProposalDto proposal;
  final bool isAccepted;
  final bool isRejected;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const ProposalTile({
    super.key,
    required this.proposal,
    required this.isAccepted,
    required this.isRejected,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isRejected && !isAccepted ? 0.38 : 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomCard(
            children: [
              CardProfilePictureHeader(
                name: proposal.responsibleName,
                roles: [mapSpecialism(proposal.responsibleRole)],
              ),
              SizedBox(height: 12),
              Divider(color: Colors.black.withValues(alpha: 0.1)),
              SizedBox(height: 12),

              if (proposal.multidisciplinaryTeam.isNotEmpty) ...[
                const Text(
                  "Equipe multidisciplinar",
                  style: TextStyle(
                    color: Styles.gray500,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 16),

                for (final (index, item)
                    in proposal.multidisciplinaryTeam.indexed)
                  _multidisciplinaryTeamProfessional(
                    item,
                    index == proposal.multidisciplinaryTeam.length - 1,
                  ),

                SizedBox(height: 16),
              ],

              _buildActions(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _multidisciplinaryTeamProfessional(
    ProposalTeamMemberDto professional,
    bool isLast,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      width: double.infinity,
      decoration: BoxDecoration(
        border: !isLast
            ? Border(
                bottom: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
              )
            : null,
      ),
      child: Text(
        '${professional.name} (${professional.specialism})',
        style: const TextStyle(fontSize: 16, color: Styles.gray500),
      ),
    );
  }

  Widget _buildActions() {
    if (isAccepted) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.check_circle_outline, color: Color(0xFF2E7D32), size: 18),
          SizedBox(width: 6),
          Text(
            'Equipe escolhida',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2E7D32),
            ),
          ),
        ],
      );
    }

    if (isRejected) {
      return const Center(
        child: Text(
          'Rejeitada automaticamente',
          style: TextStyle(fontSize: 13, color: Color(0xFF999999)),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            title: 'Escolher essa equipe',
            onPressed: onAccept,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: SecondaryButton(title: 'Rejeitar', onPressed: onReject),
        ),
      ],
    );
  }
}
