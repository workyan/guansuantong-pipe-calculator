import 'app_language.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedRecord {
  const SavedRecord({
    required this.id,
    required this.type,
    required this.summary,
    required this.detail,
    required this.createdAt,
    this.projectId,
  });

  final String id;
  final String type;
  final String summary;
  final String detail;
  final DateTime createdAt;
  final String? projectId;

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'summary': summary,
    'detail': detail,
    'createdAt': createdAt.toIso8601String(),
    'projectId': projectId,
  };

  factory SavedRecord.fromJson(Map<String, dynamic> json) => SavedRecord(
    id: json['id'] as String,
    type: json['type'] as String,
    summary: json['summary'] as String,
    detail: json['detail'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    projectId: json['projectId'] as String?,
  );
}

class PipeProject {
  const PipeProject({
    required this.id,
    required this.name,
    required this.location,
    required this.createdAt,
  });
  final String id;
  final String name;
  final String location;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'location': location,
    'createdAt': createdAt.toIso8601String(),
  };

  factory PipeProject.fromJson(Map<String, dynamic> json) => PipeProject(
    id: json['id'] as String,
    name: json['name'] as String,
    location: json['location'] as String? ?? '',
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}

class AppState extends ChangeNotifier {
  AppState._();
  static final AppState instance = AppState._();
  SharedPreferences? _prefs;
  bool ready = false;
  bool onboardingDone = false;
  bool saveHistory = true;
  int decimals = 2;
  ThemeMode themeMode = ThemeMode.system;
  final Set<String> favorites = {
    AppStrings.rollingOffset,
    AppStrings.slopeElevation,
    AppStrings.cutLength,
  };
  final List<SavedRecord> records = [];
  final List<PipeProject> projects = [];

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    onboardingDone = _prefs!.getBool('onboardingDone') ?? false;
    saveHistory = _prefs!.getBool('saveHistory') ?? true;
    decimals = _prefs!.getInt('decimals') ?? 2;
    final themeIndex = (_prefs!.getInt('themeMode') ?? 0).clamp(
      0,
      ThemeMode.values.length - 1,
    );
    themeMode = ThemeMode.values[themeIndex];
    favorites
      ..clear()
      ..addAll(
        _prefs!.getStringList('favorites') ??
            [
              AppStrings.rollingOffset,
              AppStrings.slopeElevation,
              AppStrings.cutLength,
            ],
      );
    _decodeList('records', SavedRecord.fromJson, records);
    _decodeList('projects', PipeProject.fromJson, projects);
    ready = true;
    notifyListeners();
  }

  void loadScreenshotData() {
    final anchor = DateTime(2026, 8, 26, 9, 41);
    onboardingDone = true;
    saveHistory = true;
    decimals = 2;
    themeMode = ThemeMode.light;
    projects
      ..clear()
      ..addAll([
        PipeProject(
          id: 'project-chiller',
          name: AppStrings.chillerRoomRetrofit,
          location: AppStrings.areaALevelB1,
          createdAt: anchor.subtract(const Duration(days: 12)),
        ),
        PipeProject(
          id: 'project-workshop',
          name: AppStrings.workshopFireLine,
          location: AppStrings.productionBuildingLevel2,
          createdAt: anchor.subtract(const Duration(days: 6)),
        ),
      ]);
    records
      ..clear()
      ..addAll([
        SavedRecord(
          id: 'record-1',
          type: AppStrings.rollingOffset,
          summary: AppStrings.centerDistance4800Mm,
          detail: AppStrings.h320MmV360Mm45Elbow,
          createdAt: anchor.subtract(const Duration(minutes: 18)),
          projectId: 'project-chiller',
        ),
        SavedRecord(
          id: 'record-2',
          type: AppStrings.slopeElevation,
          summary: AppStrings.endElevation24160Mm,
          detail: AppStrings.length12MSlope07,
          createdAt: anchor.subtract(const Duration(hours: 3)),
          projectId: 'project-chiller',
        ),
        SavedRecord(
          id: 'record-3',
          type: AppStrings.cutLength,
          summary: AppStrings.cutLength18260Mm,
          detail: AppStrings.centers2000MmTakeOff174Mm,
          createdAt: anchor.subtract(const Duration(days: 1)),
          projectId: 'project-workshop',
        ),
        SavedRecord(
          id: 'record-4',
          type: AppStrings.pipeWeight,
          summary: AppStrings.totalWeight1864Kg,
          detail: 'DN100 · 18 m · 10.36 kg/m',
          createdAt: anchor.subtract(const Duration(days: 2)),
          projectId: 'project-workshop',
        ),
      ]);
    notifyListeners();
  }

  void _decodeList<T>(
    String key,
    T Function(Map<String, dynamic>) parser,
    List<T> target,
  ) {
    try {
      final source = jsonDecode(_prefs?.getString(key) ?? '[]') as List;
      target
        ..clear()
        ..addAll(
          source.map((e) => parser(Map<String, dynamic>.from(e as Map))),
        );
    } catch (_) {
      target.clear();
    }
  }

  Future<void> completeOnboarding() async {
    onboardingDone = true;
    await _prefs?.setBool('onboardingDone', true);
    notifyListeners();
  }

  Future<void> setDecimals(int value) async {
    decimals = value;
    await _prefs?.setInt('decimals', value);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode value) async {
    themeMode = value;
    await _prefs?.setInt('themeMode', value.index);
    notifyListeners();
  }

  Future<void> setSaveHistory(bool value) async {
    saveHistory = value;
    await _prefs?.setBool('saveHistory', value);
    notifyListeners();
  }

  Future<void> toggleFavorite(String type) async {
    favorites.contains(type) ? favorites.remove(type) : favorites.add(type);
    await _prefs?.setStringList('favorites', favorites.toList());
    notifyListeners();
  }

  Future<void> addRecord(
    String type,
    String summary,
    String detail, {
    String? projectId,
  }) async {
    if (!saveHistory && projectId == null) return;
    records.insert(
      0,
      SavedRecord(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        type: type,
        summary: summary,
        detail: detail,
        createdAt: DateTime.now(),
        projectId: projectId,
      ),
    );
    if (records.length > 200) records.removeLast();
    await _saveRecords();
    notifyListeners();
  }

  Future<void> deleteRecord(String id) async {
    records.removeWhere((record) => record.id == id);
    await _saveRecords();
    notifyListeners();
  }

  Future<void> addProject(String name, String location) async {
    projects.insert(
      0,
      PipeProject(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: name,
        location: location,
        createdAt: DateTime.now(),
      ),
    );
    await _saveProjects();
    notifyListeners();
  }

  Future<void> deleteProject(String id) async {
    projects.removeWhere((project) => project.id == id);
    records.removeWhere((record) => record.projectId == id);
    await _saveProjects();
    await _saveRecords();
    notifyListeners();
  }

  Future<void> clearHistory() async {
    records.removeWhere((record) => record.projectId == null);
    await _saveRecords();
    notifyListeners();
  }

  Future<void> _saveProjects() => _prefs!.setString(
    'projects',
    jsonEncode(projects.map((e) => e.toJson()).toList()),
  );
  Future<void> _saveRecords() => _prefs!.setString(
    'records',
    jsonEncode(records.map((e) => e.toJson()).toList()),
  );
}
