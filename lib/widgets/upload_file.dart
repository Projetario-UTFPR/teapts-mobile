import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:front_pi/services/auth_service.dart';
import 'package:front_pi/services/document_service.dart';
import 'package:front_pi/theme/styles.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:go_router/go_router.dart';


const Map<String, String> specialityLabels = {
  'PSYCHOLOGIST': 'Psicólogo(a)',
  'PSYCHIATRIST': 'Psiquiatra',
  'SOCIAL_WORKER': 'Assistente Social',
  'OCCUPATIONAL_THERAPIST': 'Terapeuta Ocupacional',
  'NURSE': 'Enfermeiro(a)',
  'DOCTOR': 'Médico(a)',
  'PHYSIOTHERAPIST': 'Fisioterapeuta',
  'SPEECH_THERAPIST': 'Fonoaudiólogo(a)',
  'NUTRITIONIST': 'Nutricionista',
  'PHARMACIST': 'Farmacêutico(a)',
};

String _translateSpecialism(String? raw) {
  return specialityLabels[raw?.toUpperCase()] ?? 'Outro';
}

OutlineInputBorder _inputBorder() => OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.black.withOpacity(0.10)),
    );

OutlineInputBorder _inputBorderFocused() => OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.black54),
    );

OutlineInputBorder _inputBorderError() => OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.red),
    );

class UploadDocPage extends StatefulWidget {
  final String patientId;

  const UploadDocPage({super.key, required this.patientId});

  @override
  State<UploadDocPage> createState() => _UploadDocPageState();
}

class _UploadDocPageState extends State<UploadDocPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedProfessionalId;
  PlatformFile? _selectedFile;
  bool _isLoading = false;

  List<Map<String, dynamic>> get _professionalProfiles =>
      AuthService.professionalProfiles;

  @override
  void initState() {
    super.initState();
    _init();
  }

