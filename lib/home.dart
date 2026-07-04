import 'package:flutter/material.dart';
import 'package:front_pi/components/buttons/primary_button.dart';
import 'package:front_pi/theme/styles.dart';
import 'package:front_pi/widgets/custom_row_item.dart';
import 'package:front_pi/services/auth_service.dart';
import 'package:front_pi/widgets/main_layout.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'services/pts_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoadingHome = true;
  bool _isPatient = false;
  bool _isProfessional = false;

  List<Map<String, dynamic>> _patients = [];
  int _page = 1;
  int _totalElements = 0;
  bool _isLoadingPatients = false;
  String? _error;

  void _onHasActivePtsChanged() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initHome();
    PtsStateNotifier.ptsState.addListener(_onHasActivePtsChanged);
  }

  @override
  void dispose() {
    super.dispose();
    PtsStateNotifier.ptsState.removeListener(_onHasActivePtsChanged);
  }

  Future<void> _initHome() async {
    setState(() => _isLoadingHome = true);

    final auth = AuthService.authCollection;

    _isPatient = auth?.isPatient ?? false;
    _isProfessional = auth?.professionalProfiles.isNotEmpty ?? false;

    try {
      if (_isProfessional) {
        await _loadPatients();
      }
    } catch (e) {
      debugPrint('Erro ao inicializar a home: $e');
    } finally {
      setState(() => _isLoadingHome = false);
    }
  }

  Future<void> _loadPatients({bool loadMore = false}) async {
    setState(() => _isLoadingPatients = true);

    try {
      final pageToLoad = loadMore ? _page + 1 : 1;
      final response = await PtsService.getMyPatients(page: pageToLoad);
      final items = (response['items'] as List).cast<Map<String, dynamic>>();

      setState(() {
        if (loadMore) {
          _patients.addAll(items);
          _page = pageToLoad;
        } else {
          _patients = items;
          _page = 1;
        }
        _totalElements = response['totalElements'] as int;
        _error = null;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoadingPatients = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fullName = AuthService.authCollection?.account.name ?? 'Usuário';
    final firstName = fullName.split(' ').first;

    return Scaffold(
      backgroundColor: Styles.bgColor,
      body: SafeArea(
        child: _isLoadingHome
            ? const Center(
                child: CircularProgressIndicator(color: Styles.widgetYellow),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        'Bem-vindo, $firstName!',
                        style: Styles.titlesBold,
                      ),
                    ),
                    const Gap(24),
                    if (_isPatient) _buildPatientSection(),
                    if (_isPatient && _isProfessional)
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.black.withValues(alpha: 0.1),
                        ),
                      ),
                    if (_isProfessional) _buildProfessionalSection(),
                    if (!_isPatient && !_isProfessional)
                      const Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Center(
                          child: Text(
                            'Você ainda não está cadastrado(a) como paciente. Aguarde até que seu perfil seja criado.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF313030),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildPatientSection() {
    final accountId = AuthService.authCollection?.account.id ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!PtsStateNotifier.ptsState.hasActivePts) ...[
            const Text(
              'Você ainda não tem nenhum Projeto Terapêutico Singular (PTS) ativo. Confira as propostas para iniciar o seu plano!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF313030),
                height: 1.2,
              ),
            ),
            const Gap(24),
          ],
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              title: PtsStateNotifier.ptsState.hasActivePts
                  ? 'Visualizar meu PTS'
                  : 'Visualizar propostas de PTS',
              onPressed: () {
                if (PtsStateNotifier.ptsState.hasActivePts) {
                  context.push('/view-pts/$accountId');
                } else {
                  context.push('/approve-pts/$accountId');
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalSection() {
    final hasMore = _patients.length < _totalElements;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pacientes',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF313030),
                ),
              ),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFC200),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        PhosphorIconsBold.plus,
                        color: Colors.black,
                      ),
                      onPressed: () => context.push('/create-pts'),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFC200),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        PhosphorIconsBold.magnifyingGlass,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Gap(24),
          if (_error != null)
            Center(
              child: Text(
                'Erro: $_error',
                style: const TextStyle(color: Colors.red),
              ),
            )
          else if (_isLoadingPatients && _patients.isEmpty)
            const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFC200)),
            )
          else if (_patients.isEmpty)
            const Text(
              'Nenhum paciente encontrado.',
              style: TextStyle(color: Color(0xFF313030), fontSize: 16),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _patients.length + (hasMore ? 1 : 0),
              separatorBuilder: (_, _) => const Gap(16),
              itemBuilder: (context, index) {
                if (index == _patients.length) {
                  return SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      title: "Carregar mais",
                      isLoading: _isLoadingPatients,
                      onPressed: () => _loadPatients(loadMore: true),
                    ),
                  );
                }

                final patient = _patients[index];
                return CustomRowItem(
                  title: patient['name'] as String,
                  isCircularImage: false,
                  isProfileImage: false,
                  subtitle: 'Situação PTS',
                  placeholderImage: 'assets/imagens/florzinha.png',
                  buttonText: 'Visualizar PTS',
                  onButtonTap: () {
                    context.push(
                      '/view-pts/${patient['accountId']}',
                      extra: patient['name'],
                    );
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}
