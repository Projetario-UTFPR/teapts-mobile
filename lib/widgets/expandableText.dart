import 'package:flutter/material.dart';
import 'package:front_pi/components/expandable-section.dart';
import 'package:front_pi/theme/styles.dart';
import 'package:front_pi/services/pts_service.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:go_router/go_router.dart';

class ExpandableTextDisplay extends StatefulWidget {
  final String patientId;
  final String patientName;

  const ExpandableTextDisplay({
    super.key,
    required this.patientId,
    required this.patientName,
  });

  @override
  State<ExpandableTextDisplay> createState() => _ExpandableTextDisplayState();
}

class _ExpandableTextDisplayState extends State<ExpandableTextDisplay> {
  bool _isLoading = true;
  String? _error;
  String _socialSituation = '';

  @override
  void initState() {
    super.initState();
    _loadSocialSituation();
  }

  Future<void> _loadSocialSituation() async {
    try {
      final pts = await PtsService.getPts(widget.patientId);
      if (!mounted) return;
      setState(() {
        _socialSituation = (pts['socialSituation'] as String?) ?? '';
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

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
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: CircularProgressIndicator(color: Colors.amber),
            ),
          )
        else if (_error != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Erro ao carregar situação social: $_error',
              style: Styles.normalText,
            ),
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
              final overflows = _textExceedsMaxLines(
                _socialSituation,
                Styles.normalText,
                constraints.maxWidth,
                3,
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _socialSituation,
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
                            '/social-situation/${widget.patientId}',
                            extra: {
                              'patientName': widget.patientName,
                              'socialSituation': _socialSituation,
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
