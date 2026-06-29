import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SwipeToRevealDelete extends StatefulWidget {
  final Widget child;
  final VoidCallback onDelete;

  const SwipeToRevealDelete({
    super.key,
    required this.child,
    required this.onDelete,
  });

  @override
  State<SwipeToRevealDelete> createState() => _SwipeToRevealDeleteState();
}

class _SwipeToRevealDeleteState extends State<SwipeToRevealDelete>
    with SingleTickerProviderStateMixin {
  static const double _revealWidth = 72;

  double _dragExtent = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animateTo(double target) {
    _animation = Tween<double>(begin: _dragExtent, end: target).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    )..addListener(() {
        setState(() => _dragExtent = _animation.value);
      });
    _controller.forward(from: 0);
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragExtent =
          (_dragExtent + details.delta.dx).clamp(-_revealWidth, 0.0);
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_dragExtent < -_revealWidth / 2) {
      _animateTo(-_revealWidth);
    } else {
      _animateTo(0);
    }
  }

  void _closeAndDelete() {
    widget.onDelete();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: _revealWidth,
            child: Container(
              color: Colors.transparent, 
              child: Center(
                child: GestureDetector(
                  onTap: _closeAndDelete,
                  child: GestureDetector(
  onTap: _closeAndDelete,
  child: Container(
    width: 56,  
    height: 72, 
    decoration: ShapeDecoration(
      color: const Color(0xFFFF0000),
      shape: const StadiumBorder(),
    ),
    child: Center(
      child: PhosphorIcon(
        PhosphorIconsFill.trash,
        color: Colors.white,
        size: 22,
      ),
    ),
  ),
),
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(_dragExtent, 0),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
