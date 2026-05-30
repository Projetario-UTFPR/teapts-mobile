import 'package:flutter/material.dart';
import 'package:front_pi/theme/styles.dart';

class CustomRowItem extends StatelessWidget {

  final String title;
  final bool isCircularImage;

  final String? subtitle; 
  final String? linkText; 
  final VoidCallback? onLinkTap;
  final IconData placeholderIcon;

  const CustomRowItem({
    super.key,
    required this.title,
    this.isCircularImage = true,
    this.subtitle,
    this.linkText,
    this.onLinkTap,
    this.placeholderIcon = Icons.person,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Row(

      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildImage(),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Styles.h2),

              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: Styles.textFieldRegular,
                ),
              ],

              if (linkText != null && onLinkTap != null) ...[
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: onLinkTap,
                  child: Text(
                    linkText!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.orangeAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  if (!isCircularImage) {
      return Container(
        padding: const EdgeInsets.all(16), 
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
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
        child: Icon(placeholderIcon, size: 28, color: Styles.widgetWhite),
      );
    } else {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(12),
          
        ),
        child: Icon(placeholderIcon, size: 28, color: Styles.widgetWhite),
      );
    }
  }
}
