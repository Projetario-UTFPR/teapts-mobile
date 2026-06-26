import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:front_pi/services/auth_service.dart';
import 'package:front_pi/services/document_service.dart';
import 'package:front_pi/theme/styles.dart';
import 'package:gap/gap.dart';
import 'package:front_pi/services/activity_service.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

Future<bool?> addActivityPanel(BuildContext context, String patientId) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Styles.bgColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SuggestActivityForm(patientId: patientId),
    ),
  );
}

class SuggestActivityForm extends StatefulWidget {
  final String patientId;

  const SuggestActivityForm({super.key, required this.patientId});

  @override
  State<SuggestActivityForm> createState() => _SuggestActivityFormState();
}

class _SuggestActivityFormState extends State<SuggestActivityForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _docController = TextEditingController();

  String _selectedFrequency = 'Semanal';
  final List<String> _frequencies = [
    'Diária',
    'Semanal',
    'Quinzenal',
    'Mensal',
    'Contínua',
  ];

  List<dynamic> _availableDocuments = [];
  final List<dynamic> _selectedDocuments = [];

  bool _isLoadingDocs = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadRecordDocuments();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _docController.dispose();
    super.dispose();
  }

  Future<void> _loadRecordDocuments() async {
    try {
      final docs = await DocumentService.getDocumentosDoProntuario(
        widget.patientId,
      );
      if (!mounted) return;
      setState(() {
        _availableDocuments = docs;
        _isLoadingDocs = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoadingDocs = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar prontuário: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  FrequencyDto _mapFrequencyToDto(String freq) {
    switch (freq) {
      case 'Diária':
        return FrequencyDto(
          times: 1,
          interval: 'day',
          durationValue: 1,
          durationUnit: 'month',
        );
      case 'Semanal':
        return FrequencyDto(
          times: 1,
          interval: 'week',
          durationValue: 1,
          durationUnit: 'month',
        );
      case 'Quinzenal':
        return FrequencyDto(
          times: 1,
          interval: 'week',
          durationValue: 2,
          durationUnit: 'month',
        );
      case 'Mensal':
        return FrequencyDto(
          times: 1,
          interval: 'month',
          durationValue: 3,
          durationUnit: 'month',
        );
      case 'Contínua':
        return FrequencyDto(
          times: 1,
          interval: 'day',
          durationValue: 12,
          durationUnit: 'month',
        );
      default:
        return FrequencyDto(
          times: 1,
          interval: 'week',
          durationValue: 1,
          durationUnit: 'month',
        );
    }
  }

  void _submitActivity() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira um título.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final professionalId = AuthService.professionalId;

    if (professionalId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Erro: Profissional não identificado. Faça login novamente.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final List<String> docIdsToSubmit = _selectedDocuments
        .map((doc) => doc['id'] as String)
        .toList();

    final dto = CreateActivityDto(
      title: _titleController.text.trim(),
      professionalId: professionalId,
      documentsIds: docIdsToSubmit,
      frequency: _mapFrequencyToDto(_selectedFrequency),
    );

    final service = ActivityService();
    final errorMessage = await service.createActivity(widget.patientId, dto);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Atividade salva com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        color: Color(0xFF000000),
      ),
    ),
  );

  OutlineInputBorder _inputBorder() => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: Colors.black.withOpacity(0.10)),
  );

  OutlineInputBorder _inputBorderFocused() => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.black54),
  );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Adicionar atividade', style: Styles.midSizeBold),

          const Gap(24),
          _buildTitleInput(),
          const Gap(24),
          _buildFrequencyDropdown(),
          const Gap(24),
          _buildDocumentSection(),
          const Gap(32),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildTitleInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Título da atividade'),
        TextField(
          controller: _titleController,
          decoration: InputDecoration(
            fillColor: const Color(0xFFFFFFFF),
            filled: true,
            hintText: 'Ex: Sessão de fonoaudiologia',
            hintStyle: const TextStyle(color: Color(0xFF000000), fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 12.0, right: 6.0),
              child: PhosphorIcon(
                PhosphorIconsRegular.textT,
                size: 20,
                color: Color(0xFF555555),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            border: _inputBorder(),
            enabledBorder: _inputBorder(),
            focusedBorder: _inputBorderFocused(),
          ),
        ),
      ],
    );
  }

  Widget _buildFrequencyDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Frequência'),
        DropdownButtonFormField<String>(
          value: _selectedFrequency,
          decoration: InputDecoration(
            fillColor: const Color(0xFFFFFFFF),
            filled: true,
            hintText: 'Selecione a frequência',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 12.0, right: 6.0),
              child: PhosphorIcon(
                PhosphorIconsRegular.clock,
                size: 20,
                color: Color(0xFF555555),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            suffixIcon: const Padding(
              padding: EdgeInsets.only(right: 12.0),
              child: PhosphorIcon(
                PhosphorIconsRegular.caretDown,
                size: 16,
                color: Color(0xFF999999),
              ),
            ),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            border: _inputBorder(),
            enabledBorder: _inputBorder(),
            focusedBorder: _inputBorderFocused(),
          ),
          items: _frequencies
              .map((f) => DropdownMenuItem(value: f, child: Text(f)))
              .toList(),
          onChanged: (val) => setState(() => _selectedFrequency = val!),
        ),
      ],
    );
  }

  Widget _buildDocumentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Vincular Documentos do Prontuário'),

        if (_isLoadingDocs)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_availableDocuments.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'O paciente não possui documentos no prontuário.',
              style: Styles.midSize,
            ),
          )
        else ...[
          TypeAheadField<dynamic>(
            controller: _docController,
            builder: (context, controller, focusNode) => TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                fillColor: const Color(0xFFFFFFFF),
                filled: true,
                hintText: 'Buscar documento...',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 12.0, right: 6.0),
                  child: PhosphorIcon(
                    PhosphorIconsRegular.file,
                    size: 20,
                    color: Color(0xFF555555),
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 0,
                  minHeight: 0,
                ),
                border: _inputBorder(),
                enabledBorder: _inputBorder(),
                focusedBorder: _inputBorderFocused(),
              ),
            ),
            suggestionsCallback: (search) {
              return _availableDocuments.where((doc) {
                final docTitle = (doc['title'] ?? '').toString().toLowerCase();
                final searchTerm = search.toLowerCase();
                final alreadySelected = _selectedDocuments.any(
                  (selected) => selected['id'] == doc['id'],
                );

                return !alreadySelected && docTitle.contains(searchTerm);
              }).toList();
            },
            emptyBuilder: (context) => const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Nenhum documento encontrado.'),
            ),
            itemBuilder: (context, doc) => ListTile(
              leading: const PhosphorIcon(
                PhosphorIconsRegular.fileText,
                color: Color(0xFF555555),
              ),
              title: Text(doc['title'] ?? 'Documento sem título'),
            ),
            onSelected: (doc) {
              setState(() {
                _selectedDocuments.add(doc);
                _docController.clear();
              });
            },
          ),

          const Gap(4),
          const Text(
            'Selecione os arquivos para anexar a esta atividade.',
            style: TextStyle(fontSize: 12, color: Color(0xFF555555)),
          ),

          if (_selectedDocuments.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selectedDocuments.map((doc) {
                return Chip(
                  backgroundColor: Colors.black.withOpacity(0.05),
                  side: BorderSide.none,
                  label: Text(
                    doc['title'] ?? 'Documento sem título',
                    style: const TextStyle(fontSize: 16),
                  ),
                  onDeleted: () => setState(() {
                    _selectedDocuments.remove(doc);
                  }),
                );
              }).toList(),
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitActivity,
        style: Styles.buttonYellow,
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 2,
                ),
              )
            : const Text('Salvar', style: Styles.midSizeBold),
      ),
    );
  }
}
