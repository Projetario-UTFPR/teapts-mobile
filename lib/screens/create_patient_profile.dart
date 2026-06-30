import 'package:flutter/material.dart';
import 'package:front_pi/components/buttons/primary_button.dart';
import 'package:front_pi/components/buttons/secondary_button.dart';
import 'package:front_pi/theme/styles.dart';
import 'package:front_pi/widgets/mainAppBar.dart';
import 'package:front_pi/widgets/swipe_to_reveal_delete.dart';
import 'package:front_pi/services/patient_service.dart';
import 'package:front_pi/services/identity_service.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

OutlineInputBorder _inputBorder() => OutlineInputBorder(
  borderRadius: BorderRadius.circular(8),
  borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.10)),
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
  List<Map<String, dynamic>> _availableAccounts = [];
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
      final list = await IdentityService.getNonPatientAccounts();
      setState(() {
        _availableAccounts = list;
        _isLoadingAccounts = false;
      });
    } catch (e) {
      setState(() => _isLoadingAccounts = false);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao carregar contas: $e')));
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
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedAccountId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Selecione uma conta')));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final supportContacts = _supportContacts
          .where((c) => c['name']!.text.isNotEmpty)
          .map(
            (c) => {
              'name': c['name']!.text,
              'description': c['description']!.text,
              'phone': c['phone']!.text,
              'email': c['email']!.text,
            },
          )
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
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
                      isExpanded: true,
                      initialValue: _selectedAccountId,
                      decoration: InputDecoration(
                        hintText: 'Selecione a conta',
                        // just need to reset it
                        contentPadding: const EdgeInsets.symmetric(),
                        prefixIcon: _prefixIcon(
                          PhosphorIcon(
                            PhosphorIconsRegular.userList,
                            size: 20,
                            color: Styles.gray500,
                          ),
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 0,
                          minHeight: 0,
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: PhosphorIcon(
                            PhosphorIconsRegular.caretDown,
                            size: 16,
                            color: const Color(0xFF999999),
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
                      items: _availableAccounts
                          .map(
                            (a) => DropdownMenuItem(
                              value: a['id'] as String,
                              child: Text(a['name'] as String),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _selectedAccountId = v),
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
                child: SecondaryButton(
                  onPressed: _addContact,
                  title: 'Adicionar novo contato',
                ),
              ),

              _gap(8),
              Divider(color: Colors.black.withValues(alpha: 0.1)),
              if (_supportContacts.isNotEmpty) _gap(8),

              ..._supportContacts.asMap().entries.map((entry) {
                final index = entry.key;
                final contact = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SwipeToRevealDelete(
                    onDelete: () => _removeContact(index),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xffededed),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: contact['name'],
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              isDense: true,
                              hintText: 'Nome do contato',
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          TextFormField(
                            controller: contact['description'],
                            maxLines: 4,
                            minLines: 1,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              isDense: true,
                              hintText: 'Descrição',
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Row(
                            spacing: 8,
                            children: [
                              PhosphorIcon(
                                PhosphorIconsRegular.envelopeSimple,
                                color: Styles.gray500,
                                size: 20,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: contact['email'],
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.all(0),
                                    isDense: true,
                                    hintText: 'email@exemplo.com',
                                    border: InputBorder.none,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            spacing: 8,
                            children: [
                              PhosphorIcon(
                                PhosphorIconsRegular.phone,
                                color: Styles.gray500,
                                size: 20,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: contact['phone'],
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.all(0),
                                    isDense: true,
                                    hintText: '(00) 00000-0000',
                                    border: InputBorder.none,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
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

              _gap(24),

              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  onPressed: _isSubmitting ? null : _submit,
                  icon: PhosphorIconsBold.plus,
                  title: 'Criar perfil de paciente',
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: SecondaryButton(
                  onPressed: () => context.go('/home'),
                  title: 'Cancelar',
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
