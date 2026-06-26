import 'package:flutter/material.dart';
import 'package:front_pi/theme/styles.dart';
import 'package:front_pi/models/prontuario_document.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

final _dateFmt = DateFormat('dd/MM/yyyy');

class DocumentoCard extends StatelessWidget {
  final ProntuarioDocument document;

  const DocumentoCard({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    final documentUrl = Uri.parse(document.documentUrl);

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
                    document.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (document.description != null &&
                      document.description!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      document.description!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    'Adicionado em ${_dateFmt.format(document.createdAt)}. '
                    'Última modificação em ${_dateFmt.format(document.lastUpdatedAt)}.',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () async {
                      if (await canLaunchUrl(documentUrl)) {
                        await launchUrl(
                          documentUrl,
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Não foi possível abrir o documento.',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
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
