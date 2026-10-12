import 'package:guansuantong_pipe_calculator/app_language.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guansuantong_pipe_calculator/calculation_engine.dart';

void main() {
  group('pipe calculation acceptance samples', () {
    test('single plane elbow offset', () {
      final result = PipeCalculator.elbow(
        offset: 500,
        angle: 45,
        left: 50,
        right: 50,
        decimals: 2,
      );
      expect(result.values[AppStrings.centerlineTravel], '707.11 mm');
      expect(result.primaryValue, '607.11 mm');
    });

    test('rolling offset', () {
      final result = PipeCalculator.rolling(
        horizontal: 300,
        vertical: 400,
        angle: 45,
        left: 50,
        right: 50,
        decimals: 2,
      );
      expect(result.values[AppStrings.trueOffset], '500.00 mm');
      expect(result.values[AppStrings.rollAngle], '53.13°');
      expect(result.primaryValue, '607.11 mm');
    });

    test('slope and elevation table', () {
      final result = PipeCalculator.slope(
        startElevation: 100,
        slopePercent: 2,
        distanceMm: 5000,
        intervalMm: 1000,
        descending: true,
      );
      expect(result.primaryValue, '−100.000 mm');
      expect(result.table.last.value, '99.900 m');
      expect(result.table.length, 6);
    });

    test('slope solve modes', () {
      final drop = PipeCalculator.slopeDrop(distanceMm: 10000, slopePercent: 2);
      expect(drop.primaryValue, '200.00 mm');

      final rate = PipeCalculator.slopeFromDrop(distanceMm: 10000, dropMm: 200);
      expect(rate.primaryValue, '2.00%');

      final elevation = PipeCalculator.slopeFromElevations(
        startElevation: 100,
        endElevation: 99.8,
        distanceMm: 10000,
      );
      expect(elevation.primaryValue, '2.00%');
    });

    test('cut length', () {
      final result = PipeCalculator.cut(center: 1200, left: 75, right: 90);
      expect(result.primaryValue, '1035.00 mm');
    });

    test('pipe weight', () {
      final result = PipeCalculator.weight(
        diameter: 60,
        thickness: 3,
        length: 6,
        quantity: 1,
        density: 7850,
        decimals: 2,
      );
      expect(result.values[AppStrings.weightPerMetre], '4.22 kg/m');
      expect(result.primaryValue, '25.30 kg');
    });
  });

  group('invalid input handling', () {
    test('rejects invalid angle', () {
      expect(
        () => PipeCalculator.elbow(offset: 500, angle: 0),
        throwsFormatException,
      );
    });

    test('warns when fitting deductions exceed travel', () {
      final result = PipeCalculator.cut(center: 100, left: 60, right: 50);
      expect(result.warning, isNotNull);
    });

    test('rejects impossible wall thickness', () {
      expect(
        () => PipeCalculator.weight(
          diameter: 60,
          thickness: 30,
          length: 6,
          quantity: 1,
          density: 7850,
        ),
        throwsFormatException,
      );
    });
  });
}
