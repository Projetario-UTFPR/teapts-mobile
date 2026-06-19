import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SpecialismChip extends StatelessWidget {
  final String label;

  const SpecialismChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFC200), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, 
        children: [
          PhosphorIcon(
            PhosphorIconsRegular.identificationCard,
            size: 16,
            color: Colors.black,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}