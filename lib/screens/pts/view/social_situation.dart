import 'package:flutter/material.dart';
import 'package:front_pi/components/alert.dart';
import 'package:front_pi/components/buttons/secondary_button.dart';
import 'package:front_pi/components/expandable-section.dart';
import 'package:front_pi/theme/styles.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:go_router/go_router.dart';

class SitualSociationSection extends StatelessWidget {
  final String? _error;
  final String? _socialSituation;
  final String patientId;
  final String patientName;

  const SitualSociationSection({
    super.key,
    required String? socialSituation,
    String? error,
    required this.patientId,
    required this.patientName,
  }) : _socialSituation = socialSituation,
       _error = error;

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
    final error = _error;
    final socialSituation = _socialSituation;
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
            context.push(
              '/edit-social-situation/$patientId',
              extra: {
                'patientId': patientId,
                'patientName': patientName,
                'socialSituation': socialSituation ?? '',
              },
            );
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
          Alert(message: error, type: AlertType.error)
        else if (socialSituation != null)
          LayoutBuilder(
            builder: (context, constraints) {
              final overflows = _textExceedsMaxLines(
                socialSituation,
                Styles.normalText,
                constraints.maxWidth,
                3,
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      socialSituation,
                      style: Styles.normalText,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (overflows) ...[
                    const SizedBox(height: 12),
                    SecondaryButton(
                      title: "Ver mais",
                      isLinkButton: true,
                      onPressed: () {
                        context.push(
                          '/social-situation/$patientId',
                          extra: {
                            'patientName': patientName,
                            'socialSituation': socialSituation,
                          },
                        );
                      },
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
