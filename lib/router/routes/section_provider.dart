import 'package:flutter/material.dart';
import 'package:legend_design_core/router/routes/section_info.dart';

class SectionProvider extends InheritedWidget {
  SectionProvider({
    Key? key,
    required this.child,
    required this.sections,
  }) : super(key: key, child: child);

  @override
  final Widget child;
  final List<SectionInfo>? sections;

  static SectionProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SectionProvider>();
  }

  @override
  bool updateShouldNotify(SectionProvider oldWidget) {
    return true;
  }
}
