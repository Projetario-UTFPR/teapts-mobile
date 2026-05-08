import 'package:flutter/material.dart';

class CreatePtsPage extends StatefulWidget {
  const CreatePtsPage({super.key});

  @override
  State<CreatePtsPage> createState() => _CreatePtsPageState();
}

class _CreatePtsPageState extends State<CreatePtsPage> {
  final _formKey = GlobalKey<FormState>();

  String _status = 'em construção';

  final _situacaoController = TextEditingController();
  final _objetivoController = TextEditingController();

  String? _idPaciente;
  String? _idTecnicoReferencia;

  final List<String> _equipeSelecionada = [];
  final List<Map<String, dynamic>> _acoes = [];

  final List<Map<String, String>> _pacientes = [
    {'id': '1', 'nome': 'João Silva'},
    {'id': '2', 'nome': 'Maria Santos'},
  ];

  final List<Map<String, String>> _profissionais = [
    {'id': '1', 'nome': 'Dr. Carlos', 'area': 'Medicina'},
    {'id': '2', 'nome': 'Dra. Ana', 'area': 'Enfermagem'},
    {'id': '3', 'nome': 'João Lima', 'area': 'Psicologia'},
    {'id': '4', 'nome': 'Maria Costa', 'area': 'Serviço Social'},
  ];

  @override
  void dispose() {
    _situacaoController.dispose();
    _objetivoController.dispose();
    for (final acao in _acoes) {
      (acao['descricao'] as TextEditingController).dispose();
      (acao['prazo'] as TextEditingController).dispose();
    }
    super.dispose();
  }

  Future<void> _selecionarData(BuildContext context, int index) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        (_acoes[index]['prazo'] as TextEditingController).text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  void _adicionarAcao() {
    setState(() {
      _acoes.add({
        'descricao': TextEditingController(),
        'prazo': TextEditingController(),
        'status': 'pendente',
      });
    });
  }

  void _removerAcao(int index) {
    setState(() {
      (_acoes[index]['descricao'] as TextEditingController).dispose();
      (_acoes[index]['prazo'] as TextEditingController).dispose();
      _acoes.removeAt(index);
    });
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
                    _sectionTitle('Identificação'),
                    DropdownButtonFormField<String>(
                      value: _status,
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        prefixIcon: Icon(Icons.flag_outlined),
                        border: OutlineInputBorder(),
                      ),
                      items: ['em construção', 'ativo', 'finalizado']
                          .map((s) =>
                              DropdownMenuItem(value: s, child: Text(s)))
                          .toList(),
                      onChanged: (v) => setState(() => _status = v!),
                    ),
                    _gap(),
                    _sectionTitle('Conteúdo Clínico'),
                    TextFormField(
                      controller: _situacaoController,
                      decoration: const InputDecoration(
                        labelText: 'Condições de vida e fatores de risco',
                        hintText: 'Descreva a situação',
                        prefixIcon: Icon(Icons.warning_amber_outlined),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Obrigatório' : null,
                    ),
                    _gap(),
                    TextFormField(
                      controller: _objetivoController,
                      decoration: const InputDecoration(
                        labelText: 'Objetivo geral',
                        hintText: 'Descreva o objetivo',
                        prefixIcon: Icon(Icons.track_changes_outlined),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Obrigatório' : null,
                    ),
                    _gap(),
                    _sectionTitle('Vinculações'),
                    DropdownButtonFormField<String>(
                      value: _idPaciente,
                      decoration: const InputDecoration(
                        labelText: 'Paciente',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      items: _pacientes
                          .map((p) => DropdownMenuItem(
                              value: p['id'], child: Text(p['nome']!)))
                          .toList(),
                      onChanged: (v) => setState(() => _idPaciente = v),
                      validator: (v) =>
                          v == null ? 'Selecione um paciente' : null,
                    ),
                    _gap(),
                    DropdownButtonFormField<String>(
                      value: _idTecnicoReferencia,
                      decoration: const InputDecoration(
                        labelText: 'Técnico de referência',
                        prefixIcon: Icon(Icons.badge_outlined),
                        border: OutlineInputBorder(),
                      ),
                      items: _profissionais
                          .map((p) => DropdownMenuItem(
                                value: p['id'],
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(p['nome']!),
                                    Text(p['area']!,
                                        style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey)),
                                  ],
                                ),
                              ))
                          .toList(),
                      onChanged: (v) =>
                          setState(() => _idTecnicoReferencia = v),
                      validator: (v) =>
                          v == null ? 'Selecione o técnico de referência' : null,
                    ),
                    _gap(),
                    _sectionTitle('Equipe envolvida (opcional)'),
                    ..._profissionais.map((p) => CheckboxListTile(
                          value: _equipeSelecionada.contains(p['id']),
                          onChanged: (checked) {
                            setState(() {
                              if (checked == true) {
                                _equipeSelecionada.add(p['id']!);
                              } else {
                                _equipeSelecionada.remove(p['id']);
                              }
                            });
                          },
                          title: Text(p['nome']!),
                          subtitle: Text(p['area']!),
                          controlAffinity: ListTileControlAffinity.leading,
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        )),
                    _gap(),
                    _sectionTitle('Ações iniciais (opcional)'),
                    ..._acoes.asMap().entries.map((entry) {
                      final i = entry.key;
                      final acao = entry.value;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: acao['descricao']
                                    as TextEditingController,
                                decoration: const InputDecoration(
                                  labelText: 'Descrição',
                                  border: OutlineInputBorder(),
                                ),
                                maxLines: 2,
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller:
                                    acao['prazo'] as TextEditingController,
                                decoration: const InputDecoration(
                                  labelText: 'Prazo estimado',
                                  border: OutlineInputBorder(),
                                  suffixIcon:
                                      Icon(Icons.calendar_today_outlined),
                                ),
                                readOnly: true,
                                onTap: () => _selecionarData(context, i),
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  onPressed: () => _removerAcao(i),
                                  icon: const Icon(Icons.delete_outline,
                                      color: Colors.red),
                                  label: const Text('Remover',
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _adicionarAcao,
                        icon: const Icon(Icons.add),
                        label: const Text('Adicionar ação'),
                      ),
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
                          if (!(_formKey.currentState?.validate() ?? false))
                            return;
                          // TODO: chamar PtsService
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text('Criar PTS',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
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
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
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