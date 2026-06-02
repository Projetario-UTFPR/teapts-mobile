import 'package:flutter/material.dart';
import 'package:front_pi/theme/styles.dart';

class CustomRowItem extends StatelessWidget {
  final String title;
  final bool isCircularImage;
  final bool isProfileImage;

  final String? subtitle;
  final String? linkText;
  final VoidCallback? onLinkTap;
  final IconData placeholderIcon;

  const CustomRowItem({
    super.key,
    required this.title,
    this.isCircularImage = true,
    this.isProfileImage = false,
    this.subtitle,
    this.linkText,
    this.onLinkTap,
    this.placeholderIcon = Icons.person,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildImage(),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(isCircularImage && isProfileImage)...[
               Text(title, style: Styles.titlesBold),
              ],
              if(!isCircularImage || !isProfileImage)...[
               Text(title, style: Styles.normalTextBold),
              ],
              if (subtitle != null) ...[
                Text(subtitle!, style: Styles.normalText),
              ],

              if (linkText != null && onLinkTap != null) ...[
                const SizedBox(height: 2),
                GestureDetector(
                  onTap: onLinkTap,
                  child: Text(linkText!, style: Styles.linkBold),
                ),
              ],
            ],
          ),
        ),
      ],
    );
    if (!isCircularImage || !isProfileImage) {
      return Container(
        height: 112,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Styles.widgetWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Styles.widgetBlack40, width: 1,)

        ),
        child: content,
      );
    }
    return content;
  }

  Widget _buildImage() {
    if (isCircularImage) {
      return CircleAvatar(
        radius: 24,
        backgroundColor: Colors.grey,
        child: Icon(placeholderIcon, size: 36, color: Styles.widgetWhite),
      );
    } else if(isCircularImage && !isProfileImage){
      return Container(
        width: 64,
        height: 72,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(placeholderIcon, size: 36, color: Styles.widgetWhite),
      );

    } else{
      return Container(
        width: 64,
        height: 72,
        decoration: BoxDecoration(
          color: Styles.IconLightGray,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(placeholderIcon, size: 48, color: Styles.IconDarkGray),
      );
    }
  }
}
