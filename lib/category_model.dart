import 'package:flutter/material.dart';

class CategoryModel {
  final IconData icon;
  final String title;
  final String itemCount;
  final List<Color> gradient;

  CategoryModel({
    required this.icon,
    required this.title,
    required this.itemCount,
    required this.gradient,
  });
}
