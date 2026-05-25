import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:front_pi/services/auth_service.dart';
import 'package:front_pi/services/pts_service.dart';

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
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      );

  Widget _helperText(String text) => Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(
          text,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final profiles = _professionalProfiles;

    return Scaffold(
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.manage_accounts_outlined),
                      const SizedBox(width: 12),
                      Text(profiles.first['specialism'] ?? ''),
                    ],
                  ),
                )
              else
                DropdownButtonFormField<String>(
                  value: _selectedProfessionalId,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.manage_accounts_outlined),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                  items: profiles
                      .map((p) => DropdownMenuItem(
                            value: p['professionalId'] as String,
                            child: Text(p['specialism'] as String),
                          ))
                      .toList(),
                  onChanged: (v) =>
                      setState(() => _selectedProfessionalId = v),
                  validator: (v) =>
                      v == null ? 'Selecione um perfil' : null,
                ),

              _helperText(
                profiles.length > 1
                    ? 'Você possui múltiplos perfis profissionais. Selecione qual será responsável pelo PTS.'
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
                      hintText: 'Selecione o paciente',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: const OutlineInputBorder(),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                      errorText: fieldState.errorText,
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
                  decoration: const InputDecoration(
                    hintText: 'Selecione os profissionais',
                    prefixIcon: const Icon(Icons.group_outlined),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.arrow_drop_down),
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
                  subtitle: Text(p['specialism'] ?? ''),
                ),
                onSelected: (p) {
                  setState(() {
                    _selectedMultidisciplinaryTeam.add(p);
                    _teamController.clear();
                  });
                },
              ),

              if (_selectedMultidisciplinaryTeam.isNotEmpty)
                Wrap(
                  spacing: 8,
                  children: _selectedMultidisciplinaryTeam.map((p) {
                    return Chip(
                      label: Text('${p['name']} • ${p['specialism']}'),
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
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Obrigatório' : null,
              ),

              _gap(32),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC200),
                    foregroundColor: Colors.black,
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
                  icon: const Icon(Icons.add),
                  label: const Text('Criar proposta de plano'),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF000000),
                    side: const BorderSide(color: Color(0xFF000000)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}