import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FocusWidget extends StatefulWidget {
  final Widget child;
  final bool autofocus;
  final VoidCallback? onSelect;
  final double translationValue;
  final Border? focusedBorder;
  final List<BoxShadow> focusedShadows;
  final double borderRadius;

  const FocusWidget({
    super.key,
    required this.child,
    this.autofocus = false,
    this.onSelect,
    this.translationValue = 0,
    this.focusedBorder,
    this.focusedShadows = const [],
    this.borderRadius = 0,
  });

  @override
  State<FocusWidget> createState() => _FocusWidgetState();
}

class _FocusWidgetState extends State<FocusWidget> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.select) {
        widget.onSelect?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      onKeyEvent: (_, event) {
        _handleKeyEvent(event);
        return KeyEventResult.ignored;
      },
      child: Builder(
        builder: (context) {
          bool isFocused = Focus.of(context).hasFocus;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.translationValues(
              isFocused ? widget.translationValue : 0,
              0,
              0,
            ),
            decoration: BoxDecoration(
              border: isFocused ? widget.focusedBorder : null,
              boxShadow: isFocused ? widget.focusedShadows : [],
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            child: Transform.scale(
              scale: isFocused ? 1.1 : 1,
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}
