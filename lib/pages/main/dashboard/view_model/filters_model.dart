class FiltersModel {
  FiltersModel({
    required this.title,
    required this.value,
    this.isSelected,
    this.value2,
  });
  String title;
  String? value;
  String? value2;
  bool? isSelected;
}
