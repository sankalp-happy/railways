import 'package:flutter/material.dart';

IconData iconForCategory(String name) {
  final lower = name.toLowerCase();
  if (lower.contains('bridge') || lower.contains('structure')) return Icons.architecture;
  if (lower.contains('abutment') || lower.contains('pier')) return Icons.foundation;
  if (lower.contains('track')) return Icons.train;
  if (lower.contains('signal')) return Icons.traffic;
  if (lower.contains('electr')) return Icons.electrical_services;
  if (lower.contains('rolling')) return Icons.directions_railway;
  if (lower.contains('tower')) return Icons.cell_tower;
  if (lower.contains('well')) return Icons.water;
  if (lower.contains('slab') || lower.contains('girder') || lower.contains('beam')) return Icons.view_column;
  if (lower.contains('level crossing')) return Icons.swap_horiz;
  if (lower.contains('foot') || lower.contains('subway')) return Icons.directions_walk;
  if (lower.contains('culvert') || lower.contains('pipe')) return Icons.water_damage;
  if (lower.contains('retaining') || lower.contains('wall')) return Icons.crop_landscape;
  if (lower.contains('bed') || lower.contains('protection')) return Icons.shield;
  return Icons.category;
}
