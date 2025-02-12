enum Flavor {
  production,
  unit,
  staging,
  development,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.production:
        return 'Accident Detector';
      case Flavor.unit:
        return 'Accident Detector Units';
      case Flavor.staging:
        return 'Accident Detector Testing';
      case Flavor.development:
        return 'Accident Detector Developers';
      default:
        return 'title';
    }
  }
}
