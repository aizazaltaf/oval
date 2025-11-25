enum Flavor {
  develop,
  test,
  uat,
  preprod,
}

mixin F {
  static late final Flavor appFlavor;

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case Flavor.develop:
        return 'Oval Dev';
      case Flavor.test:
        return 'Oval Test';
      case Flavor.uat:
        return 'Oval Uat';
      case Flavor.preprod:
        return 'Oval';
    }
  }
}
