extension XDouble on double {
  double toDoubleAsFixed(final int fractionDigits) {
    return double.parse(toStringAsFixed(fractionDigits));
  }

  int get nextRoundedEven {
    final int rounded = round();
    return (rounded.isEven) ? rounded : rounded + 1;
  }

  String toFormattedNumber([final int? fractionDigits]) {
    final RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String mathFunc(final Match match) => '${match[1]},';
    final String sDouble;
    if (fractionDigits != null) {
      sDouble = toStringAsFixed(fractionDigits);
    } else {
      sDouble = toString();
    }
    return sDouble.replaceAllMapped(reg, mathFunc);
  }

  String toStringWithoutDecimalIfPossible([final int? fractionDigits]) {
    if (this == toInt().toDouble()) {
      return toInt().toString();
    }
    if (fractionDigits != null) {
      return toStringAsFixed(fractionDigits);
    } else {
      return toString();
    }
  }
}
