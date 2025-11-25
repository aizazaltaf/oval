import 'package:flutter/material.dart';

class TypingBubble extends StatelessWidget {
  const TypingBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      alignment: Alignment.centerLeft,
      child: Container(
        width: 60,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: TypingDots(),
        ),
      ),
    );
  }
}

class TypingDots extends StatefulWidget {
  const TypingDots({super.key});

  @override
  State<TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<TypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _dotOneAnim;
  late Animation<double> _dotTwoAnim;
  late Animation<double> _dotThreeAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();

    _dotOneAnim = Tween<double>(begin: 0, end: -5).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 0.3)),
    );
    _dotTwoAnim = Tween<double>(begin: 0, end: -5).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.5)),
    );
    _dotThreeAnim = Tween<double>(begin: 0, end: -5).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.4, 0.7)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDot(Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(0, animation.value),
          child: child,
        );
      },
      child: Container(
        width: 4,
        height: 4,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDot(_dotOneAnim),
        _buildDot(_dotTwoAnim),
        _buildDot(_dotThreeAnim),
      ],
    );
  }
}
