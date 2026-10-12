import 'app_language.dart';
import 'dart:math' as math;

class CalculationResult {
  const CalculationResult({
    required this.primaryLabel,
    required this.primaryValue,
    required this.values,
    required this.formula,
    this.warning,
    this.table = const [],
  });

  final String primaryLabel;
  final String primaryValue;
  final Map<String, String> values;
  final String formula;
  final String? warning;
  final List<MapEntry<String, String>> table;

  String asText(String title) {
    final buffer = StringBuffer('$title\n');
    for (final entry in values.entries) {
      buffer.writeln('${entry.key}：${entry.value}');
    }
    for (final row in table) {
      buffer.writeln('${row.key}：${row.value}');
    }
    buffer.write(AppStrings.formula(formula));
    if (warning != null) buffer.write(AppStrings.note(warning));
    return buffer.toString();
  }
}

class PipeCalculator {
  static const densities = <String, double>{
    AppStrings.carbonSteel: 7850,
    AppStrings.label304StainlessSteel: 7930,
    AppStrings.label316StainlessSteel: 7980,
    AppStrings.aluminum: 2700,
    AppStrings.copper: 8960,
    'PVC': 1400,
  };

  static CalculationResult elbow({
    required double offset,
    required double angle,
    double left = 0,
    double right = 0,
    int decimals = 2,
  }) {
    _positive(offset, AppStrings.offset);
    _angle(angle);
    _nonNegative(left, AppStrings.leftTakeOff);
    _nonNegative(right, AppStrings.rightTakeOff);
    final radians = angle * math.pi / 180;
    final travel = offset / math.sin(radians);
    final advance = offset / math.tan(radians);
    final net = travel - left - right;
    return CalculationResult(
      primaryLabel: AppStrings.netCutLength,
      primaryValue: '${_f(net, decimals)} mm',
      values: {
        AppStrings.centerlineTravel: '${_f(travel, decimals)} mm',
        AppStrings.horizontalAdvance: '${_f(advance, decimals)} mm',
        AppStrings.totalTakeOff: '${_f(left + right, decimals)} mm',
        AppStrings.netCutLength: '${_f(net, decimals)} mm',
      },
      formula: AppStrings.travelOffsetSin(angle),
      warning: net <= 0
          ? AppStrings
                .fittingTakeOffsExceedTheCenterlineTravelCheckTheDimensions
          : null,
    );
  }

  static CalculationResult rolling({
    required double horizontal,
    required double vertical,
    required double angle,
    double left = 0,
    double right = 0,
    int decimals = 2,
  }) {
    if (horizontal == 0 && vertical == 0) {
      throw const FormatException(
        AppStrings.horizontalAndVerticalOffsetsCannotBothBeZero,
      );
    }
    _angle(angle);
    _nonNegative(left, AppStrings.leftTakeOff);
    _nonNegative(right, AppStrings.rightTakeOff);
    final real = math.sqrt(horizontal * horizontal + vertical * vertical);
    final roll = math.atan2(vertical.abs(), horizontal.abs()) * 180 / math.pi;
    final travel = real / math.sin(angle * math.pi / 180);
    final net = travel - left - right;
    final hasNegative = horizontal < 0 || vertical < 0;
    return CalculationResult(
      primaryLabel: AppStrings.netCutLength,
      primaryValue: '${_f(net, decimals)} mm',
      values: {
        AppStrings.trueOffset: '${_f(real, decimals)} mm',
        AppStrings.rollAngle: '${_f(roll, decimals)}°',
        AppStrings.centerlineTravelHeaa717: '${_f(travel, decimals)} mm',
        AppStrings.netCutLength: '${_f(net, decimals)} mm',
      },
      formula: AppStrings.trueOffsetHVTravelTrueOffsetSin(angle),
      warning: net <= 0
          ? AppStrings
                .fittingTakeOffsExceedTheCenterlineTravelCheckTheDimensions
          : hasNegative
          ? AppStrings
                .calculatedFromAbsoluteDimensionsCheckTheOffsetDirectionOnSite
          : null,
    );
  }

