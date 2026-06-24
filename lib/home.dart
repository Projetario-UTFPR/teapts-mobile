import 'package:flutter/material.dart';
import 'package:front_pi/widgets/imageSideCard.dart';
import 'package:front_pi/widgets/specialism_chip.dart';
import 'package:front_pi/view_pts.dart';
import 'package:go_router/go_router.dart';

class Patient {
  final String accountId;
  final String name;
  final String ptsId;
  final String status;
  final String specialism;

  Patient({
    required this.accountId,
    required this.name,
    required this.ptsId,
    required this.status,
    required this.specialism,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const int _pageSize = 2;

  // TODO: substituir por chamada real ao endpoint de listagem quando existir
  final List<Patient> _allPatients = [
    Patient(
      accountId: '1',
      name: 'Ana Souza',
      ptsId: '143bc4a6-85d8-43d0-b6dd-8cf64d4ac04b',
      status: 'running',
      specialism: 'Psicólogo',
    ),
    Patient(
      accountId: '2',
      name: 'Bruno Lima',
      ptsId: '737f559f-7071-4418-98aa-619604fc138d',
      status: 'running',
      specialism: 'Psiquiatra',
    ),
    Patient(
      accountId: '3',
      name: 'Carla Mendes',
      ptsId: 'c1fe3c90-1169-4471-a32d-57d551f7a032',
      status: 'running',
      specialism: 'Fisioterapeuta',
    ),
    Patient(
      accountId: '4',
      name: 'Diego Alves',
      ptsId: '4ceedf12-d170-40e2-9662-ce3a913d7808',
      status: 'running',
      specialism: 'Psicólogo',
    ),
    Patient(
      accountId: '5',
      name: 'Fernanda Rocha',
      ptsId: '2c21aad4-ade0-4831-8043-3bad0672cb4b',
      status: 'running',
      specialism: 'Psiquiatra',
    ),
  ];

  int _visibleCount = _pageSize;

  void _loadMore() {
    setState(() {
      _visibleCount = (_visibleCount + _pageSize).clamp(0, _allPatients.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    final visiblePatients = _allPatients.take(_visibleCount).toList();
    final hasMore = _visibleCount < _allPatients.length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Pacientes'),
        centerTitle: false,
        backgroundColor: Colors.white,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: const BoxDecoration(
              color: Color(0xFFFFC200),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.black),
              onPressed: () => context.go('/create-pts'),
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
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: visiblePatients.length + (hasMore ? 1 : 0),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == visiblePatients.length) {
            return SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC200),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _loadMore,
                child: const Text(
                  'Carregar mais',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            );
          }

          final patient = visiblePatients[index];
          return CustomRowItem(
            title: patient.name,
            isCircularImage: false,
            isProfileImage: false,
            subtitle: 'Situação PTS',
            tag: SpecialismChip(label: patient.specialism),
            placeholderImage: 'assets/imagens/florzinha.png',
            buttonText: 'Visualizar PTS',
            onButtonTap: () {
              context.push(
                '/view-pts/${patient.accountId}',
                extra: patient.name,
              );
            },
          );
        },
      ),
    );
  }
}
