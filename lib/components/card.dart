import 'package:flutter/material.dart';
import 'package:front_pi/theme/styles.dart';

class CardProfilePictureHeader extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final List<String> roles;

  const CardProfilePictureHeader({
    super.key,
    this.imageUrl,
    required this.name,
    required this.roles,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          _buildImage(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$name (${roles.join(", ")})",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    final avatarUrl = imageUrl;
    ImageProvider image = avatarUrl != null
        ? NetworkImage(avatarUrl)
        : AssetImage("assets/imagens/dog.png");

    return Center(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black.withValues(alpha: 0.2)),
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(radius: 24, backgroundImage: image),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final List<Widget> children;
  final BoxDecoration? decoration;

  const CustomCard({super.key, required this.children, this.decoration});

  @override
  Widget build(BuildContext context) {
    final baseDecoration = BoxDecoration(
      color: Styles.widgetWhite,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Styles.widgetBlack40, width: 1),
    );

    final effectiveDecoration = baseDecoration.copyWith(
      color: decoration?.color ?? baseDecoration.color,
      border: decoration?.border ?? baseDecoration.border,
      borderRadius: decoration?.borderRadius ?? baseDecoration.borderRadius,
      boxShadow: decoration?.boxShadow ?? baseDecoration.boxShadow,
      gradient: decoration?.gradient ?? baseDecoration.gradient,
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: effectiveDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
