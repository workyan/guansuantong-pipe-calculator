import 'app_language.dart';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollCacheExtent;
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
          title: AppStrings.pipeQuickCalc,
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
      'rolling-offset': AppStrings.rollingOffset,
      'slope-elevation': AppStrings.slopeElevation,
      'cut-length': AppStrings.cutLength,
      'pipe-weight': AppStrings.pipeWeight,
    };
    if (map.containsKey(scene)) {
      return CalculatorPage(
        type: map[scene]!,
        screenshotFocus: Platform.isAndroid ? scene : null,
      );
    }
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
                    AppStrings.pipeQuickCalc,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                AppStrings.checkTheDimensionsThenMakeTheCut,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  height: 1.12,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                AppStrings
                    .offsetsElevationsCutLengthsAndPipeWeightCoreCalculationsWorkOffline,
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
                      AppStrings
                          .yourDataStaysOnYourDeviceCheckTheDimensionsAndResultsBeforeCuttingOrIn,
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
                    AppStrings.startWithMetricUnits,
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
            label: AppStrings.calculate,
          ),
          NavigationDestination(
            icon: Icon(CupertinoIcons.folder),
            label: AppStrings.projects,
          ),
          NavigationDestination(
            icon: Icon(CupertinoIcons.book),
            label: AppStrings.reference,
          ),
          NavigationDestination(
            icon: Icon(CupertinoIcons.gear),
            label: AppStrings.settings,
          ),
        ],
      ),
    );
  }
}

