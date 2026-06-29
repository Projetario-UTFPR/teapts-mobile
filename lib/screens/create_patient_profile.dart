import 'package:flutter/material.dart';
import 'package:front_pi/widgets/mainAppBar.dart';
import 'package:front_pi/services/patient_service.dart';
import 'package:front_pi/services/pts_service.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:front_pi/widgets/swipe_to_reveal_delete.dart';

OutlineInputBorder _inputBorder() => OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.black.withOpacity(0.10)),
    );

OutlineInputBorder _inputBorderFocused() => OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.black54),
    );

class CreatePatientProfilePage extends StatefulWidget {
  const CreatePatientProfilePage({super.key});

  @override
  State<CreatePatientProfilePage> createState() =>
      _CreatePatientProfilePageState();
}

class _CreatePatientProfilePageState extends State<CreatePatientProfilePage> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedAccountId;
  List<Map<String, dynamic>> _professionals = [];
  bool _isLoadingAccounts = true;

  final List<Map<String, TextEditingController>> _supportContacts = [];

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    try {
      final list = await PtsService.getProfessionals();
      setState(() {
        _professionals = list;
        _isLoadingAccounts = false;
      });
    } catch (e) {
      setState(() => _isLoadingAccounts = false);
    }
  }

  @override
  void dispose() {
    for (final contact in _supportContacts) {
      for (final controller in contact.values) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  void _addContact() {
    setState(() {
      _supportContacts.add({
        'name': TextEditingController(),
        'description': TextEditingController(),
        'phone': TextEditingController(),
        'email': TextEditingController(),
      });
    });
  }

  void _removeContact(int index) {
    setState(() {
      for (final controller in _supportContacts[index].values) {
        controller.dispose();
      }
      _supportContacts.removeAt(index);
    });
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

  Future<void> _submit() async {
    if (_selectedAccountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma conta')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final supportContacts = _supportContacts
          .where((c) => c['name']!.text.isNotEmpty)
          .map((c) => {
                'name': c['name']!.text,
                'description': c['description']!.text,
                'phone': c['phone']!.text,
                'email': c['email']!.text,
              })
          .toList();

      await PatientService.createPatientProfile(
        accountId: _selectedAccountId!,
        supportContacts: supportContacts,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil de paciente criado com sucesso')),
      );
      context.go('/home');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: MainAppBar(
        title: 'Criar Perfil de Paciente',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Conta'),
              _isLoadingAccounts
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.amber),
                    )
                  : DropdownButtonFormField<String>(
                      value: _selectedAccountId,
                      decoration: InputDecoration(
                        hintText: 'Selecione a conta',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        prefixIcon: _prefixIcon(
                          PhosphorIcon(
                            PhosphorIconsRegular.userList,
                            size: 20,
                            color: const Color(0xFF555555),
                          ),
                        ),
                        prefixIconConstraints:
                            const BoxConstraints(minWidth: 0, minHeight: 0),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: PhosphorIcon(
                            PhosphorIconsRegular.caretDown,
                            size: 16,
                            color: const Color(0xFF999999),
                          ),
                        ),
                        suffixIconConstraints:
                            const BoxConstraints(minWidth: 0, minHeight: 0),
                        border: _inputBorder(),
                        enabledBorder: _inputBorder(),
                        focusedBorder: _inputBorderFocused(),
                      ),
                      items: _professionals
                          .map((p) => DropdownMenuItem(
                                value: p['accountId'] as String,
                                child: Text(p['name'] as String),
                              ))
                          .toList(),
                      onChanged: (v) =>
                          setState(() => _selectedAccountId = v),
                      validator: (v) =>
                          v == null ? 'Selecione uma conta' : null,
                    ),
              _helperText(
                'Selecione a conta à qual o perfil de paciente será associada. Contas que já são pacientes não são listadas.',
              ),
              _gap(),

              _sectionTitle('Contatos de suporte (opcional)'),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: BorderSide(color: Colors.black.withOpacity(0.10)),
                  ),
                  onPressed: _addContact,
                  child: const Text(
                    'Adicionar novo contato',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              _gap(16),

            ..._supportContacts.asMap().entries.map((entry) {
              final index = entry.key;
              final contact = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SwipeToRevealDelete(
                  onDelete: () => _removeContact(index),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: contact['name'],
                          decoration: const InputDecoration(
                            isDense: true,
                            hintText: 'Nome do contato',
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: contact['description'],
                          maxLines: 2,
                          decoration: const InputDecoration(
                            isDense: true,
                            hintText: 'Descrição',
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            PhosphorIcon(PhosphorIconsRegular.envelopeSimple, size: 16),
                            const SizedBox(width: 6),
                            Expanded(
                              child: TextFormField(
                                controller: contact['email'],
                                decoration: const InputDecoration(
                                  isDense: true,
                                  hintText: 'email@exemplo.com',
                                  border: InputBorder.none,
                                ),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            PhosphorIcon(PhosphorIconsRegular.phone, size: 16),
                            const SizedBox(width: 6),
                            Expanded(
                              child: TextFormField(
                                controller: contact['phone'],
                                decoration: const InputDecoration(
                                  isDense: true,
                                  hintText: '(00) 00000-0000',
                                  border: InputBorder.none,
                                ),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),

              _gap(32),

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
                  onPressed: _isSubmitting ? null : _submit,
                  icon: PhosphorIcon(
                    PhosphorIconsBold.plus,
                    size: 18,
                    color: Colors.black,
                  ),
                  label: const Text('Criar perfil de paciente'),
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
                  onPressed: () => context.go('/home'),
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