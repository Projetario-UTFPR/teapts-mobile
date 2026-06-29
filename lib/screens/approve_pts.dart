import 'package:flutter/material.dart';
import 'package:front_pi/models/pts.dart';
import 'package:front_pi/services/pts_service.dart';
import 'package:front_pi/widgets/mainAppBar.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';


class PtsProposalsPage extends StatefulWidget {
  final String patientId;

  const PtsProposalsPage({super.key, required this.patientId});

  @override
  State<PtsProposalsPage> createState() => _PtsProposalsPageState();
}

class _PtsProposalsPageState extends State<PtsProposalsPage> {
  bool _isLoading = true;
  String? _error;
  List<PTSProposalDto> _proposals = [];
  String? _acceptedId;
  final Set<String> _rejectedIds = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await PtsService.getProposals(widget.patientId);
      if (!mounted) return;
      setState(() {
        _proposals = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _accept(PTSProposalDto proposal) async {
    final ok = await _confirm(
      title: 'Aceitar proposta',
      body: 'Ao aceitar esta equipe, todas as outras propostas serão automaticamente rejeitadas.',
      confirmLabel: 'Aceitar',
    );
    if (!ok) return;

    setState(() => _acceptedId = proposal.id);
    try {
      await PtsService.acceptProposal(proposal.id);
      if (!mounted) return;
      Navigator.pop(context); // ← volta para a tela anterior
    } catch (e) {
      if (!mounted) return;
      setState(() => _acceptedId = null);
      _snack(e.toString());
    }
  }


  Future<void> _reject(PTSProposalDto proposal) async {
    final ok = await _confirm(
      title: 'Rejeitar proposta',
      body: 'Tem certeza que deseja rejeitar esta proposta?',
      confirmLabel: 'Rejeitar',
      destructive: true,
    );
    if (!ok) return;

    setState(() => _rejectedIds.add(proposal.id));
    try {
      await PtsService.rejectProposal(widget.patientId, proposal.id);
    } catch (e) {
      if (!mounted) return;
      setState(() => _rejectedIds.remove(proposal.id));
      _snack(e.toString());
    }
  }

  Future<bool> _confirm({
    required String title,
    required String body,
    required String confirmLabel,
    bool destructive = false,
  }) async =>
      await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: TextButton.styleFrom(
                foregroundColor: destructive ? Colors.red : const Color(0xFFFFC200),
              ),
              child: Text(confirmLabel),
            ),
          ],
        ),
      ) ??
      false;

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MainAppBar(title: 'Propostas de PTS', showBackButton: true),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFFC200)))
          : _error != null
              ? _ErrorState(message: _error!, onRetry: _load)
              : _proposals.isEmpty
                  ? const Center(child: Text('Nenhuma proposta disponível.'))
                  : _Body(
                      proposals: _proposals,
                      acceptedId: _acceptedId,
                      rejectedIds: _rejectedIds,
                      onAccept: _accept,
                      onReject: _reject,
                      onLoadMore: _load,
                    ),
    );
  }
}

class _Body extends StatelessWidget {
  final List<PTSProposalDto> proposals;
  final String? acceptedId;
  final Set<String> rejectedIds;
  final ValueChanged<PTSProposalDto> onAccept;
  final ValueChanged<PTSProposalDto> onReject;
  final VoidCallback onLoadMore;

  const _Body({
    required this.proposals,
    required this.acceptedId,
    required this.rejectedIds,
    required this.onAccept,
    required this.onReject,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const SizedBox(height: 4),

        // Texto introdutório
        const Text(
          'Ao aceitar uma equipe multidisciplinar, estes poderão iniciar o planejamento do seu projeto terapêutico singular.',
          style: TextStyle(fontSize: 14, color: Color(0xFF333333), height: 1.55),
        ),
        const SizedBox(height: 14),

        // Alerta amarelo
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFEEF5FF),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: Color(0xFFFFC200), size: 20),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Ao aceitar uma proposta, todas as outras serão automaticamente rejeitadas.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF1A56A0),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),

        // Lista de propostas
        ...proposals.map((p) {
          final isAccepted = acceptedId == p.id;
          final isRejected = rejectedIds.contains(p.id) ||
              (acceptedId != null && acceptedId != p.id);

          return _ProposalTile(
            proposal: p,
            isAccepted: isAccepted,
            isRejected: isRejected,
            onAccept: () => onAccept(p),
            onReject: () => onReject(p),
          );
        }),

        // Carregar mais
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: _PillButton(
            label: 'Carregar mais',
            onPressed: onLoadMore,
          ),
        ),
        const SizedBox(height: 28),
      ],
    );
  }
}


class _ProposalTile extends StatelessWidget {
  final PTSProposalDto proposal;
  final bool isAccepted;
  final bool isRejected;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const _ProposalTile({
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
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 16),

          // Cabeçalho
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Avatar(avatarUrl: proposal.responsibleAvatarUrl),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${proposal.responsibleName}\n(${proposal.responsibleRole})',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ],
          ),

          if (proposal.teamMembers.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text(
              'Equipe multidisciplinar',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            ...proposal.teamMembers.map(
              (m) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  '${m.name} (${m.role})',
                  style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
                ),
              ),
            ),
          ],

          const SizedBox(height: 14),

          // Ações
          _buildActions(),

          const SizedBox(height: 16),
        ],
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
        _PillButton(label: 'Escolher essa equipe', onPressed: onAccept),
        const SizedBox(height: 8),
        _PillOutlineButton(label: 'Rejeitar', onPressed: onReject),
      ],
    );
  }
}


class _Avatar extends StatelessWidget {
  final String? avatarUrl;
  const _Avatar({this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: avatarUrl != null
          ? Image.network(avatarUrl!,
              width: 50, height: 50, fit: BoxFit.cover)
          : Container(
              width: 50,
              height: 50,
              color: const Color(0xFFF3E9D6),
              child: const Icon(Icons.person, color: Color(0xFFB08850)),
            ),
    );
  }
}


class _PillButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _PillButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFC200),
          foregroundColor: Colors.black,
          elevation: 0,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

class _PillOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _PillOutlineButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black54,
          shape: const StadiumBorder(),
          side: const BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 13),
          textStyle: const TextStyle(fontSize: 15),
        ),
        child: Text(label),
      ),
    );
  }
}


class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 40, color: Colors.black26),
            const SizedBox(height: 12),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 16),
            _PillButton(label: 'Tentar novamente', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}