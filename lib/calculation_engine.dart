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
    buffer.write('公式：$formula');
    if (warning != null) buffer.write('\n提示：$warning');
    return buffer.toString();
  }
}

class PipeCalculator {
  static const densities = <String, double>{
    '碳钢': 7850,
    '304 不锈钢': 7930,
    '316 不锈钢': 7980,
    '铝': 2700,
    '紫铜': 8960,
    'PVC': 1400,
  };

  static CalculationResult elbow({
    required double offset,
    required double angle,
    double left = 0,
    double right = 0,
    int decimals = 2,
  }) {
    _positive(offset, '目标偏移量');
    _angle(angle);
    _nonNegative(left, '左端扣除');
    _nonNegative(right, '右端扣除');
    final radians = angle * math.pi / 180;
    final travel = offset / math.sin(radians);
    final advance = offset / math.tan(radians);
    final net = travel - left - right;
    return CalculationResult(
      primaryLabel: '净切管长度',
      primaryValue: '${_f(net, decimals)} mm',
      values: {
        '斜管中心线行程': '${_f(travel, decimals)} mm',
        '水平推进量': '${_f(advance, decimals)} mm',
        '总扣除量': '${_f(left + right, decimals)} mm',
        '净切管长度': '${_f(net, decimals)} mm',
      },
      formula: '行程 = 偏移量 ÷ sin($angle°)',
      warning: net <= 0 ? '管件扣除量超过中心线行程，请复核尺寸。' : null,
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
      throw const FormatException('水平偏移和垂直偏移不能同时为 0');
    }
    _angle(angle);
    _nonNegative(left, '左端扣除');
    _nonNegative(right, '右端扣除');
    final real = math.sqrt(horizontal * horizontal + vertical * vertical);
    final roll = math.atan2(vertical.abs(), horizontal.abs()) * 180 / math.pi;
    final travel = real / math.sin(angle * math.pi / 180);
    final net = travel - left - right;
    final hasNegative = horizontal < 0 || vertical < 0;
    return CalculationResult(
      primaryLabel: '净切管长度',
      primaryValue: '${_f(net, decimals)} mm',
      values: {
        '真实偏移量': '${_f(real, decimals)} mm',
        '滚动角': '${_f(roll, decimals)}°',
        '中心线行程': '${_f(travel, decimals)} mm',
        '净切管长度': '${_f(net, decimals)} mm',
      },
      formula: '真实偏移 = √(H² + V²)，行程 = 真实偏移 ÷ sin($angle°)',
      warning: net <= 0
          ? '管件扣除量超过中心线行程，请复核尺寸。'
          : hasNegative
          ? '已按绝对尺寸计算，请确认现场偏移方向。'
          : null,
    );
  }

