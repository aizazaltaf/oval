import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class FeatureModel {
  FeatureModel({
    required this.title,
    this.image = "",
    this.value,
    this.brand,
    this.isSelected = false,
    this.controller,
    this.color = const Color(0xFFFFFFFF),
    this.route,
    this.token,
    this.key,
    this.name,
    this.host,
    this.roomId,
  });
  String title;
  String image;
  String? value;
  String? name;
  String? brand;
  String? token;
  String? key;
  String? host;
  int? roomId;
  Color color;
  bool isSelected;
  RefreshController? controller;
  Function(BuildContext)? route;

  FeatureModel copyWith({
    String? title,
    String? value,
    String? brand,
    String? image,
    bool? isSelected,
  }) {
    return FeatureModel(
      title: title ?? this.title, // Use existing value if null
      value: value ?? this.value,
      brand: brand ?? this.brand,
      image: image ?? this.image,
      isSelected: isSelected ?? this.isSelected, // Use existing value if null
    );
  }
}
