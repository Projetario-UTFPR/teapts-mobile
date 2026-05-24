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

  final _descricaoController = TextEditingController();
  final _pacienteController = TextEditingController();
  final _equipeController = TextEditingController();

  Map<String, String>? _pacienteSelecionado;
  final List<Map<String, String>> _equipeSelecionada = [];

final List<Map<String, String>> _pacientes = [
  {'id': '019e0600-0000-7000-8000-000000000001', 'nome': 'João Silva'},
  {'id': '019e0600-0000-7000-8000-000000000002', 'nome': 'Maria Santos'},
  {'id': '019e0600-0000-7000-8000-000000000003', 'nome': 'Carlos Pereira'},
];

  List<Map<String, String>> _profissionais = [];

@override
void initState() {
  super.initState();
  _carregarProfissionais();
}

Future<void> _carregarProfissionais() async {
  try {
    final lista = await PtsService.getProfissionais();
    setState(() => _profissionais = lista);
  } catch (e) {
    // Trata o erro, mas não lança exceção
  }
}


  @override
  void dispose() {
    _descricaoController.dispose();
    _pacienteController.dispose();
    _equipeController.dispose();
    super.dispose();
  }

  Widget _gap() => const SizedBox(height: 16);

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          elevation: 8,
          child: Container(
            padding: const EdgeInsets.all(32.0),
            constraints: const BoxConstraints(maxWidth: 350),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset('imagens/infinito_laranja.png',
                          width: 100),
                    ),
                    _gap(),
                    Center(
                      child: Text('Novo PTS',
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text('Preencha os dados do plano',
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center),
                      ),
                    ),
                    _gap(),

                    _sectionTitle('Paciente'),
                    FormField<Map<String, String>>(
                      validator: (_) => _pacienteSelecionado == null
                          ? 'Selecione um paciente'
                          : null,
                      builder: (fieldState) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TypeAheadField<Map<String, String>>(
                            controller: _pacienteController,
                            builder: (context, controller, focusNode) => TextField(
                              controller: controller,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                labelText: 'Paciente',
                                hintText: 'Digite para buscar',
                                suffixIcon: const Icon(Icons.arrow_drop_down),
                                prefixIcon: const Icon(Icons.person_outline),
                                border: const OutlineInputBorder(),
                                errorText: fieldState.errorText,
                              ),
                            ),
                            suggestionsCallback: (search) => _pacientes
                                .where((p) => p['nome']!
                                    .toLowerCase()
                                    .contains(search.toLowerCase()))
                                .toList(),
                            itemBuilder: (context, p) => ListTile(
                              leading: const Icon(Icons.person_outline),
                              title: Text(p['nome']!),
                            ),
                            onSelected: (p) {
                              setState(() {
                                _pacienteSelecionado = p;
                                _pacienteController.text = p['nome']!;
                              });
                              fieldState.didChange(p);
                            },
                          ),
                        ],
                      ),
                    ),
                    _gap(),

                    _sectionTitle('Equipe envolvida (opcional)'),
                    TypeAheadField<Map<String, String>>(
                      controller: _equipeController,
                      builder: (context, controller, focusNode) => TextField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                          labelText: 'Adicionar profissional',
                          hintText: 'Digite para buscar',
                          prefixIcon: Icon(Icons.group_outlined),
                          suffixIcon: Icon(Icons.arrow_drop_down),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      suggestionsCallback: (search) => _profissionais
                          .where((p) =>
                              !_equipeSelecionada
                                  .any((e) => e['id'] == p['id']) &&
                              (p['nome']!
                                      .toLowerCase()
                                      .contains(search.toLowerCase()) ||
                                  p['area']!
                                      .toLowerCase()
                                      .contains(search.toLowerCase())))
                          .toList(),
                      itemBuilder: (context, p) => ListTile(
                        leading: const Icon(Icons.badge_outlined),
                        title: Text(p['nome']!),
                        subtitle: Text(p['area']!),
                      ),
                      onSelected: (p) {
                        setState(() {
                          _equipeSelecionada.add(p);
                          _equipeController.clear();
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    if (_equipeSelecionada.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: _equipeSelecionada
                            .map((p) => Chip(
                                  label: Text(
                                      '${p['nome']} • ${p['area']}',
                                      style: const TextStyle(fontSize: 12)),
                                  onDeleted: () => setState(
                                      () => _equipeSelecionada.remove(p)),
                                ))
                            .toList(),
                      ),
                    _gap(),

                    _sectionTitle('Situação Social'),
                    TextFormField(
                      controller: _descricaoController,
                      decoration: const InputDecoration(
                        labelText: 'Situação Social',
                        hintText: 'Descreva a situação social do paciente...',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                      textAlignVertical: TextAlignVertical.top,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Obrigatório' : null,
                    ),
                    _gap(),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        onPressed: () async {
                          if (!(_formKey.currentState?.validate() ?? false)) return;
                          try {
                            await PtsService.createPts(
                              professionalId: AuthService.professionalId!,
                              patientId: _pacienteSelecionado!['id']!,
                              socialSituation: _descricaoController.text,
                              multidisciplinaryTeamIds:
                                  _equipeSelecionada.map((p) => p['id']!).toList(),
                            );

                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('PTS criado com sucesso')),
                            );
                            Navigator.pop(context);
                          } catch (e) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text('Criar PTS',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    _gap(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text('Cancelar',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}