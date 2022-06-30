import 'package:flutter/material.dart';

class Piece extends StatefulWidget {
  final int posX, posY, size;
  final Color colors;
  final bool isAnimated;

  const Piece({
    super.key,
    required this.posX,
    required this.posY,
    required this.size,
    required this.colors,
    this.isAnimated = false
  });

  @override
  _PieceState createState() => _PieceState();
}

class _PieceState extends State<Piece> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      lowerBound: 0.25,
      upperBound: 1.0,
      duration: const Duration(milliseconds: 1000),
    );
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.posY.toDouble(),
      left: widget.posX.toDouble(),
      child: Opacity(
        opacity: widget.isAnimated?_animationController.value:1,
        child: Container(
          width: widget.size.toDouble(),
          height: widget.size.toDouble(),
          decoration: BoxDecoration(
            color: widget.colors,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(width: 2.0, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
