import 'package:flutter/material.dart';
import 'package:front_pi/theme/styles.dart';
import 'package:gap/gap.dart';

// --- CLASSE DE DADOS (MOCK) ---
class MockDocument {
  final String title;
  final String content;
  MockDocument({required this.title, required this.content});
}

void addActivityPanel(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Styles.bgColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),

    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: const SuggestActivityForm(),
    ),
  );
}

// --- O FORMULÁRIO (ESTADO) ---
class SuggestActivityForm extends StatefulWidget {
  const SuggestActivityForm({super.key});
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

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _submitActivity() {
    Navigator.pop(context);
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
              // Botão sem ícone, apenas texto direto
              child: const Text('adicionar', style: Styles.midSize),
            ),
          ],
        ),
        Gap(8),
        const Divider(
          height: 1,
        ), // Linha simples para separar o cabeçalho da lista
        Gap(8),

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
        onPressed: _submitActivity,
        style: Styles.buttonYellow,
        child: const Text('Salvar', style: Styles.midSizeBold),
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
