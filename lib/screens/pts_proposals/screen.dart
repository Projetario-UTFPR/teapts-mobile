import 'package:flutter/material.dart';
import 'package:front_pi/components/alert.dart';
import 'package:front_pi/components/buttons/primary_button.dart';
import 'package:front_pi/components/buttons/secondary_button.dart';
import 'package:front_pi/models/pts.dart';
import 'package:front_pi/screens/pts_proposals/proposal_tile.dart';
import 'package:front_pi/services/pts_service.dart';
import 'package:front_pi/theme/styles.dart';
import 'package:front_pi/widgets/mainAppBar.dart';

class PtsProposalsPage extends StatefulWidget {
  final String patientId;

  const PtsProposalsPage({super.key, required this.patientId});

  @override
  State<PtsProposalsPage> createState() => _PtsProposalsPageState();
}

class _PtsProposalsPageState extends State<PtsProposalsPage> {
  bool _isLoading = true;
  String? _error;
  final List<PTSProposalDto> _proposals = [];
  String? _acceptedId;
  final Set<String> _rejectedIds = {};
  bool _hasMore = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final (data, total) = await PtsService.getProposals(widget.patientId);

      if (!mounted) return;
      setState(() {
        _proposals.addAll(data);
        _hasMore = _proposals.length < total;
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
      body:
          'Ao aceitar esta equipe, todas as outras propostas serão automaticamente rejeitadas.',
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
          backgroundColor: Styles.bgColor,
          title: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Text(body, style: TextStyle(fontSize: 16)),
          actions: [
            SecondaryButton(
              onPressed: () => Navigator.pop(ctx, false),
              title: 'Cancelar',
            ),
            PrimaryButton(
              onPressed: () => Navigator.pop(ctx, true),
              title: confirmLabel,
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
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFC200)),
            )
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
              hasMore: _hasMore,
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
  final bool hasMore;
  final VoidCallback onLoadMore;

  const _Body({
    required this.proposals,
    required this.acceptedId,
    required this.rejectedIds,
    required this.onAccept,
    required this.onReject,
    required this.onLoadMore,
    required this.hasMore,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> proposalsTiles = [];

    for (final (index, proposal) in proposals.indexed) {
      final isLast = index == proposals.length - 1;

      final isAccepted = acceptedId == proposal.id;
      final isRejected =
          rejectedIds.contains(proposal.id) ||
          (acceptedId != null && acceptedId != proposal.id);

      proposalsTiles.add(
        ProposalTile(
          proposal: proposal,
          isAccepted: isAccepted,
          isRejected: isRejected,
          onAccept: () => onAccept(proposal),
          onReject: () => onReject(proposal),
        ),
      );

      if (!isLast) proposalsTiles.add(SizedBox(height: 24));
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const Text(
          'Ao aceitar uma equipe multidisciplinar, estes poderão iniciar o planejamento do seu projeto terapêutico singular.',
          style: TextStyle(fontSize: 16, color: Color(0xFF333333)),
        ),

        const SizedBox(height: 24),

        Alert(
          message:
              'Ao aceitar uma proposta, todas as outras serão automaticamente rejeitadas.',
        ),

        const SizedBox(height: 24),

        ...proposalsTiles,

        const SizedBox(height: 8),

        if (hasMore)
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(title: 'Carregar mais', onPressed: onLoadMore),
          ),

        const SizedBox(height: 24),
      ],
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
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 16),
            SecondaryButton(title: 'Tentar novamente', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