  static CalculationResult cut({
    required double center,
    required double left,
    required double right,
    int decimals = 2,
  }) {
    _positive(center, AppStrings.centerDistance);
    _nonNegative(left, AppStrings.leftTakeOff);
    _nonNegative(right, AppStrings.rightTakeOff);
    final net = center - left - right;
    return CalculationResult(
      primaryLabel: AppStrings.netCutLength,
      primaryValue: '${_f(net, decimals)} mm',
      values: {
        AppStrings.centerToCenterDistance: '${_f(center, decimals)} mm',
        AppStrings.totalTakeOff: '${_f(left + right, decimals)} mm',
        AppStrings.netCutLength: '${_f(net, decimals)} mm',
      },
      formula: AppStrings.netCutLengthCenterDistanceLeftTakeOffRightTakeOff,
      warning: net <= 0
          ? AppStrings
                .takeOffsExceedTheCenterDistanceDoNotUseThisResultForCutting
          : null,
    );
  }

  static CalculationResult weight({
    required double diameter,
    required double thickness,
    required double length,
    required int quantity,
    required double density,
    double? pricePerKg,
    int decimals = 2,
  }) {
    _positive(diameter, AppStrings.outsideDiameter);
    _positive(thickness, AppStrings.wallThickness);
    _positive(length, AppStrings.length);
    _positive(density, AppStrings.materialDensity);
    if (thickness >= diameter / 2) {
      throw const FormatException(
        AppStrings.wallThicknessMustBeLessThanHalfTheOutsideDiameter,
      );
    }
    if (quantity <= 0) {
      throw const FormatException(
        AppStrings.quantityMustBeAPositiveWholeNumber,
      );
    }
    final inner = diameter - thickness * 2;
    final area =
        math.pi /
        4 *
        (math.pow(diameter / 1000, 2) - math.pow(inner / 1000, 2));
    final perMeter = area * density;
    final one = perMeter * length;
    final total = one * quantity;
    final values = <String, String>{
      AppStrings.insideDiameter: '${_f(inner, decimals)} mm',
      AppStrings.crossSectionalArea: '${_f(area * 1000000, decimals)} mm²',
      AppStrings.weightPerMetre: '${_f(perMeter, decimals)} kg/m',
      AppStrings.weightPerPipe: '${_f(one, decimals)} kg',
      AppStrings.totalLength: '${_f(length * quantity, decimals)} m',
      AppStrings.totalWeight: '${_f(total, decimals)} kg',
    };
    if (pricePerKg != null && pricePerKg > 0) {
      values[AppStrings.estimatedMaterialCost] =
          '${useEnglish ? '' : '¥'}${_f(total * pricePerKg, 2)}';
    }
    return CalculationResult(
      primaryLabel: AppStrings.totalWeight,
      primaryValue: '${_f(total, decimals)} kg',
      values: values,
      formula: AppStrings.area4ODIDWeightAreaLengthDensity,
      warning: AppStrings
          .theoreticalWeightVariesWithMaterialGradeTolerancesCoatingsAndActualDim,
    );
  }

  static CalculationResult slope({
    required double startElevation,
    required double slopePercent,
    required double distanceMm,
    required double intervalMm,
    required bool descending,
    int decimals = 3,
  }) {
    _positive(distanceMm, AppStrings.totalDistance);
    _positive(intervalMm, AppStrings.pointSpacing);
    final rate = slopePercent / 100;
    final dropMm = distanceMm * rate;
    final sign = descending ? -1 : 1;
    final table = <MapEntry<String, String>>[];
    var x = 0.0;
    while (x < distanceMm && table.length < 1000) {
      final elevation = startElevation + sign * (x / 1000) * rate;
      table.add(MapEntry('${_f(x, 0)} mm', '${_f(elevation, decimals)} m'));
      x += intervalMm;
    }
    final endElevation = startElevation + sign * (distanceMm / 1000) * rate;
    table.add(
      MapEntry('${_f(distanceMm, 0)} mm', '${_f(endElevation, decimals)} m'),
    );
    final ratio = rate == 0 ? '—' : '1:${_f(1 / rate.abs(), 2)}';
    final degrees = math.atan(rate) * 180 / math.pi;
    return CalculationResult(
      primaryLabel: descending ? AppStrings.totalFall : AppStrings.totalRise,
      primaryValue: '${descending ? '−' : '+'}${_f(dropMm.abs(), 3)} mm',
      values: {
        descending ? AppStrings.totalFall : AppStrings.totalRise:
            '${descending ? '−' : '+'}${_f(dropMm.abs(), 3)} mm',
        AppStrings.endElevation: '${_f(endElevation, decimals)} m',
        AppStrings.equivalentSlope:
            '${_f(slopePercent, 2)}% · ${_f(rate * 1000, 2)}‰ · ${_f(rate * 1000, 2)} mm/m · $ratio · ${_f(degrees, 3)}°',
      },
      formula: AppStrings.pointElevationStartElevationDistanceSlope(
        descending ? '−' : '+',
      ),
      table: table,
    );
  }

