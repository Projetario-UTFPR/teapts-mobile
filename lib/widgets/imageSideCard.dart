import 'package:flutter/material.dart';
import 'package:front_pi/theme/styles.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomRowItem extends StatelessWidget {
  final String title;
  final bool isCircularImage;
  final bool isProfileImage;
  final String? placeholderImage;
  final String? subtitle;
  final Widget? tag;
  final String? buttonText;
  final VoidCallback? onButtonTap;
  final String? linkText;
  final VoidCallback? onLinkTap;
  final IconData placeholderIcon;

  const CustomRowItem({
    super.key,
    required this.title,
    this.isCircularImage = true,
    this.isProfileImage = false,
    this.subtitle,
    this.tag,
    this.buttonText,
    this.onButtonTap,
    this.linkText,
    this.onLinkTap,
    this.placeholderImage,
    this.placeholderIcon = Icons.person,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCard = !isCircularImage || !isProfileImage;

    Widget rowContent = IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildImage(),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: isCircularImage && isProfileImage
                        ? Styles.titlesBold
                        : Styles.normalTextBold,
                  ),
                  if (subtitle != null)
                    Text(subtitle!, style: Styles.normalText),
                  if (tag != null) ...[const SizedBox(height: 4), tag!],
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
          ),
        ],
      ),
    );

    if (!isCard) return rowContent;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Styles.widgetWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Styles.widgetBlack40, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          rowContent,
          if (buttonText != null && onButtonTap != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton(
                onPressed: onButtonTap,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  side: BorderSide(color: Styles.widgetBlack40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      buttonText!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    PhosphorIcon(PhosphorIconsBold.arrowRight, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (isCircularImage) {
      return Center(
        child: CircleAvatar(
          radius: 24,
          backgroundColor: Colors.grey,
          child: Icon(placeholderIcon, size: 36, color: Styles.widgetWhite),
        ),
      );
    } else {
      return ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 72),
        child: Container(
          width: 64,
          decoration: BoxDecoration(
            color: Styles.IconLightGray,
            borderRadius: BorderRadius.circular(12),
          ),
          child: placeholderImage != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(placeholderImage!, fit: BoxFit.cover),
                )
              : Icon(placeholderIcon, size: 48, color: Styles.IconDarkGray),
        ),
      );
    }
  }
}
