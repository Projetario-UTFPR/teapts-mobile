import 'package:flutter/material.dart';
import 'package:front_pi/components/buttons/primary_button.dart';
import 'package:front_pi/widgets/custom_row_item.dart';
import 'package:front_pi/widgets/mainAppBar.dart';
import 'package:go_router/go_router.dart';
import 'services/pts_service.dart';
import 'package:front_pi/screens/create_patient_profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _patients = [];
  int _page = 1;
  int _totalElements = 0;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  Future<void> _loadPatients({bool loadMore = false}) async {
    setState(() => _isLoading = true);

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
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasMore = _patients.length < _totalElements;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MainAppBar(
        title: 'Pacientes',
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: const BoxDecoration(
              color: Color(0xFFFFC200),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.black),
              onPressed: () => context.push('/create-pts'),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: const BoxDecoration(
              color: Color(0xFFFFC200),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: () {},
            ),
          ),
        ],
      ),

      body: _error != null
          ? Center(child: Text('Erro: $_error'))
          : _isLoading && _patients.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: _patients.length + (hasMore ? 1 : 0),
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index == _patients.length) {
                  return SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      title: "Carregar mais",
                      isLoading: _isLoading,
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
    );
  }
}
