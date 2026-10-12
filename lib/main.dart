import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import 'app_state.dart';
import 'calculation_engine.dart';

const _green = Color(0xFF0D5C4D);
const _orange = Color(0xFFE56D35);
const _paper = Color(0xFFF5F2EA);
const _muted = Color(0xFF68736F);
const _screenshotChannel = MethodChannel(
  'guansuantong_pipe_calculator/screenshot_config',
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final scene = await _resolveScreenshotScene();
  await AppState.instance.load();
  if (scene != null) {
    AppState.instance.loadScreenshotData();
  }
  runApp(PipeQuickCalcApp(screenshotScene: scene));
}

class PipeQuickCalcApp extends StatelessWidget {
  const PipeQuickCalcApp({super.key, this.screenshotScene});
  final String? screenshotScene;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (context, _) {
        final state = AppState.instance;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: '管算通',
          themeMode: state.themeMode,
          theme: _theme(Brightness.light),
          darkTheme: _theme(Brightness.dark),
          home: screenshotScene != null
              ? _ScreenshotScenePage(scene: screenshotScene!)
              : state.onboardingDone
              ? const HomeShell()
              : const OnboardingPage(),
        );
      },
    );
  }
}

ThemeData _theme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final scheme = ColorScheme.fromSeed(
    seedColor: _green,
    brightness: brightness,
    primary: dark ? const Color(0xFF7BC7B3) : _green,
    secondary: _orange,
    surface: dark ? const Color(0xFF151C1A) : _paper,
  );
  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    fontFamily: Platform.isIOS ? '.SF Pro Text' : null,
    dividerColor: dark ? Colors.white12 : const Color(0x1A17221F),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: dark ? Colors.white.withValues(alpha: .06) : Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      errorMaxLines: 2,
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 68,
      backgroundColor: dark ? const Color(0xFF101614) : const Color(0xFFFBFAF6),
      indicatorColor: scheme.primary.withValues(alpha: .12),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      ),
    ),
  );
}

Future<String?> _resolveScreenshotScene() async {
  if (Platform.environment['APP_STORE_SCREENSHOT_MODE'] == '1') {
    return Platform.environment['APP_STORE_SCREENSHOT_SCENE'];
  }
  try {
    return await _screenshotChannel.invokeMethod<String>('getInitialScene');
  } catch (_) {
    return null;
  }
}

class _ScreenshotScenePage extends StatelessWidget {
  const _ScreenshotScenePage({required this.scene});
  final String scene;
  @override
  Widget build(BuildContext context) {
    const map = {
      'rolling-offset': '滚动偏移',
      'slope-elevation': '坡度标高',
      'cut-length': '切管长度',
      'pipe-weight': '管材重量',
    };
    if (map.containsKey(scene)) return CalculatorPage(type: map[scene]!);
    return HomeShell(initialIndex: scene == 'projects' ? 1 : 0);
  }
}

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _green,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      CupertinoIcons.wrench_fill,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    '管算通',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                '现场尺寸，\n算清再下料。',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  height: 1.12,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '弯头偏移、坡度标高、切管长度与管材重量，一次买断，完全离线。',
                style: TextStyle(fontSize: 16, height: 1.6, color: _muted),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    width: double.infinity,
                    color: _green.withValues(alpha: .08),
                    padding: const EdgeInsets.all(16),
                    child: Image.asset(
                      'assets/generated/rolling_offset.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Row(
                children: [
                  Icon(
                    CupertinoIcons.lock_shield_fill,
                    size: 18,
                    color: _green,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '数据只保存在本机。结果用于放样辅助，切割与安装前请由专业人员复核。',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.45,
                        color: _muted,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: AppState.instance.completeOnboarding,
                  style: FilledButton.styleFrom(backgroundColor: _green),
                  child: const Text(
                    '使用公制开始',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, this.initialIndex = 0});
  final int initialIndex;
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  late int index = widget.initialIndex;
  @override
  Widget build(BuildContext context) {
    final pages = [
      const CalculatorHome(),
      const ProjectsPage(),
      const ReferencePage(),
      const SettingsPage(),
    ];
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: index, children: pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(CupertinoIcons.function),
            label: '计算',
          ),
          NavigationDestination(icon: Icon(CupertinoIcons.folder), label: '项目'),
          NavigationDestination(icon: Icon(CupertinoIcons.book), label: '参考'),
          NavigationDestination(icon: Icon(CupertinoIcons.gear), label: '设置'),
        ],
      ),
    );
  }
}

