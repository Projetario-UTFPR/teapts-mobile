import 'package:flutter/material.dart';
import 'package:front_pi/components/buttons/primary_button.dart';
import 'package:front_pi/services/auth_service.dart';
import 'package:front_pi/widgets/document_card.dart';
import 'package:front_pi/widgets/mainAppBar.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:front_pi/models/prontuario_document.dart';
import 'package:front_pi/services/prontuario_service.dart';

class ProntuarioPage extends StatefulWidget {
  final String patientId;

  const ProntuarioPage({super.key, required this.patientId});

  @override
  State<ProntuarioPage> createState() => _ProntuarioPageState();
}

class _ProntuarioPageState extends State<ProntuarioPage> {
  static const int _pageSize = 4;

  final List<ProntuarioDocument> _documents = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMore();
  }

  Future<void> _loadMore() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final (newDocs, totalElements) = await ProntuarioService.getDocuments(
        patientId: widget.patientId,
        page: _currentPage,
        limit: _pageSize,
      );

      setState(() {
        _documents.addAll(newDocs);
        _currentPage++;
        _hasMore = (_currentPage - 1) * _pageSize < totalElements;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _documents.clear();
      _currentPage = 1;
      _hasMore = true;
      _error = null;
    });
    await _loadMore();
  }

  @override
  Widget build(BuildContext context) {
    final isProfessional =
        !(AuthService.authCollection?.professionalProfiles.isEmpty ?? true);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MainAppBar(
        title: 'Prontuário',
        showBackButton: true,
        actions: [
          if (isProfessional)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => context.push(
                  '/upload-doc/${widget.patientId}',
                  extra: widget.patientId,
                ),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFC200),
                    shape: BoxShape.circle,
                  ),
                  child: PhosphorIcon(
                    PhosphorIconsBold.plus,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _documents.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFFFC200)),
      );
    }

    if (_error != null && _documents.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.red),
              ),
              const SizedBox(height: 16),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC200),
                  foregroundColor: Colors.black,
                ),
                onPressed: _loadMore,
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    if (_documents.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.folder_open_outlined,
              size: 56,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            const Text(
              'Nenhum documento encontrado.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: const Color(0xFFFFC200),
      onRefresh: _refresh,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _documents.length + (_hasMore ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == _documents.length) {
            return SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                onPressed: _isLoading ? null : _loadMore,
                isLoading: _isLoading,
                title: 'Carregar mais documentos',
              ),
            );
          }

          return DocumentoCard(document: _documents[index]);
        },
      ),
    );
  }
}