  static CalculationResult cut({
    required double center,
    required double left,
    required double right,
    int decimals = 2,
  }) {
    _positive(center, '中心距');
    _nonNegative(left, '左端扣除');
    _nonNegative(right, '右端扣除');
    final net = center - left - right;
    return CalculationResult(
      primaryLabel: '净切管长度',
      primaryValue: '${_f(net, decimals)} mm',
      values: {
        '两连接点中心距': '${_f(center, decimals)} mm',
        '总扣除量': '${_f(left + right, decimals)} mm',
        '净切管长度': '${_f(net, decimals)} mm',
      },
      formula: '净切管长度 = 中心距 − 左端扣除 − 右端扣除',
      warning: net <= 0 ? '扣除量超过中心距，当前结果不可用于下料。' : null,
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
    _positive(diameter, '外径');
    _positive(thickness, '壁厚');
    _positive(length, '长度');
    _positive(density, '材料密度');
    if (thickness >= diameter / 2) {
      throw const FormatException('壁厚必须小于外径的一半');
    }
    if (quantity <= 0) throw const FormatException('数量必须为正整数');
    final inner = diameter - thickness * 2;
    final area =
        math.pi /
        4 *
        (math.pow(diameter / 1000, 2) - math.pow(inner / 1000, 2));
    final perMeter = area * density;
    final one = perMeter * length;
    final total = one * quantity;
    final values = <String, String>{
      '内径': '${_f(inner, decimals)} mm',
      '截面积': '${_f(area * 1000000, decimals)} mm²',
      '每米理论重量': '${_f(perMeter, decimals)} kg/m',
      '单根重量': '${_f(one, decimals)} kg',
      '总长度': '${_f(length * quantity, decimals)} m',
      '总重量': '${_f(total, decimals)} kg',
    };
    if (pricePerKg != null && pricePerKg > 0) {
      values['估算材料成本'] = '¥${_f(total * pricePerKg, 2)}';
    }
    return CalculationResult(
      primaryLabel: '总重量',
      primaryValue: '${_f(total, decimals)} kg',
      values: values,
      formula: '截面积 = π/4 × (外径² − 内径²)，重量 = 截面积 × 长度 × 密度',
      warning: '理论重量受材料牌号、制造公差、涂层和实际尺寸影响。',
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
    _positive(distanceMm, '总距离');
    _positive(intervalMm, '测点间距');
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
      primaryLabel: descending ? '总落差' : '总升高',
      primaryValue: '${descending ? '−' : '+'}${_f(dropMm.abs(), 3)} mm',
      values: {
        descending ? '总落差' : '总升高':
            '${descending ? '−' : '+'}${_f(dropMm.abs(), 3)} mm',
        '终点标高': '${_f(endElevation, decimals)} m',
        '坡度等价':
            '${_f(slopePercent, 2)}% · ${_f(rate * 1000, 2)}‰ · ${_f(rate * 1000, 2)} mm/m · $ratio · ${_f(degrees, 3)}°',
      },
      formula: '测点标高 = 起点标高 ${descending ? '−' : '+'} 距离 × 坡度',
      table: table,
    );
  }

  static CalculationResult slopeDrop({
    required double distanceMm,
    required double slopePercent,
    int decimals = 2,
  }) {
    _positive(distanceMm, '水平距离');
    final rate = slopePercent / 100;
    final drop = distanceMm * rate;
    return _slopeSummary(
      rate: rate,
      primaryLabel: '落差',
      primaryValue: '${_f(drop, decimals)} mm',
      values: {
        '水平距离': '${_f(distanceMm, decimals)} mm',
        '落差': '${_f(drop, decimals)} mm',
      },
      formula: '落差 = 水平距离 × 坡度',
      decimals: decimals,
    );
  }

  static CalculationResult slopeFromDrop({
    required double distanceMm,
    required double dropMm,
    int decimals = 2,
  }) {
    _positive(distanceMm, '水平距离');
    final rate = dropMm / distanceMm;
    return _slopeSummary(
      rate: rate,
      primaryLabel: '坡度',
      primaryValue: '${_f(rate * 100, decimals)}%',
      values: {
        '水平距离': '${_f(distanceMm, decimals)} mm',
        '落差': '${_f(dropMm, decimals)} mm',
      },
      formula: '坡度 = 落差 ÷ 水平距离',
      decimals: decimals,
    );
  }

  static CalculationResult slopeFromElevations({
    required double startElevation,
    required double endElevation,
    required double distanceMm,
    int decimals = 2,
  }) {
    _positive(distanceMm, '水平距离');
    final differenceMm = (endElevation - startElevation) * 1000;
    final rate = differenceMm / distanceMm;
    return _slopeSummary(
      rate: rate,
      primaryLabel: rate < 0 ? '下降坡度' : '上升坡度',
      primaryValue: '${_f(rate.abs() * 100, decimals)}%',
      values: {
        '起点标高': '${_f(startElevation, 3)} m',
        '终点标高': '${_f(endElevation, 3)} m',
        '高差': '${differenceMm >= 0 ? '+' : ''}${_f(differenceMm, decimals)} mm',
      },
      formula: '坡度 = (终点标高 − 起点标高) ÷ 水平距离',
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
    values['坡度等价'] =
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
      throw const FormatException('角度必须大于 0° 且小于 90°');
    }
  }

  static void _positive(num value, String name) {
    if (!value.isFinite || value <= 0) throw FormatException('$name必须大于 0');
  }

  static void _nonNegative(num value, String name) {
    if (!value.isFinite || value < 0) throw FormatException('$name不能小于 0');
  }

  static String _f(num value, int decimals) => value.toStringAsFixed(decimals);
}