const _tools = <_Tool>[
  _Tool('弯头偏移', '单平面放样', 'assets/generated/elbow_offset.png'),
  _Tool('滚动偏移', '水平 + 垂直偏移', 'assets/generated/rolling_offset.png'),
  _Tool('坡度标高', '落差与测点表', 'assets/generated/slope_elevation.png'),
  _Tool('切管长度', '中心距扣除', 'assets/generated/cut_length.png'),
  _Tool('管材重量', '理论重量估算', 'assets/generated/pipe_weight.png'),
];

class _Tool {
  const _Tool(this.name, this.subtitle, this.asset);
  final String name;
  final String subtitle;
  final String asset;
}

void _openCalculator(BuildContext context, String type) {
  Navigator.of(
    context,
  ).push(CupertinoPageRoute(builder: (_) => CalculatorPage(type: type)));
}

class CalculatorHome extends StatelessWidget {
  const CalculatorHome({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) => CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '管算通',
                          style: TextStyle(
                            fontSize: 29,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          '现场常用计算 · 公制',
                          style: TextStyle(fontSize: 13, color: _muted),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _green.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '离线',
                      style: TextStyle(
                        color: _green,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 214,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
                scrollDirection: Axis.horizontal,
                itemCount: _tools.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, i) {
                  final tool = _tools[i];
                  return _FeaturedTool(
                    tool: tool,
                    onTap: () => _openCalculator(context, tool.name),
                  );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(child: _SectionTitle('全部计算器')),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
            sliver: SliverList.separated(
              itemCount: _tools.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final tool = _tools[i];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 5),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ColoredBox(
                      color: _green.withValues(alpha: .08),
                      child: SizedBox(
                        width: 48,
                        height: 48,
                        child: Image.asset(tool.asset, fit: BoxFit.contain),
                      ),
                    ),
                  ),
                  title: Text(
                    tool.name,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(tool.subtitle),
                  trailing: const Icon(CupertinoIcons.chevron_right, size: 16),
                  onTap: () => _openCalculator(context, tool.name),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: _SectionTitle(
              '最近结果',
              action: state.records.isEmpty
                  ? null
                  : '${state.records.length} 条',
            ),
          ),
          SliverToBoxAdapter(
            child: state.records.isEmpty
                ? const Padding(
                    padding: EdgeInsets.fromLTRB(20, 12, 20, 28),
                    child: Text(
                      '完成一次计算后，结果会自动保存在这里。',
                      style: TextStyle(color: _muted),
                    ),
                  )
                : Column(
                    children: state.records.take(3).map((record) {
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        title: Text(
                          record.type,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          record.summary,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          _shortTime(record.createdAt),
                          style: const TextStyle(fontSize: 11, color: _muted),
                        ),
                        onTap: () => _showRecord(context, record),
                      );
                    }).toList(),
                  ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _FeaturedTool extends StatelessWidget {
  const _FeaturedTool({required this.tool, required this.onTap});
  final _Tool tool;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${tool.name}，${tool.subtitle}',
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          width: 158,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Hero(
                    tag: tool.name,
                    child: Image.asset(
                      tool.asset,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tool.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tool.subtitle,
                      style: const TextStyle(fontSize: 12, color: _muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title, {this.action});
  final String title;
  final String? action;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
    child: Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const Spacer(),
        if (action != null)
          Text(action!, style: const TextStyle(fontSize: 12, color: _muted)),
      ],
    ),
  );
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key, required this.type});
  final String type;
  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> c;
  double angle = 45;
  int slopeMode = 3;
  bool descending = true;
  String material = '碳钢';
  CalculationResult? result;
  String? error;
  bool sharing = false;
  final _shareButtonKey = GlobalKey();

  _Tool get tool => _tools.firstWhere((item) => item.name == widget.type);

  @override
  void initState() {
    super.initState();
    c = {
      'offset': TextEditingController(text: '500'),
      'horizontal': TextEditingController(text: '600'),
      'vertical': TextEditingController(text: '300'),
      'left': TextEditingController(text: widget.type == '切管长度' ? '90' : '50'),
      'right': TextEditingController(text: widget.type == '切管长度' ? '95' : '50'),
      'center': TextEditingController(text: '3200'),
      'elevation': TextEditingController(text: '100.000'),
      'slope': TextEditingController(text: '1.50'),
      'distance': TextEditingController(text: '12000'),
      'interval': TextEditingController(text: '1500'),
      'diameter': TextEditingController(text: '114.3'),
      'thickness': TextEditingController(text: '4.5'),
      'length': TextEditingController(text: '6'),
      'quantity': TextEditingController(text: '10'),
      'price': TextEditingController(),
      'angle': TextEditingController(text: '37.5'),
      'drop': TextEditingController(text: '200'),
      'endElevation': TextEditingController(text: '99.800'),
    };
    for (final controller in c.values) {
      controller.addListener(_calculate);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _calculate());
  }

  @override
  void dispose() {
    for (final controller in c.values) {
      controller.dispose();
    }
    super.dispose();
  }

  double _n(String key) => double.parse(c[key]!.text.trim());

  void _calculate() {
    try {
      final decimals = AppState.instance.decimals;
      final next = switch (widget.type) {
        '弯头偏移' => PipeCalculator.elbow(
          offset: _n('offset'),
          angle: angle == 0 ? _n('angle') : angle,
          left: _n('left'),
          right: _n('right'),
          decimals: decimals,
        ),
        '滚动偏移' => PipeCalculator.rolling(
          horizontal: _n('horizontal'),
          vertical: _n('vertical'),
          angle: angle == 0 ? _n('angle') : angle,
          left: _n('left'),
          right: _n('right'),
          decimals: decimals,
        ),
        '坡度标高' => switch (slopeMode) {
          0 => PipeCalculator.slopeDrop(
            distanceMm: _n('distance'),
            slopePercent: _n('slope'),
            decimals: decimals,
          ),
          1 => PipeCalculator.slopeFromDrop(
            distanceMm: _n('distance'),
            dropMm: _n('drop'),
            decimals: decimals,
          ),
          2 => PipeCalculator.slopeFromElevations(
            startElevation: _n('elevation'),
            endElevation: _n('endElevation'),
            distanceMm: _n('distance'),
            decimals: decimals,
          ),
          _ => PipeCalculator.slope(
            startElevation: _n('elevation'),
            slopePercent: _n('slope'),
            distanceMm: _n('distance'),
            intervalMm: _n('interval'),
            descending: descending,
            decimals: decimals.clamp(1, 3),
          ),
        },
        '切管长度' => PipeCalculator.cut(
          center: _n('center'),
          left: _n('left'),
          right: _n('right'),
          decimals: decimals,
        ),
        _ => PipeCalculator.weight(
          diameter: _n('diameter'),
          thickness: _n('thickness'),
          length: _n('length'),
          quantity: int.parse(c['quantity']!.text.trim()),
          density: PipeCalculator.densities[material]!,
          pricePerKg: c['price']!.text.trim().isEmpty ? null : _n('price'),
          decimals: decimals,
        ),
      };
      if (mounted) {
        setState(() {
          result = next;
          error = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          result = null;
          error = e is FormatException ? e.message.toString() : '请检查输入数值';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.type,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        actions: [
          AnimatedBuilder(
            animation: state,
            builder: (context, _) => IconButton(
              tooltip: state.favorites.contains(widget.type) ? '取消收藏' : '收藏',
              onPressed: () => state.toggleFavorite(widget.type),
              icon: Icon(
                state.favorites.contains(widget.type)
                    ? CupertinoIcons.star_fill
                    : CupertinoIcons.star,
              ),
              color: state.favorites.contains(widget.type) ? _orange : null,
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
          children: [
            Container(
              height: 176,
              decoration: BoxDecoration(
                color: _green.withValues(alpha: .07),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Hero(
                tag: widget.type,
                child: Image.asset(tool.asset, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '输入',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            ..._inputs(),
            const SizedBox(height: 22),
            const Text(
              '计算结果',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOut,
              child: result != null
                  ? _ResultPanel(
                      key: ValueKey(result!.primaryValue),
                      result: result!,
                    )
                  : _ErrorPanel(message: error ?? '请输入完整参数'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLowest,
            border: Border(
              top: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: result == null ? null : _copy,
                  icon: const Icon(CupertinoIcons.doc_on_doc, size: 18),
                  label: const Text('复制'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  key: _shareButtonKey,
                  onPressed: result == null || sharing ? null : _share,
                  icon: sharing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(CupertinoIcons.share, size: 18),
                  label: Text(sharing ? '打开中' : '分享'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: result == null ? null : _save,
                  style: FilledButton.styleFrom(backgroundColor: _green),
                  icon: const Icon(CupertinoIcons.folder_badge_plus, size: 18),
                  label: const Text('保存'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _inputs() {
    final commonAngle = [
      const Text(
        '弯头角度',
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 6,
        children: [22.5, 30.0, 45.0, 60.0, 0.0].map((value) {
          return ChoiceChip(
            label: Text(
              value == 0 ? '自定义' : '${value.toString().replaceAll('.0', '')}°',
            ),
            selected: angle == value,
            showCheckmark: false,
            onSelected: (_) {
              setState(() => angle = value);
              _calculate();
            },
          );
        }).toList(),
      ),
      if (angle == 0) ...[
        const SizedBox(height: 10),
        _field('自定义角度', 'angle', '°'),
      ],
      const SizedBox(height: 14),
    ];
    return switch (widget.type) {
      '弯头偏移' => [
        _field('目标偏移量', 'offset', 'mm'),
        ...commonAngle,
        _field('左端中心至端面', 'left', 'mm'),
        _field('右端中心至端面', 'right', 'mm'),
      ],
      '滚动偏移' => [
        _field('水平偏移 H', 'horizontal', 'mm', signed: true),
        _field('垂直偏移 V', 'vertical', 'mm', signed: true),
        ...commonAngle,
        _field('左端中心至端面', 'left', 'mm'),
        _field('右端中心至端面', 'right', 'mm'),
      ],
      '坡度标高' => [
        DropdownButtonFormField<int>(
          initialValue: slopeMode,
          decoration: const InputDecoration(labelText: '计算模式'),
          items: const [
            DropdownMenuItem(value: 0, child: Text('已知距离和坡度，求落差')),
            DropdownMenuItem(value: 1, child: Text('已知距离和落差，求坡度')),
            DropdownMenuItem(value: 2, child: Text('已知起止标高，求坡度')),
            DropdownMenuItem(value: 3, child: Text('按间距生成测点标高表')),
          ],
          onChanged: (value) {
            setState(() => slopeMode = value!);
            _calculate();
          },
        ),
        const SizedBox(height: 8),
        if (slopeMode == 0) ...[
          _field('水平距离', 'distance', 'mm'),
          _field('坡度', 'slope', '%', signed: true),
        ],
        if (slopeMode == 1) ...[
          _field('水平距离', 'distance', 'mm'),
          _field('落差', 'drop', 'mm', signed: true),
        ],
        if (slopeMode == 2) ...[
          _field('起点标高', 'elevation', 'm', signed: true),
          _field('终点标高', 'endElevation', 'm', signed: true),
          _field('水平距离', 'distance', 'mm'),
        ],
        if (slopeMode == 3) ...[
          _field('起点标高', 'elevation', 'm', signed: true),
          _field('坡度', 'slope', '%'),
          _field('总距离', 'distance', 'mm'),
          _field('测点间距', 'interval', 'mm'),
          const Text(
            '方向',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: true, label: Text('下降')),
              ButtonSegment(value: false, label: Text('上升')),
            ],
            selected: {descending},
            onSelectionChanged: (value) {
              setState(() => descending = value.first);
              _calculate();
            },
          ),
          const SizedBox(height: 14),
        ],
      ],
      '切管长度' => [
        _field('两连接点中心距', 'center', 'mm'),
        _field('左端扣除尺寸', 'left', 'mm'),
        _field('右端扣除尺寸', 'right', 'mm'),
      ],
      _ => [
        _field('外径', 'diameter', 'mm'),
        _field('壁厚', 'thickness', 'mm'),
        _field('单根长度', 'length', 'm'),
        _field('数量', 'quantity', '根', integer: true),
        DropdownButtonFormField<String>(
          initialValue: material,
          decoration: const InputDecoration(labelText: '材料'),
          items: PipeCalculator.densities.entries
              .map(
                (e) => DropdownMenuItem(
                  value: e.key,
                  child: Text('${e.key}  ·  ${e.value.toInt()} kg/m³'),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() => material = value!);
            _calculate();
          },
        ),
        const SizedBox(height: 12),
        _field('参考单价（可选）', 'price', '元/kg'),
      ],
    };
  }

  Widget _field(
    String label,
    String key,
    String unit, {
    bool signed = false,
    bool integer = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c[key],
        keyboardType: TextInputType.numberWithOptions(
          decimal: !integer,
          signed: signed,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp(signed ? r'[-0-9.]' : r'[0-9.]'),
          ),
        ],
        decoration: InputDecoration(labelText: label, suffixText: unit),
      ),
    );
  }

  String get _text => result!.asText(widget.type);

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: _text));
    if (mounted) _toast('结果已复制');
  }

  Future<void> _share() async {
    setState(() => sharing = true);
    try {
      await _shareText(
        anchorContext: _shareButtonKey.currentContext ?? context,
        text: _text,
        title: widget.type,
      );
    } on PlatformException catch (exception) {
      if (mounted) {
        _toast(
          exception.message?.isNotEmpty == true
              ? '无法打开分享：${exception.message}'
              : '无法打开系统分享，请稍后重试',
        );
      }
    } catch (_) {
      if (mounted) _toast('无法打开系统分享，请稍后重试');
    } finally {
      if (mounted) setState(() => sharing = false);
    }
  }

  Future<void> _save() async {
    final state = AppState.instance;
    if (state.projects.isEmpty) {
      await state.addRecord(widget.type, result!.primaryValue, _text);
      if (mounted) _toast('已保存到历史记录');
      return;
    }
    if (!mounted) return;
    final choice = await showModalBottomSheet<String?>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              title: Text(
                '保存计算结果',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              subtitle: Text('可保存到历史或指定项目'),
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.clock),
              title: const Text('仅保存到历史'),
              onTap: () => Navigator.pop(context, ''),
            ),
            ...state.projects.map(
              (project) => ListTile(
                leading: const Icon(CupertinoIcons.folder),
                title: Text(project.name),
                subtitle: Text(project.location),
                onTap: () => Navigator.pop(context, project.id),
              ),
            ),
          ],
        ),
      ),
    );
    if (choice == null) return;
    await state.addRecord(
      widget.type,
      result!.primaryValue,
      _text,
      projectId: choice.isEmpty ? null : choice,
    );
    if (mounted) _toast(choice.isEmpty ? '已保存到历史' : '已加入项目');
  }

  void _toast(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }
}

class _ResultPanel extends StatelessWidget {
  const _ResultPanel({super.key, required this.result});
  final CalculationResult result;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: _green,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                result.primaryLabel,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  result.primaryValue,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 29,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ...result.values.entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 9),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    entry.key,
                    style: const TextStyle(color: _muted, fontSize: 13),
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: Text(
                    entry.value,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (result.table.isNotEmpty) ...[
          const Divider(height: 24),
          const Text('测点标高表', style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          ...result.table.map(
            (row) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Expanded(child: Text(row.key)),
                  Text(
                    row.value,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        ],
        if (result.warning != null)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _orange.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  CupertinoIcons.exclamationmark_triangle,
                  color: _orange,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    result.warning!,
                    style: const TextStyle(fontSize: 12, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 16),
        const Text('计算过程', style: TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Text(
          result.formula,
          style: const TextStyle(color: _muted, height: 1.45),
        ),
      ],
    );
  }
}

class _ErrorPanel extends StatelessWidget {
  const _ErrorPanel({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: _orange.withValues(alpha: .09),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Text(message, style: const TextStyle(color: _orange)),
  );
}

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) => CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _PageHeader(
              title: '项目',
              subtitle: '按现场或区域归档计算结果',
              action: IconButton(
                tooltip: '新建项目',
                onPressed: () => _addProject(context),
                icon: const Icon(
                  CupertinoIcons.add_circled_solid,
                  color: _green,
                ),
              ),
            ),
          ),
          if (state.projects.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyState(
                icon: CupertinoIcons.folder,
                title: '还没有项目',
                detail: '新建项目后，可在计算结果页将记录归档。',
                action: '新建项目',
                onTap: () => _addProject(context),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
              sliver: SliverList.separated(
                itemCount: state.projects.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final project = state.projects[index];
                  final count = state.records
                      .where((record) => record.projectId == project.id)
                      .length;
                  return Dismissible(
                    key: ValueKey(project.id),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (_) =>
                        _confirmDelete(context, '删除项目及其中记录？'),
                    onDismissed: (_) => state.deleteProject(project.id),
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      color: Colors.red,
                      child: const Icon(
                        CupertinoIcons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: ListTile(
                      tileColor: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerLowest,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      contentPadding: const EdgeInsets.all(15),
                      title: Text(
                        project.name,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      subtitle: Text(
                        '${project.location.isEmpty ? '未填写位置' : project.location}  ·  $count 条记录',
                      ),
                      trailing: const Icon(
                        CupertinoIcons.chevron_right,
                        size: 16,
                      ),
                      onTap: () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => ProjectDetailPage(project: project),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class ProjectDetailPage extends StatelessWidget {
  const ProjectDetailPage({super.key, required this.project});
  final PipeProject project;
  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Scaffold(
      appBar: AppBar(title: Text(project.name)),
      body: AnimatedBuilder(
        animation: state,
        builder: (context, _) {
          final records = state.records
              .where((r) => r.projectId == project.id)
              .toList();
          if (records.isEmpty) {
            return const _EmptyState(
              icon: CupertinoIcons.doc,
              title: '项目中暂无记录',
              detail: '打开任一计算器，完成计算后选择“保存”。',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: records.length,
            separatorBuilder: (_, _) => const Divider(),
            itemBuilder: (context, index) {
              final record = records[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  record.type,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(record.summary),
                trailing: Text(
                  _shortTime(record.createdAt),
                  style: const TextStyle(fontSize: 11, color: _muted),
                ),
                onTap: () => _showRecord(context, record),
              );
            },
          );
        },
      ),
    );
  }
}

class ReferencePage extends StatelessWidget {
  const ReferencePage({super.key});
  static const articles = <_Article>[
    _Article(
      '坡度单位换算',
      '百分比、千分比、mm/m、比值与角度',
      CupertinoIcons.arrow_left_right,
      _ReferenceContent.slope,
    ),
    _Article(
      '弯头角度乘数',
      '22.5°、30°、45°、60° 快速复核',
      CupertinoIcons.function,
      _ReferenceContent.elbow,
    ),
    _Article(
      '管材重量公式',
      '圆管截面积与理论重量计算',
      CupertinoIcons.cube_box,
      _ReferenceContent.weight,
    ),
    _Article(
      '现场测量方法',
      '中心距与中心至端面尺寸',
      CupertinoIcons.resize,
      _ReferenceContent.measure,
    ),
    _Article(
      '结果复核清单',
      '切割、焊接、安装前逐项确认',
      CupertinoIcons.check_mark_circled,
      _ReferenceContent.checklist,
    ),
    _Article(
      '安全与责任说明',
      '公式适用范围和使用边界',
      CupertinoIcons.exclamationmark_shield,
      _ReferenceContent.safety,
    ),
  ];
  @override
  Widget build(BuildContext context) => CustomScrollView(
    slivers: [
      const SliverToBoxAdapter(
        child: _PageHeader(title: '参考', subtitle: '自编公式说明与现场复核要点'),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        sliver: SliverList.separated(
          itemCount: articles.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final article = articles[index];
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _green.withValues(alpha: .09),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(article.icon, color: _green, size: 21),
              ),
              title: Text(
                article.title,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(article.subtitle),
              trailing: const Icon(CupertinoIcons.chevron_right, size: 16),
              onTap: () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => _ReferenceDetailPage(article: article),
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}

enum _ReferenceContent { slope, elbow, weight, measure, checklist, safety }

class _Article {
  const _Article(this.title, this.subtitle, this.icon, this.content);
  final String title;
  final String subtitle;
  final IconData icon;
  final _ReferenceContent content;
}

class _ReferenceDetailPage extends StatelessWidget {
  const _ReferenceDetailPage({required this.article});
  final _Article article;
  @override
  Widget build(BuildContext context) {
    final children = switch (article.content) {
      _ReferenceContent.slope => [
        _p('坡度小数 s = 落差 ÷ 水平距离。'),
        _table(const [
          ('表示方式', '换算'),
          ('百分比', 's × 100%'),
          ('千分比', 's × 1000‰'),
          ('毫米每米', 's × 1000 mm/m'),
          ('比值', '1 : (1 ÷ |s|)'),
          ('角度', 'atan(s)'),
        ]),
        _note('示例：2% = 20‰ = 20 mm/m = 1:50 ≈ 1.146°。'),
      ],
      _ReferenceContent.elbow => [
        _p('斜管中心线行程 T = 偏移 O ÷ sin(θ)；推进 A = O ÷ tan(θ)。'),
        _table(const [
          ('角度', '行程乘数 1/sin(θ)'),
          ('22.5°', '2.613'),
          ('30°', '2.000'),
          ('45°', '1.414'),
          ('60°', '1.155'),
        ]),
        _note('乘数只用于快速复核，正式下料仍应使用实际输入和管件扣除尺寸。'),
      ],
      _ReferenceContent.weight => [
        _p('内径 d = 外径 D − 2 × 壁厚 t。'),
        _p('截面积 A = π/4 × (D² − d²)。\n理论重量 = A × 长度 × 密度。'),
        _note('参考密度不是材料验收值；牌号、公差、涂层会影响实际重量。'),
      ],
      _ReferenceContent.measure => [
        _p('中心距：两个连接管件中心线交点之间的距离。'),
        _p('中心至端面：从管件中心线交点量到焊口或连接端面的距离。'),
        _note('不同标准、压力等级、系列和厂家尺寸可能不同，应以现场实物或厂家资料为准。'),
      ],
      _ReferenceContent.checklist => [
        _check('单位是否一致，英制与公制没有混用'),
        _check('测量基准点是否都是中心线或端面'),
        _check('弯头角度、方向和滚动面是否正确'),
        _check('左右管件扣除尺寸是否分别核对'),
        _check('保温、坡口、焊缝收缩或安装余量是否另行考虑'),
        _check('关键尺寸是否由第二人独立复核'),
      ],
      _ReferenceContent.safety => [
        _p('本工具用于现场几何、坡度和理论重量的计算辅助，不替代设计、审图、验收或专业人员签字。'),
        _p('本工具不提供承压等级、材料适用性、焊接工艺或施工合规结论。'),
        _note('施工、切割、焊接和安装前，必须由具备相应能力的人员结合图纸、规范与现场条件复核。'),
      ],
    };
    return Scaffold(
      appBar: AppBar(title: Text(article.title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
        children: [
          Text(
            article.subtitle,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  static Widget _p(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Text(text, style: const TextStyle(fontSize: 15, height: 1.6)),
  );
  static Widget _note(String text) => Container(
    margin: const EdgeInsets.only(top: 8),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: _orange.withValues(alpha: .1),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(text, style: const TextStyle(height: 1.5)),
  );
  static Widget _check(String text) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: const Icon(CupertinoIcons.check_mark_circled_solid, color: _green),
    title: Text(text),
  );
  static Widget _table(List<(String, String)> rows) => Table(
    border: TableBorder.symmetric(
      inside: const BorderSide(color: Color(0x2217221F)),
    ),
    children: rows
        .map(
          (row) => TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  row.$1,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Padding(padding: const EdgeInsets.all(10), child: Text(row.$2)),
            ],
          ),
        )
        .toList(),
  );
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) => ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const _PageHeader(title: '设置', subtitle: '显示、记录与隐私'),
          _settingsLabel('显示'),
          _settingsTile(
            context,
            '结果小数位',
            '${state.decimals} 位',
            onTap: () => _chooseDecimals(context),
          ),
          _settingsTile(context, '外观', switch (state.themeMode) {
            ThemeMode.system => '跟随系统',
            ThemeMode.light => '浅色',
            ThemeMode.dark => '深色',
          }, onTap: () => _chooseTheme(context)),
          _settingsLabel('数据'),
          SwitchListTile.adaptive(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            title: const Text('自动保存历史'),
            subtitle: const Text('最多保留最近 200 条，仅存储在本机'),
            value: state.saveHistory,
            activeTrackColor: _green,
            onChanged: state.setSaveHistory,
          ),
          _settingsTile(
            context,
            '清空非项目历史',
            '${state.records.where((r) => r.projectId == null).length} 条',
            destructive: true,
            onTap: () => _clearHistory(context),
          ),
          _settingsLabel('关于'),
          _settingsTile(
            context,
            '隐私政策',
            '不收集数据',
            onTap: () => _showInfo(
              context,
              '隐私政策',
              '管算通不要求注册，不接入广告、分析或第三方追踪。项目、历史和设置仅保存在设备本地。只有在你主动使用分享功能时，结果才会交给系统分享面板。删除 App 会同时删除本地数据。',
            ),
          ),
          _settingsTile(
            context,
            '支持与反馈',
            '',
            onTap: () => _showInfo(
              context,
              '支持与反馈',
              '如需反馈计算口径或使用问题，请在 App Store 商品页使用“App 支持”链接联系开发者。请勿发送包含敏感项目资料的截图。',
            ),
          ),
          _settingsTile(context, '版本', '1.0.0 (1)'),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Text(
              '结果仅用于估算、放样辅助和技术参考。施工前必须复核。',
              style: TextStyle(fontSize: 12, height: 1.5, color: _muted),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader({required this.title, required this.subtitle, this.action});
  final String title;
  final String subtitle;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 18, 12, 8),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 29,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 13, color: _muted),
              ),
            ],
          ),
        ),
        ?action,
      ],
    ),
  );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.detail,
    this.action,
    this.onTap,
  });
  final IconData icon;
  final String title;
  final String detail;
  final String? action;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 42, color: _green),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            detail,
            textAlign: TextAlign.center,
            style: const TextStyle(height: 1.5, color: _muted),
          ),
          if (action != null) ...[
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onTap,
              style: FilledButton.styleFrom(backgroundColor: _green),
              child: Text(action!),
            ),
          ],
        ],
      ),
    ),
  );
}

Widget _settingsLabel(String text) => Padding(
  padding: const EdgeInsets.fromLTRB(20, 22, 20, 6),
  child: Text(
    text,
    style: const TextStyle(
      fontSize: 12,
      color: _muted,
      fontWeight: FontWeight.w700,
    ),
  ),
);

Widget _settingsTile(
  BuildContext context,
  String title,
  String value, {
  VoidCallback? onTap,
  bool destructive = false,
}) => ListTile(
  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
  title: Text(title, style: TextStyle(color: destructive ? Colors.red : null)),
  trailing: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (value.isNotEmpty)
        Text(value, style: const TextStyle(fontSize: 13, color: _muted)),
      if (onTap != null) ...[
        const SizedBox(width: 7),
        const Icon(CupertinoIcons.chevron_right, size: 14, color: _muted),
      ],
    ],
  ),
  onTap: onTap,
);

Future<void> _addProject(BuildContext context) async {
  final name = TextEditingController();
  final location = TextEditingController();
  final created = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('新建项目'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: name,
            autofocus: true,
            decoration: const InputDecoration(labelText: '项目名称'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: location,
            decoration: const InputDecoration(labelText: '位置或区域（可选）'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () {
            if (name.text.trim().isNotEmpty) Navigator.pop(context, true);
          },
          child: const Text('创建'),
        ),
      ],
    ),
  );
  if (created == true) {
    await AppState.instance.addProject(name.text.trim(), location.text.trim());
  }
  name.dispose();
  location.dispose();
}

Future<bool> _confirmDelete(BuildContext context, String message) async {
  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('请确认'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('删除', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ) ??
      false;
}

void _showRecord(BuildContext context, SavedRecord record) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              record.type,
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * .5,
              ),
              child: SingleChildScrollView(
                child: SelectableText(
                  record.detail,
                  style: const TextStyle(height: 1.55),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(text: record.detail),
                      );
                      if (context.mounted) Navigator.pop(context);
                    },
                    child: const Text('复制'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Builder(
                    builder: (buttonContext) => FilledButton(
                      onPressed: () async {
                        try {
                          await _shareText(
                            anchorContext: buttonContext,
                            text: record.detail,
                            title: record.type,
                          );
                        } on PlatformException catch (exception) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  exception.message?.isNotEmpty == true
                                      ? '无法打开分享：${exception.message}'
                                      : '无法打开系统分享，请稍后重试',
                                ),
                              ),
                            );
                          }
                        }
                      },
                      style: FilledButton.styleFrom(backgroundColor: _green),
                      child: const Text('分享'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Future<ShareResult> _shareText({
  required BuildContext anchorContext,
  required String text,
  required String title,
}) {
  final renderObject = anchorContext.findRenderObject();
  final origin = renderObject is RenderBox && renderObject.hasSize
      ? renderObject.localToGlobal(Offset.zero) & renderObject.size
      : const Rect.fromLTWH(1, 1, 1, 1);
  return SharePlus.instance.share(
    ShareParams(text: text, title: title, sharePositionOrigin: origin),
  );
}

Future<void> _chooseDecimals(BuildContext context) async {
  final state = AppState.instance;
  final value = await showModalBottomSheet<int>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [1, 2, 3]
            .map(
              (number) => ListTile(
                leading: Icon(
                  number == state.decimals
                      ? CupertinoIcons.check_mark_circled_solid
                      : CupertinoIcons.circle,
                  color: number == state.decimals ? _green : _muted,
                ),
                title: Text('$number 位小数'),
                onTap: () => Navigator.pop(context, number),
              ),
            )
            .toList(),
      ),
    ),
  );
  if (value != null) await state.setDecimals(value);
}

