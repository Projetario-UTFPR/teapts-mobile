import 'package:flutter/material.dart';
import 'package:front_pi/theme/styles.dart';
import 'package:front_pi/models/prontuario_document.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

final _dateFmt = DateFormat('dd/MM/yyyy');

class DocumentoCard extends StatelessWidget {
  final ProntuarioDocument documento;

  const DocumentoCard({super.key, required this.documento});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: PhosphorIcon(
                  PhosphorIconsFill.fileText,
                  color: Colors.grey.shade500,
                  size: 48,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    documento.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (documento.description != null &&
                      documento.description!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      documento.description!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    'Adicionado em ${_dateFmt.format(documento.createdAt)}. '
                    'Última modificação em ${_dateFmt.format(documento.lastUpdatedAt)}.',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () {
                      // TODO: abrir documento via documento.documentUrl
                    },
                    child: const Text(
                      'Baixar o documento',
                      style: TextStyle(
                        fontSize: 18,
                        color: Styles.linkOrange,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                        decorationColor: Styles.linkOrange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
