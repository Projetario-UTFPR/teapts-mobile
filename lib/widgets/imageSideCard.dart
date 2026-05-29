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
    return Row(

      crossAxisAlignment: CrossAxisAlignment.start,
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
  }

  Widget _buildImage() {
    if (isCircularImage) {
      return CircleAvatar(
        radius: 24,
        backgroundColor: Colors.grey[200],
        child: Icon(placeholderIcon, size: 28, color: Colors.grey[600]),
      );
    } else {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Styles.widgetWhite,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(placeholderIcon, size: 28, color: Colors.grey[600]),
      );
    }
  }
}
