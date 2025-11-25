import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'images.asset.g.dart';

const List<String> _excludeFileNames = <String>[
  '*.svg.vec',
];

@AssetGen(
  path: 'assets/images',
  showExtension: false,
  excludeFileNames: _excludeFileNames,
)

// ignore: unused_element
class _$DefaultImages {}

@AssetGen(
  path: 'assets/icons',
  showExtension: false,
  // excludeFileNames: _excludeFileNames,
)

// ignore: unused_element
class _$DefaultIcons {}

@AssetGen(
  path: 'assets/vectors',
  showExtension: false,
  // excludeFileNames: _excludeFileNames,
)

// ignore: unused_element
class _$DefaultVectors {}

@AssetGen(
  path: 'assets/animations',
  showExtension: false,
  // excludeFileNames: _excludeFileNames,
)

// ignore: unused_element
class _$DefaultAnimations {}
