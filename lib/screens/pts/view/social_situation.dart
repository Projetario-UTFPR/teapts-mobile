import 'package:flutter/material.dart';
import 'package:front_pi/components/alert.dart';
import 'package:front_pi/components/expandable-section.dart';
import 'package:front_pi/theme/styles.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:go_router/go_router.dart';

class SitualSociationSection extends StatelessWidget {
  final String? error;
  final String? socialSituation;
  final String patientId;
  final String patientName;

  const SitualSociationSection({
    super.key,
    required this.socialSituation,
    this.error,
    required this.patientId,
    required this.patientName,
  });

  bool _textExceedsMaxLines(
    String text,
    TextStyle style,
    double maxWidth,
    int maxLines,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);
    return textPainter.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableSection(
      title: 'Situação social',
      actions: [
        IconButton(
          icon: Icon(
            PhosphorIcons.pencilSimpleLine(PhosphorIconsStyle.bold),
            size: 24,
            color: Styles.widgetBlack,
          ),
          onPressed: () {
            //TODO: mandar para pagina para editar o conteudo de situação social
          },
          style: IconButton.styleFrom(
            backgroundColor: Styles.widgetYellow,
            padding: const EdgeInsets.all(0),
            shape: const CircleBorder(),
          ),
        ),
      ],
      children: [
        if (error != null)
          Alert(message: error!, type: AlertType.error)
        else
          LayoutBuilder(
            builder: (context, constraints) {
              final overflows = _textExceedsMaxLines(
                socialSituation!,
                Styles.normalText,
                constraints.maxWidth,
                3,
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    socialSituation!,
                    style: Styles.normalText,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (overflows) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton(
                        onPressed: () {
                          context.push(
                            '/social-situation/${patientId}',
                            extra: {
                              'patientName': patientName,
                              'socialSituation': socialSituation!,
                            },
                          );
                        },
                        style: Styles.buttonWhite,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Ver mais', style: Styles.midSizeBold),
                              Icon(
                                PhosphorIcons.arrowRight(
                                  PhosphorIconsStyle.bold,
                                ),
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
      ],
    );
  }
}
