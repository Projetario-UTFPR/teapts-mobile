import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:front_pi/services/auth_service.dart';
import 'package:front_pi/services/pts_service.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

const Map<String, String> specialtyLabels = {
  'PSYCHOLOGIST': 'Psicólogo(a)',
  'PSYCHIATRIST': 'Psiquiatra',
  'SOCIAL_WORKER': 'Assistente Social',
  'OCCUPATIONAL_THERAPIST': 'Terapeuta Ocupacional',
  'NURSE': 'Enfermeiro(a)',
  'PHYSICIAN': 'Médico(a)',
  'PHYSIOTHERAPIST': 'Fisioterapeuta',
  'SPEECH_THERAPIST': 'Fonoaudiólogo(a)',
  'NUTRITIONIST': 'Nutricionista',
  'PHARMACIST': 'Farmacêutico(a)',
};

String _translateSpecialism(String? raw) {
  return specialtyLabels[raw?.toUpperCase()] ?? 'Outro';
}

OutlineInputBorder _inputBorder() => OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.black.withOpacity(0.10)),
    );

InputDecoration _inputDecoration({
  String? hintText,
  Widget? prefixIcon,
  Widget? suffixIcon,
  String? errorText,
}) =>
    InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Color(0xFF000000), fontSize: 14),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      errorText: errorText,
      border: _inputBorder(),
      enabledBorder: _inputBorder(),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.black54),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );


class CreatePtsPage extends StatefulWidget {
  const CreatePtsPage({super.key});

  @override
  State<CreatePtsPage> createState() => _CreatePtsPageState();
}

class _CreatePtsPageState extends State<CreatePtsPage> {
  final _formKey = GlobalKey<FormState>();

  final _socialSituationController = TextEditingController();
  final _patientController = TextEditingController();
  final _teamController = TextEditingController();

  List<Map<String, dynamic>> _professionals = [];

  Map<String, String>? _selectedPatient;

  final List<Map<String, dynamic>> _selectedMultidisciplinaryTeam = [];

  final List<Map<String, String>> _patients = [
    {'id': '019e0600-0000-7000-8000-000000000001', 'name': 'João Silva'},
    {'id': '019e0600-0000-7000-8000-000000000002', 'name': 'Maria Santos'},
    {'id': '019e0600-0000-7000-8000-000000000003', 'name': 'Carlos Pereira'},
  ];

  List<Map<String, dynamic>> get _professionalProfiles =>
      AuthService.professionalProfiles;