Future<void> _init() async {
  final profiles = _professionalProfiles;

  if (profiles.isEmpty) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sem perfil profissional ativo')),
      );
      // Só faz pop se tiver tela anterior
      if (Navigator.canPop(context)) Navigator.pop(context);
    });
    return;
  }

  if (profiles.length == 1) {
    _selectedProfessionalId = profiles.first['professionalId'] as String;
  }

  if (mounted) setState(() {});
}


  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg', 'doc', 'docx'],
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() => _selectedFile = result.files.first);
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um documento para enviar')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final description = _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim();

      await DocumentService.uploadDocument(
        patientId: widget.patientId,
        assigneeProfessionalId: _selectedProfessionalId!,
        documentTitle: _titleController.text.trim(),
        documentDescription: description,
        documentContent: _selectedFile!.bytes!,
        documentFileType: _selectedFile!.extension ?? 'application/octet-stream',
        documentFileName: _selectedFile!.name,
      );

      if (!mounted) return;
        context.pop();

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar documento: $e')),
      );
    } finally {
      if (mounted) 
      setState(() => _isLoading = false);
    }
  }

  Widget _gap([double height = 24]) => SizedBox(height: height);

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

  Widget _helperText(String text) => Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(
          text,
          style: const TextStyle(fontSize: 12, color: Color(0xFF000000)),
        ),
      );

  Widget _prefixIcon(Widget icon) => Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 6.0),
        child: icon,
      );

  InputDecoration _fieldDecoration({
    required String hint,
    required Widget icon,
    Widget? suffixIcon,
    String? errorText,
    bool filled = true,
  }) =>
      InputDecoration(
        fillColor: const Color(0xFFFFFFFF),
        filled: filled,
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF000000), fontSize: 14),
        prefixIcon: _prefixIcon(icon),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: suffixIcon,
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        errorText: errorText,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: _inputBorder(),
        enabledBorder: _inputBorder(),
        focusedBorder: _inputBorderFocused(),
        errorBorder: _inputBorderError(),
        focusedErrorBorder: _inputBorderError(),
      );

  // ── build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final profiles = _professionalProfiles;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 0,
      elevation: 0,
    ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
  Align(
    alignment: Alignment.centerLeft,
    child: IconButton(
      onPressed: _isLoading ? null : () => context.pop(),
      style: IconButton.styleFrom(
        backgroundColor: Styles.widgetYellow,
        padding: const EdgeInsets.all(0),
        shape: CircleBorder(),
      ),
      icon: PhosphorIcon(
        PhosphorIconsBold.arrowLeft,
        size: 24,
        color: Styles.widgetBlack,
      ),
    ),
  ),

        const SizedBox(height: 16),

        const Text(
          'Enviar Documento',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        _gap(),

              // ── Perfil profissional ────────────────────────────────────────
              _sectionTitle('Perfil profissional responsável'),

              if (profiles.isEmpty)
                const Text('Nenhum perfil profissional encontrado.')
              else if (profiles.length == 1)
                Container(
                  height: 48,
                  padding: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black.withOpacity(0.10)),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black.withOpacity(0.08),
                  ),
                  child: Row(
                    children: [
                      _prefixIcon(PhosphorIcon(
                        PhosphorIconsRegular.userList,
                        size: 20,
                        color: const Color(0xFF555555),
                      )),
                      Text(
                        _translateSpecialism(profiles.first['specialism'] ?? ''),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                )
              else
                DropdownButtonFormField<String>(
                  value: _selectedProfessionalId,
                  decoration: InputDecoration(
                    hintText: 'Selecione um perfil profissional',
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    prefixIcon: _prefixIcon(const Icon(
                      Icons.manage_accounts_outlined,
                      color: Color(0xFF555555),
                      size: 20,
                    )),
                    prefixIconConstraints:
                        const BoxConstraints(minWidth: 0, minHeight: 0),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: PhosphorIcon(PhosphorIconsRegular.caretDown,
                          size: 16, color: const Color(0xFF999999)),
                    ),
                    suffixIconConstraints:
                        const BoxConstraints(minWidth: 0, minHeight: 0),
                    border: _inputBorder(),
                    enabledBorder: _inputBorder(),
                    focusedBorder: _inputBorderFocused(),
                  ),
                  items: profiles
                      .map((p) => DropdownMenuItem(
                            value: p['professionalId'] as String,
                            child: Text(
                                _translateSpecialism(p['specialism'] ?? '')),
                          ))
                      .toList(),
                  onChanged: (v) =>
                      setState(() => _selectedProfessionalId = v),
                  validator: (v) =>
                      v == null ? 'Selecione um perfil' : null,
                ),

              _helperText(
                profiles.length > 1
                    ? 'Selecione o perfil que irá assinar o envio deste documento.'
                    : 'Perfil profissional definido automaticamente.',
              ),
              _gap(),

              // ── Título ─────────────────────────────────────────────────────
              _sectionTitle('Título do documento'),
              TextFormField(
                controller: _titleController,
                decoration: _fieldDecoration(
                  hint: 'Ex: Relatório de evolução — junho 2026',
                  icon: PhosphorIcon(PhosphorIconsRegular.textT,
                      size: 20, color: const Color(0xFF555555)),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Obrigatório' : null,
              ),
              _gap(),

              // ── Descrição (opcional) ───────────────────────────────────────
              _sectionTitle('Descrição (opcional)'),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  fillColor: const Color(0xFFFFFFFF),
                  filled: true,
                  hintText: 'Adicione uma descrição ou observação sobre o documento.',
                  hintStyle: const TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 14,
                  ),
                  border: _inputBorder(),
                  enabledBorder: _inputBorder(),
                  focusedBorder: _inputBorderFocused(),
                  contentPadding: const EdgeInsets.all(16),
                ),
                // sem validator — campo opcional, mas não enviamos string vazia (tratado no _submit)
              ),
              _helperText('Se não preenchida, a descrição não será enviada.'),
              _gap(),

              // ── Arquivo ────────────────────────────────────────────────────
              _sectionTitle('Documento'),
              GestureDetector(
                onTap: _pickFile,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(
                    color: _selectedFile != null
                        ? Colors.black.withOpacity(0.04)
                        : const Color(0xFFFFFFFF),
                    border: Border.all(
                      color: _selectedFile != null
                          ? Colors.black.withOpacity(0.30)
                          : Colors.black.withOpacity(0.10),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _selectedFile == null
                      ? Column(
                          children: [
                            PhosphorIcon(
                              PhosphorIconsRegular.uploadSimple,
                              size: 32,
                              color: const Color(0xFF999999),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Toque para selecionar um arquivo',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF555555),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'PDF, PNG, JPG, DOC, DOCX',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black.withOpacity(0.40),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            PhosphorIcon(
                              _fileIcon(_selectedFile!.extension),
                              size: 28,
                              color: const Color(0xFF555555),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedFile!.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _formatSize(_selectedFile!.size),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black.withOpacity(0.45),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () => setState(() => _selectedFile = null),
                              child: PhosphorIcon(
                                PhosphorIconsRegular.x,
                                size: 18,
                                color: const Color(0xFF999999),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              _helperText('Formatos aceitos: PDF, PNG, JPG, DOC, DOCX.'),
              _gap(48),

              // ── Botões ─────────────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC200),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: _isLoading ? null : _submit,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 32,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        )
                      : PhosphorIcon(PhosphorIconsBold.uploadSimple,
                          size: 18, color: Colors.black),
                  label: Text(_isLoading ? 'Enviando...' : 'Enviar documento'),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: BorderSide(color: Colors.black.withOpacity(0.10)),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: _isLoading ? null : () => context.pop(),
                  child: const Text('Cancelar'),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  IconData _fileIcon(String? ext) {
    switch (ext?.toLowerCase()) {
      case 'pdf':
        return PhosphorIconsRegular.filePdf;
      case 'png':
      case 'jpg':
      case 'jpeg':
        return PhosphorIconsRegular.fileImage;
      case 'doc':
      case 'docx':
        return PhosphorIconsRegular.fileDoc;
      default:
        return PhosphorIconsRegular.file;
    }
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}