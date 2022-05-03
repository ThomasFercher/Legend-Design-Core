import 'package:flutter/material.dart';
import 'package:legend_design_core/gestures/detector.dart';

class LegendAnimatedIcon extends StatefulWidget {
  final IconData icon;
  final LegendAnimtedIconTheme theme;
  final void Function() onPressed;
  final EdgeInsetsGeometry? padding;
  final double? iconSize;
  final bool isSelected;
  late final bool disableShadow;

  LegendAnimatedIcon({
    required this.icon,
    required this.theme,
    required this.onPressed,
    this.isSelected = false,
    this.iconSize,
    this.padding,
    bool? disableShadow,
  }) {
    this.disableShadow = disableShadow ?? false;
  }

  @override
  _LegendAnimatedIconState createState() => _LegendAnimatedIconState();
}

class _LegendAnimatedIconState extends State<LegendAnimatedIcon>
    with SingleTickerProviderStateMixin {
  late bool hovered;
  late AnimationController _controller;
  late Animation<Color?> _animation;
  late Color? color;

  @override
  void initState() {
    hovered = false;
    color = widget.theme.disabled;
    _controller = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    _animation =
        ColorTween(begin: widget.theme.disabled, end: widget.theme.enabled)
            .animate(_controller)
          ..addListener(
            () {
              setState(() {
                color = _animation.value;
              });
            },
          );
    if (widget.isSelected) _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      child: LegendDetector(
        onTap: () => widget.onPressed(),
        onHover: (value) {
          if (value && !hovered && !widget.isSelected) {
            if (!_controller.isAnimating || !hovered) {
              _controller.forward();
              hovered = true;
            }
          } else if (!widget.isSelected) {
            if (!_controller.isAnimating || hovered) {
              _controller.reverse();
              hovered = false;
            }
          }
        },
        child: Container(
          decoration: widget.disableShadow
              ? null
              : BoxDecoration(
                  boxShadow: [
                    widget.theme.getAnimatedShadow(color),
                  ],
                  borderRadius: BorderRadius.all(
                    Radius.circular(widget.iconSize ?? 8 / 2),
                  ),
                ),
          child: Icon(
            widget.icon,
            color: color,
            size: widget.iconSize,
          ),
        ),
      ),
    );
  }
}

class LegendAnimtedIconTheme {
  final Color enabled;
  final Color disabled;
  late BoxShadow enabledBoxShadow;

  LegendAnimtedIconTheme({
    required this.enabled,
    required this.disabled,
    BoxShadow? boxShadow,
  }) {
    enabledBoxShadow = boxShadow ??
        BoxShadow(
          color: enabled.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 16,
          offset: Offset(0, 0),
        );
  }

  BoxShadow getAnimatedShadow(Color? color) {
    return BoxShadow(
      color: color?.withOpacity(0.2) ?? Colors.transparent,
      blurRadius: enabledBoxShadow.blurRadius,
      offset: enabledBoxShadow.offset,
      spreadRadius: enabledBoxShadow.spreadRadius,
    );
  }
}
