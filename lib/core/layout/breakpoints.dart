import 'package:flutter/widgets.dart';

/// Named breakpoints for responsive server-driven layouts.
///
/// Mirrors Material Design 3 window size classes:
///   compact  <  600
///   medium   >= 600
///   expanded >= 840
enum Breakpoint { compact, medium, expanded }

Breakpoint currentBreakpoint(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width >= 840) return Breakpoint.expanded;
  if (width >= 600) return Breakpoint.medium;
  return Breakpoint.compact;
}