  static CalculationResult slopeDrop({
    required double distanceMm,
    required double slopePercent,
    int decimals = 2,
  }) {
    _positive(distanceMm, AppStrings.horizontalDistance);
    final rate = slopePercent / 100;
    final drop = distanceMm * rate;
    return _slopeSummary(
      rate: rate,
      primaryLabel: AppStrings.fall,
      primaryValue: '${_f(drop, decimals)} mm',
      values: {
        AppStrings.horizontalDistance: '${_f(distanceMm, decimals)} mm',
        AppStrings.fall: '${_f(drop, decimals)} mm',
      },
      formula: AppStrings.fallHorizontalDistanceSlope,
      decimals: decimals,
    );
  }

  static CalculationResult slopeFromDrop({
    required double distanceMm,
    required double dropMm,
    int decimals = 2,
  }) {
    _positive(distanceMm, AppStrings.horizontalDistance);
    final rate = dropMm / distanceMm;
    return _slopeSummary(
      rate: rate,
      primaryLabel: AppStrings.slope,
      primaryValue: '${_f(rate * 100, decimals)}%',
      values: {
        AppStrings.horizontalDistance: '${_f(distanceMm, decimals)} mm',
        AppStrings.fall: '${_f(dropMm, decimals)} mm',
      },
      formula: AppStrings.slopeFallHorizontalDistance,
      decimals: decimals,
    );
  }

  static CalculationResult slopeFromElevations({
    required double startElevation,
    required double endElevation,
    required double distanceMm,
    int decimals = 2,
  }) {
    _positive(distanceMm, AppStrings.horizontalDistance);
    final differenceMm = (endElevation - startElevation) * 1000;
    final rate = differenceMm / distanceMm;
    return _slopeSummary(
      rate: rate,
      primaryLabel: rate < 0
          ? AppStrings.downwardSlope
          : AppStrings.upwardSlope,
      primaryValue: '${_f(rate.abs() * 100, decimals)}%',
      values: {
        AppStrings.startElevation: '${_f(startElevation, 3)} m',
        AppStrings.endElevation: '${_f(endElevation, 3)} m',
        AppStrings.elevationChange:
            '${differenceMm >= 0 ? '+' : ''}${_f(differenceMm, decimals)} mm',
      },
      formula: AppStrings.slopeEndElevationStartElevationHorizontalDistance,
      decimals: decimals,
    );
  }

  static CalculationResult _slopeSummary({
    required double rate,
    required String primaryLabel,
    required String primaryValue,
    required Map<String, String> values,
    required String formula,
    required int decimals,
  }) {
    final ratio = rate == 0 ? '—' : '1:${_f(1 / rate.abs(), 2)}';
    final degrees = math.atan(rate.abs()) * 180 / math.pi;
    values[AppStrings.equivalentSlope] =
        '${_f(rate.abs() * 100, decimals)}% · ${_f(rate.abs() * 1000, decimals)}‰ · ${_f(rate.abs() * 1000, decimals)} mm/m · $ratio · ${_f(degrees, 3)}°';
    return CalculationResult(
      primaryLabel: primaryLabel,
      primaryValue: primaryValue,
      values: values,
      formula: formula,
    );
  }

  static void _angle(double value) {
    if (value <= 0 || value >= 90) {
      throw const FormatException(
        AppStrings.angleMustBeGreaterThan0AndLessThan90,
      );
    }
  }

  static void _positive(num value, String name) {
    if (!value.isFinite || value <= 0) {
      throw FormatException(AppStrings.mustBeGreaterThanZero(name));
    }
  }

  static void _nonNegative(num value, String name) {
    if (!value.isFinite || value < 0) {
      throw FormatException(AppStrings.cannotBeNegative(name));
    }
  }

  static String _f(num value, int decimals) => value.toStringAsFixed(decimals);
}
