import 'package:flutter/material.dart';
import 'package:front_pi/services/auth_service.dart';
import 'package:front_pi/theme/styles.dart';
import 'package:gap/gap.dart';
import 'package:front_pi/services/activity_service.dart';

class MockDocument {
  final String title;
  final String content;
  MockDocument({required this.title, required this.content});
}

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
  String _selectedFrequency = 'Semanal';
  final List<String> _frequencies = [
    'Diária',
    'Semanal',
    'Quinzenal',
    'Mensal',
    'Contínua',
  ];
  final List<MockDocument> _draftedDocuments = [];

  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
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

    final idProfissional = AuthService.professionalId;

    if (idProfissional == null) {
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

    final dto = CreateActivityDto(
      title: _titleController.text.trim(),
      professionalId: idProfissional,
      documentsIds: [],
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

  void _openDocumentCreator() async {
    final MockDocument? newDoc = await showDialog<MockDocument>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const CreateDocumentDialog(),
    );
    if (newDoc != null) setState(() => _draftedDocuments.add(newDoc));
  }

  //-------------------------------------------------------------------------------------
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
          const Gap(24),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildTitleInput() {
    return TextField(
      controller: _titleController,
      decoration: Styles.textFieldDefault(labelText: 'Título'),
    );
  }

  Widget _buildFrequencyDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedFrequency,
      decoration: Styles.textFieldDefault(labelText: 'Frequência'),
      items: _frequencies
          .map((f) => DropdownMenuItem(value: f, child: Text(f)))
          .toList(),
      onChanged: (val) => setState(() => _selectedFrequency = val!),
    );
  }

  Widget _buildDocumentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Documentos', style: Styles.midSize),
            TextButton(
              style: Styles.buttonYellow,
              onPressed: _openDocumentCreator,
              child: const Text('adicionar', style: Styles.midSize),
            ),
          ],
        ),
        const Gap(8),
        const Divider(height: 1),
        const Gap(8),

        if (_draftedDocuments.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Nenhum documento.', style: Styles.midSize),
          ),

        ..._draftedDocuments.map(
          (doc) => Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(doc.title, style: Styles.midSize),
                InkWell(
                  onTap: () => setState(() => _draftedDocuments.remove(doc)),
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text('Remover', style: Styles.midSize),
                  ),
                ),
              ],
            ),
          ),
        ),
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
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text('Salvar', style: Styles.midSizeBold),
      ),
    );
  }
}

class CreateDocumentDialog extends StatefulWidget {
  const CreateDocumentDialog({super.key});
  @override
  State<CreateDocumentDialog> createState() => _CreateDocumentDialogState();
}

class _CreateDocumentDialogState extends State<CreateDocumentDialog> {
  final TextEditingController _docTitleController = TextEditingController();
  final TextEditingController _docContentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Styles.bgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text('Criar Documento', style: Styles.midSizeBold),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _docTitleController,
              decoration: Styles.textFieldDefault(labelText: 'Título'),
            ),
            Gap(16),
            TextField(
              controller: _docContentController,
              maxLines: 5,
              decoration: Styles.textFieldDefault(labelText: 'Conteúdo'),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          style: Styles.buttonWhite,
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar', style: Styles.midSize),
        ),
        ElevatedButton(
          style: Styles.buttonYellow,
          onPressed: () {
            final newDoc = MockDocument(
              title: _docTitleController.text.isEmpty
                  ? 'Sem título'
                  : _docTitleController.text,
              content: _docContentController.text,
            );
            Navigator.pop(context, newDoc);
          },
          child: const Text('Salvar', style: Styles.midSizeBold),
        ),
      ],
    );
  }
}
