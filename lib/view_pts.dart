import 'package:flutter/material.dart';
import 'package:front_pi/theme/styles.dart';
import 'package:front_pi/widgets/expandableEquipeMultidiciplinar.dart';
import 'package:front_pi/widgets/expandableText.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'widgets/imageSideCard.dart';
import 'widgets/expandableAtividades.dart';

class ViewPtsPage extends StatelessWidget {
  ViewPtsPage({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.bgColor,
    appBar: AppBar(
  backgroundColor: Styles.bgColor,
  elevation: 0,
  leading: Padding(
  padding: const EdgeInsets.all(8.0),
  child: GestureDetector(
    onTap: () => context.pop(),
    child: Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: Color(0xFFFFC200),
        shape: BoxShape.circle,
      ),
      child: PhosphorIcon(
  PhosphorIconsBold.arrowLeft,
  size: 20,
  color: Colors.black,
        ),
      ),
    ),
  ),
),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 48.0),
        child: Column(
          spacing: 24,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const CustomRowItem(
                title: 'John Doe',
                isCircularImage: true,
                isProfileImage: true,
              ),
            ),

            Divider(
              color: Styles.widgetBlack40,
              thickness: 1,
              endIndent: 16,
              indent: 16,
            ),

            const ExpandableTextDisplay(),

            const ExpandableAtividades(),

            const ExpandableEquipeMultidiciplinar(),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed:
                    (
                      //TODO: fazer o navigator para pagina de
                    ) {},
                style: Styles.buttonWhite,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Prontuario'),
                      Icon(
                        PhosphorIcons.arrowRight(PhosphorIconsStyle.bold),
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
