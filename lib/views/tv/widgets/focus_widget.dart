import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FocusWidget extends StatefulWidget {
  final FocusNode? focusNode;
  final Widget child;
  final Widget? focusedChild;
  final bool autofocus;
  final VoidCallback? onSelect;
  final VoidCallback? onFocus;
  final double translationValue;
  final Border? focusedBorder;
  final List<BoxShadow> focusedShadows;
  final double borderRadius;
  final double scaleRatio;
  final int animationDuration;

  const FocusWidget({
    super.key,
    this.focusNode,
    required this.child,
    this.focusedChild,
    this.autofocus = false,
    this.onSelect,
    this.onFocus,
    this.translationValue = 0,
    this.focusedBorder,
    this.focusedShadows = const [],
    this.borderRadius = 0,
    this.scaleRatio = 1.1,
    this.animationDuration = 300,
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
      focusNode: widget.focusNode ?? _focusNode,
      autofocus: widget.autofocus,
      onKeyEvent: (_, event) {
        _handleKeyEvent(event);
        return KeyEventResult.ignored;
      },
      onFocusChange: (hasFocus) {
        if (hasFocus) {
          widget.onFocus?.call();
        }
      },
      child: Builder(
        builder: (context) {
          bool isFocused = Focus.of(context).hasFocus;
          return AnimatedContainer(
            duration: Duration(milliseconds: widget.animationDuration),
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
              scale: isFocused ? widget.scaleRatio : 1,
              child:
                  isFocused && widget.focusedChild != null
                      ? widget.focusedChild!
                      : widget.child,
            ),
          );
        },
      ),
    );
  }
}