  String? _selectedProfessionalId;

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
      Navigator.pop(context);
    });
    return;
  }

  if (profiles.length == 1) {
    _selectedProfessionalId = profiles.first['professionalId'] as String;
  }

  await loadProfessionals();

  if (mounted) setState(() {});
}

  Future<void> loadProfessionals() async {
    try {
      final list = await PtsService.getProfessionals();
      setState(() {
        _professionals = list;
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _socialSituationController.dispose();
    _patientController.dispose();
    _teamController.dispose();
    super.dispose();
  }

  Widget _gap([double height = 24]) => SizedBox(height: height);

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15,
          color: Color(0xFF000000),)
        ),
      );

  Widget _helperText(String text) => Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(
          text,
          style: TextStyle(fontSize: 12, color: Color(0xFF000000)),
        ),
      );


  @override
  Widget build(BuildContext context) {
    final profiles = _professionalProfiles;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        title: const Text('PTS :: criar'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Criar Plano Terapêutico Singular',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              _gap(),

              _sectionTitle('Seu perfil profissional'),

              if (profiles.isEmpty)
                const Text('Nenhum perfil profissional encontrado.')
              else if (profiles.length == 1)
                Container(
                  height: 48, 
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black.withOpacity(0.10),
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFFFFFFFF),
                  ),
                  child: Row(
                    children: [
                      PhosphorIcon(
                        PhosphorIconsRegular.userList,
                        size: 20,
                        color: const Color(0xFF555555),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _translateSpecialism(
                          profiles.first['specialism'] ?? '',
                        ),
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
                    horizontal: 16,
                    vertical: 8,
                  ),

                  prefixIcon: const Icon(
                    Icons.manage_accounts_outlined,
                    color: Color(0xFF555555),
                  ),

                  suffixIcon: const Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xFF999999),
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.black.withOpacity(0.10),
                    ),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.black.withOpacity(0.10),
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xFF555555),
                    ),
                  ),
                ),

                items: profiles
                    .map(
                      (p) => DropdownMenuItem(
                        value: p['professionalId'] as String,
                        child: Text(
                          _translateSpecialism(
                            p['specialism'] ?? '',
                          ),
                        ),
                      ),
                    )
                    .toList(),

                onChanged: (v) =>
                    setState(() => _selectedProfessionalId = v),

                validator: (v) =>
                    v == null ? 'Selecione um perfil' : null,
              ),

              _helperText(
                profiles.length > 1
                    ? 'Você possui múltiplos perfis profissionais. Selecione um deles para ser assinalado como o responsável por esse PTS.'
                    : 'Perfil profissional definido automaticamente.',
              ),

              _gap(),

             _sectionTitle('Paciente'),
              FormField<Map<String, String>>(
                validator: (_) =>
                    _selectedPatient == null ? 'Selecione um paciente' : null,
                builder: (fieldState) => TypeAheadField<Map<String, String>>(
                  controller: _patientController,

                  builder: (context, controller, focusNode) => TextField(
                    controller: controller,
                    focusNode: focusNode,

                    decoration: InputDecoration(
                      fillColor: const Color(0xFFFFFFFF),
                        filled: true,
                      hintText: 'Selecione o paciente',

                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),

                      prefixIcon: PhosphorIcon(
                        PhosphorIconsRegular.personSimpleCircle,
                        size: 20,
                        color: const Color(0xFF555555),
                      ),

                      suffixIcon: PhosphorIcon(
                        PhosphorIconsRegular.caretDown,
                        size: 16,
                        color: const Color(0xFF999999),
                      ),

                      errorText: fieldState.errorText,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.black.withOpacity(0.10),
                        ),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.black.withOpacity(0.10),
                        ),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFF555555),
                        ),
                      ),
                    ),
                  ),

                  suggestionsCallback: (search) => _patients
                      .where((p) => p['name']!
                          .toLowerCase()
                          .contains(search.toLowerCase()))
                      .toList(),

                  itemBuilder: (context, p) => ListTile(
                    title: Text(p['name']!),
                  ),

                  onSelected: (p) {
                    setState(() {
                      _selectedPatient = p;
                      _patientController.text = p['name']!;
                    });

                    fieldState.didChange(p);
                  },
                ),
              ),

              _gap(),

              _sectionTitle('Equipe multidisciplinar (opcional)'),

                TypeAheadField<Map<String, dynamic>>(
                  controller: _teamController,

                  builder: (context, controller, focusNode) => TextField(
                    controller: controller,
                    focusNode: focusNode,

                    decoration: InputDecoration(
                      fillColor: const Color(0xFFFFFFFF),
                        filled: true,
                      hintText: 'Selecione os profissionais',

                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),

                      prefixIcon: PhosphorIcon(
                        PhosphorIconsRegular.usersFour,
                        size: 20,
                        color: const Color(0xFF555555),
                      ),

                      suffixIcon: PhosphorIcon(
                        PhosphorIconsRegular.caretDown,
                        size: 16,
                        color: const Color(0xFF999999),
                      ),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.black.withOpacity(0.10),
                        ),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.black.withOpacity(0.10),
                        ),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFF555555),
                        ),
                      ),
                    ),
                  ),

                  suggestionsCallback: (search) => _professionals
                      .where((p) =>
                          !_selectedMultidisciplinaryTeam
                              .any((e) => e['id'] == p['id']) &&
                          ((p['name'] ?? '')
                                  .toLowerCase()
                                  .contains(search.toLowerCase()) ||
                              (p['specialism'] ?? '')
                                  .toLowerCase()
                                  .contains(search.toLowerCase())))
                      .toList(),

                  itemBuilder: (context, p) => ListTile(
                    title: Text(p['name'] ?? ''),
                    subtitle: Text(
                      _translateSpecialism(p['specialism']),
                    ),
                  ),

                  onSelected: (p) {
                    setState(() {
                      _selectedMultidisciplinaryTeam.add(p);
                      _teamController.clear();
                    });
                  },
                ),
                _helperText(
                  'Você poderá adicionar ou remover os profissionais da equipe multidisciplinar posteriormente.',
                ),

                if (_selectedMultidisciplinaryTeam.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _selectedMultidisciplinaryTeam.map((p) {
                      return Chip(
                        label: Text(
                          '${p['name']} • ${_translateSpecialism(p['specialism'])}',
                        ),
                        onDeleted: () => setState(() {
                          _selectedMultidisciplinaryTeam.remove(p);
                        }),
                      );
                    }).toList(),
                  ),

                _gap(),

                _sectionTitle('Situação social'),
                TextFormField(
                  controller: _socialSituationController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    fillColor: const Color(0xFFFFFFFF),
                        filled: true,
                    hintText:
                    'Descreva detalhes da situação social do paciente.',
                  hintStyle: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 14,
                  ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.black.withOpacity(0.10),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFF555555),
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty
                          ? 'Obrigatório'
                          : null,
                ),

                _helperText(
                  'Você poderá alterar essa descrição a qualquer momento.',
                ),

                _gap(32),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC200),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),    
                  ),
                  onPressed: () async {
                    if (!(_formKey.currentState?.validate() ?? false)) return;

                    await PtsService.createPts(
                      professionalId: _selectedProfessionalId!,
                      patientId: _selectedPatient!['id']!,
                      socialSituation: _socialSituationController.text,
                      multidisciplinaryTeamIds:
                          _selectedMultidisciplinaryTeam
                              .map((e) => e['id'] as String)
                              .toList(),
                    );

                    if (!mounted) return;
                    Navigator.pop(context);
                  },
                 icon: PhosphorIcon(PhosphorIconsBold.plus,
                      size: 18, color: Colors.black),
                  label: const Text(
                    'Criar proposta de plano',
                  ),
                ),
              ),

              const SizedBox(height: 12),

               SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: BorderSide(
                      color: Colors.black.withOpacity(0.10),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
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
}