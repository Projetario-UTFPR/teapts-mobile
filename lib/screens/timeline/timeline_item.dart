import 'package:flutter/material.dart';
import 'package:front_pi/theme/styles.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

enum Position {
  first,
  middle,
  last
}

class TimelineItem extends StatelessWidget {
  final Position position;
  final String? professionalName;
  final String? professionalSpeciality;
  final String eventDescription;
  final DateTime eventDateTime;

  const TimelineItem({
    super.key,
    required this.professionalName,
    required this.professionalSpeciality,
    required this.eventDescription,
    required this.eventDateTime,
    this.position = Position.middle
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 24,

        children: [
          // timeline marks
          Column(
            spacing: 4,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(8),
                      bottomLeft: Radius.circular(8)
                    ),
                    color: position != Position.first ? Styles.widgetYellow : Colors.transparent,
                  ),
                  width: 8,
                )
              ),

              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Styles.widgetYellow,
                ),
                width: 24,
                height: 24,
              ),

              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      topLeft: Radius.circular(8)
                    ),
                    color: position != Position.last ? Styles.widgetYellow : Colors.transparent,
                  ),
                  width: 8,
                )
              )
            ],
          ),

          // actual content
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 0),
              decoration: BoxDecoration(
                border: position == Position.last ? null : Border(
                  bottom: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.2))
                )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 12,
                
                children: [
                  PhosphorIcon(
                    PhosphorIconsFill.addressBookTabs,
                    color: Colors.black,
                    size: 48,
                  ),

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 0,
                      children: [
                        Text(
                          eventDescription,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            overflow: TextOverflow.clip,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '$professionalName ($professionalSpeciality)',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          DateFormat("dd/MM/yyyy HH'h'mm").format(eventDateTime),
                          style: TextStyle(
                            fontSize: 14,
                            color: Styles.widgetBlackCarret
                          ),
                        ),
                      ],
                    )
                  )
                ],
              ),
            )
          )
        ],
      )
    );
  }
}
