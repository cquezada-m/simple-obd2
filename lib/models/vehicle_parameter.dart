import 'package:flutter/material.dart';

class VehicleParameter {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final double percentage;
  final Color color;
  final Color bgColor;

  const VehicleParameter({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.percentage,
    required this.color,
    required this.bgColor,
  });

  VehicleParameter copyWith({
    String? label,
    String? value,
    String? unit,
    IconData? icon,
    double? percentage,
    Color? color,
    Color? bgColor,
  }) {
    return VehicleParameter(
      label: label ?? this.label,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      icon: icon ?? this.icon,
      percentage: percentage ?? this.percentage,
      color: color ?? this.color,
      bgColor: bgColor ?? this.bgColor,
    );
  }
}