const _tools = <_Tool>[
  _Tool(
    AppStrings.elbowOffset,
    AppStrings.singlePlaneOffset,
    'assets/generated/elbow_offset.png',
  ),
  _Tool(
    AppStrings.rollingOffset,
    AppStrings.horizontalVerticalOffsets,
    'assets/generated/rolling_offset.png',
  ),
  _Tool(
    AppStrings.slopeElevation,
    AppStrings.fallAndElevationPoints,
    'assets/generated/slope_elevation.png',
  ),
  _Tool(
    AppStrings.cutLength,
    AppStrings.centerDistanceAndTakeOffs,
    'assets/generated/cut_length.png',
  ),
  _Tool(
    AppStrings.pipeWeight,
    AppStrings.theoreticalWeightEstimate,
    'assets/generated/pipe_weight.png',
  ),
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
                          AppStrings.pipeQuickCalc,
                          style: TextStyle(
                            fontSize: 29,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          AppStrings.fieldCalculationsMetric,
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
                      AppStrings.offline,
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
          const SliverToBoxAdapter(
            child: _SectionTitle(AppStrings.allCalculators),
          ),
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
              AppStrings.recentResults,
              action: state.records.isEmpty
                  ? null
                  : AppStrings.records(state.records.length),
            ),
          ),
          SliverToBoxAdapter(
            child: state.records.isEmpty
                ? const Padding(
                    padding: EdgeInsets.fromLTRB(20, 12, 20, 28),
                    child: Text(
                      AppStrings.yourCompletedCalculationsAppearHere,
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
  const CalculatorPage({super.key, required this.type, this.screenshotFocus});
  final String type;
  final String? screenshotFocus;
  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final _inputsKey = GlobalKey();
  final _resultsKey = GlobalKey();
  final _weightLengthKey = GlobalKey();
  late final Map<String, TextEditingController> c;
  double angle = 45;
  int slopeMode = 3;
  bool descending = true;
  String material = AppStrings.carbonSteel;
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
      'left': TextEditingController(
        text: widget.type == AppStrings.cutLength ? '90' : '50',
      ),
      'right': TextEditingController(
        text: widget.type == AppStrings.cutLength ? '95' : '50',
      ),
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculate();
      if (widget.screenshotFocus != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          final anchor = switch (widget.screenshotFocus) {
            'rolling-offset' => _inputsKey,
            'slope-elevation' => _resultsKey,
            'pipe-weight' => _weightLengthKey,
            _ => null,
          };
          final context = anchor?.currentContext;
          if (context != null) {
            Scrollable.ensureVisible(
              context,
              alignment: widget.screenshotFocus == 'pipe-weight' ? .015 : 0,
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
        AppStrings.elbowOffset => PipeCalculator.elbow(
          offset: _n('offset'),
          angle: angle == 0 ? _n('angle') : angle,
          left: _n('left'),
          right: _n('right'),
          decimals: decimals,
        ),
        AppStrings.rollingOffset => PipeCalculator.rolling(
          horizontal: _n('horizontal'),
          vertical: _n('vertical'),
          angle: angle == 0 ? _n('angle') : angle,
          left: _n('left'),
          right: _n('right'),
          decimals: decimals,
        ),
        AppStrings.slopeElevation => switch (slopeMode) {
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
        AppStrings.cutLength => PipeCalculator.cut(
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
          error = e is FormatException
              ? e.message.toString()
              : AppStrings.checkTheInputValues;
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
              tooltip: state.favorites.contains(widget.type)
                  ? AppStrings.removeFavorite
                  : AppStrings.favorites,
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
          controller: _scrollController,
          scrollCacheExtent: widget.screenshotFocus != null
              ? const ScrollCacheExtent.pixels(10000)
              : null,
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
            Text(
              AppStrings.inputs,
              key: _inputsKey,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            ..._inputs(),
            const SizedBox(height: 22),
            Text(
              AppStrings.results,
              key: _resultsKey,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
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
                  : _ErrorPanel(
                      message: error ?? AppStrings.enterAllRequiredValues,
                    ),
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
                  label: const Text(AppStrings.copy),
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
                  label: Text(sharing ? AppStrings.opening : AppStrings.share),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: result == null ? null : _save,
                  style: FilledButton.styleFrom(backgroundColor: _green),
                  icon: const Icon(CupertinoIcons.folder_badge_plus, size: 18),
                  label: const Text(AppStrings.save),
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
        AppStrings.elbowAngle,
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 6,
        children: [22.5, 30.0, 45.0, 60.0, 0.0].map((value) {
          return ChoiceChip(
            label: Text(
              value == 0
                  ? AppStrings.custom
                  : '${value.toString().replaceAll('.0', '')}°',
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
        _field(AppStrings.customAngle, 'angle', '°'),
      ],
      const SizedBox(height: 14),
    ];
    return switch (widget.type) {
      AppStrings.elbowOffset => [
        _field(AppStrings.offset, 'offset', 'mm'),
        ...commonAngle,
        _field(AppStrings.leftCenterToEnd, 'left', 'mm'),
        _field(AppStrings.rightCenterToEnd, 'right', 'mm'),
      ],
      AppStrings.rollingOffset => [
        _field(AppStrings.horizontalOffsetH, 'horizontal', 'mm', signed: true),
        _field(AppStrings.verticalOffsetV, 'vertical', 'mm', signed: true),
        ...commonAngle,
        _field(AppStrings.leftCenterToEnd, 'left', 'mm'),
        _field(AppStrings.rightCenterToEnd, 'right', 'mm'),
      ],
      AppStrings.slopeElevation => [
        DropdownButtonFormField<int>(
          initialValue: slopeMode,
          decoration: const InputDecoration(
            labelText: AppStrings.calculationMode,
          ),
          items: const [
            DropdownMenuItem(
              value: 0,
              child: Text(AppStrings.findFallFromDistanceAndSlope),
            ),
            DropdownMenuItem(
              value: 1,
              child: Text(AppStrings.findSlopeFromDistanceAndFall),
            ),
            DropdownMenuItem(
              value: 2,
              child: Text(AppStrings.findSlopeFromStartAndEndElevations),
            ),
            DropdownMenuItem(
              value: 3,
              child: Text(AppStrings.generateElevationPoints),
            ),
          ],
          onChanged: (value) {
            setState(() => slopeMode = value!);
            _calculate();
          },
        ),
        const SizedBox(height: 8),
        if (slopeMode == 0) ...[
          _field(AppStrings.horizontalDistance, 'distance', 'mm'),
          _field(AppStrings.slope, 'slope', '%', signed: true),
        ],
        if (slopeMode == 1) ...[
          _field(AppStrings.horizontalDistance, 'distance', 'mm'),
          _field(AppStrings.fall, 'drop', 'mm', signed: true),
        ],
        if (slopeMode == 2) ...[
          _field(AppStrings.startElevation, 'elevation', 'm', signed: true),
          _field(AppStrings.endElevation, 'endElevation', 'm', signed: true),
          _field(AppStrings.horizontalDistance, 'distance', 'mm'),
        ],
        if (slopeMode == 3) ...[
          _field(AppStrings.startElevation, 'elevation', 'm', signed: true),
          _field(AppStrings.slope, 'slope', '%'),
          _field(AppStrings.totalDistance, 'distance', 'mm'),
          _field(AppStrings.pointSpacing, 'interval', 'mm'),
          const Text(
            AppStrings.direction,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: true, label: Text(AppStrings.down)),
              ButtonSegment(value: false, label: Text(AppStrings.up)),
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
      AppStrings.cutLength => [
        _field(AppStrings.centerToCenterDistance, 'center', 'mm'),
        _field(AppStrings.leftTakeOffHc4599a, 'left', 'mm'),
        _field(AppStrings.rightTakeOffHb548fa, 'right', 'mm'),
      ],
      _ => [
        _field(AppStrings.outsideDiameter, 'diameter', 'mm'),
        _field(AppStrings.wallThickness, 'thickness', 'mm'),
        _field(AppStrings.lengthPerPipe, 'length', 'm'),
        _field(
          AppStrings.quantity,
          'quantity',
          AppStrings.pipes,
          integer: true,
        ),
        DropdownButtonFormField<String>(
          initialValue: material,
          decoration: const InputDecoration(labelText: AppStrings.material),
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
        _field(AppStrings.unitPriceOptional, 'price', AppStrings.currencyKg),
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
      key: key == 'length' ? _weightLengthKey : null,
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
    if (mounted) _toast(AppStrings.resultCopied);
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
              ? AppStrings.cannotOpenSharing(exception.message)
              : AppStrings.cannotOpenSharingTryAgain,
        );
      }
    } catch (_) {
      if (mounted) _toast(AppStrings.cannotOpenSharingTryAgain);
    } finally {
      if (mounted) setState(() => sharing = false);
    }
  }

  Future<void> _save() async {
    final state = AppState.instance;
    if (state.projects.isEmpty) {
      await state.addRecord(widget.type, result!.primaryValue, _text);
      if (mounted) _toast(AppStrings.savedToHistory);
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
                AppStrings.saveCalculation,
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              subtitle: Text(AppStrings.saveToHistoryOrAProject),
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.clock),
              title: const Text(AppStrings.historyOnly),
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
    if (mounted) {
      _toast(
        choice.isEmpty
            ? AppStrings.savedToHistoryHc7ff90
            : AppStrings.addedToProject,
      );
    }
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
          const Text(
            AppStrings.elevationPoints,
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
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
        const Text(
          AppStrings.calculationSteps,
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
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
              title: AppStrings.projects,
              subtitle: AppStrings.groupCalculationsByJobOrArea,
              action: IconButton(
                tooltip: AppStrings.newProject,
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
                title: AppStrings.noProjectsYet,
                detail:
                    AppStrings.createAProjectThenAddResultsFromAnyCalculator,
                action: AppStrings.newProject,
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
                    confirmDismiss: (_) => _confirmDelete(
                      context,
                      AppStrings.deleteThisProjectAndItsRecords,
                    ),
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
                        AppStrings.recordsHf44ecf(
                          project.location.isEmpty
                              ? AppStrings.noLocation
                              : project.location,
                          count,
                        ),
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
              title: AppStrings.noRecordsInThisProject,
              detail: AppStrings.completeACalculationThenChooseSave,
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
      AppStrings.slopeConversions,
      AppStrings.percentPerMilleMmMRatioAndAngle,
      CupertinoIcons.arrow_left_right,
      _ReferenceContent.slope,
    ),
    _Article(
      AppStrings.elbowAngleMultipliers,
      AppStrings.quickChecksFor2253045And60,
      CupertinoIcons.function,
      _ReferenceContent.elbow,
    ),
    _Article(
      AppStrings.pipeWeightFormula,
      AppStrings.roundPipeAreaAndTheoreticalWeight,
      CupertinoIcons.cube_box,
      _ReferenceContent.weight,
    ),
    _Article(
      AppStrings.fieldMeasurements,
      AppStrings.centerDistanceAndCenterToEndDimensions,
      CupertinoIcons.resize,
      _ReferenceContent.measure,
    ),
    _Article(
      AppStrings.resultChecklist,
      AppStrings.checkBeforeCuttingWeldingOrInstalling,
      CupertinoIcons.check_mark_circled,
      _ReferenceContent.checklist,
    ),
    _Article(
      AppStrings.scopeAndSafety,
      AppStrings.formulaAssumptionsAndLimitations,
      CupertinoIcons.exclamationmark_shield,
      _ReferenceContent.safety,
    ),
  ];
  @override
  Widget build(BuildContext context) => CustomScrollView(
    slivers: [
      const SliverToBoxAdapter(
        child: _PageHeader(
          title: AppStrings.reference,
          subtitle: AppStrings.formulasAndPracticalChecks,
        ),
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
        _p(AppStrings.decimalSlopeSFallHorizontalDistance),
        _table(const [
          (AppStrings.format, AppStrings.conversion),
          (AppStrings.percent, 's × 100%'),
          (AppStrings.perMille, 's × 1000‰'),
          (AppStrings.millimetresPerMetre, 's × 1000 mm/m'),
          (AppStrings.ratio, '1 : (1 ÷ |s|)'),
          (AppStrings.angle, 'atan(s)'),
        ]),
        _note(AppStrings.example22020MmM1501146),
      ],
      _ReferenceContent.elbow => [
        _p(AppStrings.centerlineTravelTOffsetOSinAdvanceAOTan),
        _table(const [
          (AppStrings.angle, AppStrings.travelMultiplier1Sin),
          ('22.5°', '2.613'),
          ('30°', '2.000'),
          ('45°', '1.414'),
          ('60°', '1.155'),
        ]),
        _note(
          AppStrings
              .useMultipliersForQuickChecksOnlyUseActualMeasurementsAndFittingTakeOff,
        ),
      ],
      _ReferenceContent.weight => [
        _p(AppStrings.insideDiameterDOutsideDiameterD2WallThicknessT),
        _p(AppStrings.areaA4DDTheoreticalWeightALengthDensity),
        _note(
          AppStrings
              .referenceDensityIsNotAMaterialAcceptanceValueGradeTolerancesAndCoating,
        ),
      ],
      _ReferenceContent.measure => [
        _p(
          AppStrings
              .centerDistanceTheDistanceBetweenTheTwoFittingCenterlineIntersections,
        ),
        _p(
          AppStrings
              .centerToEndTheDistanceFromTheFittingCenterlineIntersectionToItsConnect,
        ),
        _note(
          AppStrings
              .dimensionsVaryByStandardPressureClassAndManufacturerUseActualFittingsO,
        ),
      ],
      _ReferenceContent.checklist => [
        _check(AppStrings.useConsistentUnitsDoNotMixMetricAndImperial),
        _check(AppStrings.confirmWhetherReferencePointsAreCenterlinesOrFaces),
        _check(AppStrings.checkElbowAngleDirectionAndRollPlane),
        _check(AppStrings.checkTheFittingTakeOffAtEachEnd),
        _check(
          AppStrings
              .allowSeparatelyForInsulationBevelsWeldShrinkageAndInstallation,
        ),
        _check(AppStrings.haveCriticalDimensionsCheckedIndependently),
      ],
      _ReferenceContent.safety => [
        _p(
          AppStrings
              .thisToolAssistsWithGeometrySlopeAndTheoreticalWeightItDoesNotReplaceEn,
        ),
        _p(
          AppStrings
              .thisToolDoesNotDeterminePressureRatingsMaterialSuitabilityWeldingProce,
        ),
        _note(
          AppStrings
              .beforeFabricationOrInstallationAQualifiedPersonMustCheckTheDrawingAppl,
        ),
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
          const _PageHeader(
            title: AppStrings.settings,
            subtitle: AppStrings.displayRecordsAndPrivacy,
          ),
          _settingsLabel(AppStrings.display),
          _settingsTile(
            context,
            AppStrings.decimalPlaces,
            AppStrings.places(state.decimals),
            onTap: () => _chooseDecimals(context),
          ),
          _settingsTile(
            context,
            AppStrings.appearance,
            switch (state.themeMode) {
              ThemeMode.system => AppStrings.system,
              ThemeMode.light => AppStrings.light,
              ThemeMode.dark => AppStrings.dark,
            },
            onTap: () => _chooseTheme(context),
          ),
          _settingsLabel(AppStrings.data),
          SwitchListTile.adaptive(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            title: const Text(AppStrings.saveHistoryAutomatically),
            subtitle: const Text(
              AppStrings.upTo200RecentRecordsStoredOnThisDevice,
            ),
            value: state.saveHistory,
            activeTrackColor: _green,
            onChanged: state.setSaveHistory,
          ),
          _settingsTile(
            context,
            AppStrings.clearUnfiledHistory,
            AppStrings.records(
              state.records.where((r) => r.projectId == null).length,
            ),
            destructive: true,
            onTap: () => _clearHistory(context),
          ),
          _settingsLabel(AppStrings.about),
          _settingsTile(
            context,
            AppStrings.privacyPolicy,
            AppStrings.noDataCollection,
            onTap: () => _showInfo(
              context,
              AppStrings.privacyPolicy,
              AppStrings
                  .pipeQuickCalcHasNoAccountsAdsAnalyticsOrTrackingSDKsProjectsHistoryAnd,
            ),
          ),
          _settingsTile(
            context,
            AppStrings.support,
            '',
            onTap: () => _showInfo(
              context,
              AppStrings.support,
              AppStrings
                  .forHelpWithCalculationsOrTheAppContact1535883467QqComRemoveConfidentia,
            ),
          ),
          _settingsTile(context, AppStrings.version, '1.0.0 (1)'),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Text(
              AppStrings
                  .resultsAreCalculationAidsVerifyDimensionsAndConditionsBeforeFabricatio,
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
      title: const Text(AppStrings.newProject),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: name,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: AppStrings.projectName,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: location,
            decoration: const InputDecoration(
              labelText: AppStrings.locationOrAreaOptional,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text(AppStrings.cancel),
        ),
        FilledButton(
          onPressed: () {
            if (name.text.trim().isNotEmpty) Navigator.pop(context, true);
          },
          child: const Text(AppStrings.create),
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
          title: const Text(AppStrings.confirm),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(AppStrings.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                AppStrings.delete,
                style: TextStyle(color: Colors.red),
              ),
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
                    child: const Text(AppStrings.copy),
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
                                      ? AppStrings.cannotOpenSharing(
                                          exception.message,
                                        )
                                      : AppStrings.cannotOpenSharingTryAgain,
                                ),
                              ),
                            );
                          }
                        }
                      },
                      style: FilledButton.styleFrom(backgroundColor: _green),
                      child: const Text(AppStrings.share),
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
                title: Text(AppStrings.decimalPlacesH9115ec(number)),
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
                  (ThemeMode.system, AppStrings.system),
                  (ThemeMode.light, AppStrings.light),
                  (ThemeMode.dark, AppStrings.dark),
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
  if (await _confirmDelete(
    context,
    AppStrings.clearAllHistoryThatIsNotFiledInAProject,
  )) {
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
          child: const Text(AppStrings.ok),
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