Future<void> _chooseTheme(BuildContext context) async {
  final state = AppState.instance;
  final value = await showModalBottomSheet<ThemeMode>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children:
            [
                  (ThemeMode.system, '跟随系统'),
                  (ThemeMode.light, '浅色'),
                  (ThemeMode.dark, '深色'),
                ]
                .map(
                  (item) => ListTile(
                    leading: Icon(
                      item.$1 == state.themeMode
                          ? CupertinoIcons.check_mark_circled_solid
                          : CupertinoIcons.circle,
                      color: item.$1 == state.themeMode ? _green : _muted,
                    ),
                    title: Text(item.$2),
                    onTap: () => Navigator.pop(context, item.$1),
                  ),
                )
                .toList(),
      ),
    ),
  );
  if (value != null) await state.setThemeMode(value);
}

Future<void> _clearHistory(BuildContext context) async {
  if (await _confirmDelete(context, '清空所有未归档到项目的历史记录？')) {
    await AppState.instance.clearHistory();
  }
}

void _showInfo(BuildContext context, String title, String body) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(body, style: const TextStyle(height: 1.55)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('知道了'),
        ),
      ],
    ),
  );
}

String _shortTime(DateTime time) {
  final now = DateTime.now();
  if (now.difference(time).inDays == 0) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
  return '${time.month}/${time.day}';
}
