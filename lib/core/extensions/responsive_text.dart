import 'package:flutter/material.dart';

extension ResponsiveText on BuildContext {
  double sp(double base) {
    final scale = MediaQuery.sizeOf(this).shortestSide / 375;
    return (base * scale).clamp(base * 0.85, base * 1.15);
  }
}