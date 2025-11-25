// ignore_for_file: type=lint, unused_element

part of 'environment.dart';

// **************************************************************************
// EnumGenerator
// **************************************************************************

extension XEnvironment on Environment {
  R when<R>({
    required R Function() test,
    required R Function() production,
    required R Function() uat,
    required R Function() develop,
    required R Function() developTest,
    required R Function() developUat,
    required R Function() preprod,
    required R Function() developPreprod,
  }) {
    switch (this) {
      case Environment.test:
        return test();
      case Environment.production:
        return production();
      case Environment.uat:
        return uat();
      case Environment.develop:
        return develop();
      case Environment.developTest:
        return developTest();
      case Environment.developUat:
        return developUat();
      case Environment.preprod:
        return preprod();
      case Environment.developPreprod:
        return developPreprod();

      default:
        throw Error();
    }
  }

  R? whenOrNull<R>({
    R? Function()? test,
    R? Function()? production,
    R? Function()? uat,
    R? Function()? develop,
    R? Function()? developTest,
    R? Function()? developUat,
    R? Function()? preprod,
    R? Function()? developPreprod,
  }) {
    switch (this) {
      case Environment.test:
        return test?.call();
      case Environment.production:
        return production?.call();
      case Environment.uat:
        return uat?.call();
      case Environment.develop:
        return develop?.call();
      case Environment.developTest:
        return developTest?.call();
      case Environment.developUat:
        return developUat?.call();
      case Environment.preprod:
        return preprod?.call();
      case Environment.developPreprod:
        return developPreprod?.call();

      default:
        return null;
    }
  }

  R maybeWhen<R>({
    R Function()? test,
    R Function()? production,
    R Function()? uat,
    R Function()? develop,
    R Function()? developTest,
    R Function()? developUat,
    R Function()? preprod,
    R Function()? developPreprod,
    required R orElse(),
  }) {
    if (this == Environment.test && test != null) {
      return test();
    }
    if (this == Environment.production && production != null) {
      return production();
    }
    if (this == Environment.uat && uat != null) {
      return uat();
    }
    if (this == Environment.develop && develop != null) {
      return develop();
    }
    if (this == Environment.developTest && developTest != null) {
      return developTest();
    }
    if (this == Environment.developUat && developUat != null) {
      return developUat();
    }
    if (this == Environment.preprod && preprod != null) {
      return preprod();
    }
    if (this == Environment.developPreprod && developPreprod != null) {
      return developPreprod();
    }

    return orElse();
  }
}
