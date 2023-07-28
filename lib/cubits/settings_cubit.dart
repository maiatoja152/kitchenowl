import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitchenowl/config.dart';
import 'package:kitchenowl/kitchenowl.dart';
import 'package:kitchenowl/services/storage/storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState()) {
    load();
  }

  Future<void> load() async {
    final themeModeIndex =
        PreferenceStorage.getInstance().readInt(key: 'themeMode');
    final dynamicAccentColor =
        PreferenceStorage.getInstance().readBool(key: 'dynamicAccentColor');
    final gridSize = PreferenceStorage.getInstance().readInt(key: 'gridSize');
    final recentItemsCount =
        PreferenceStorage.getInstance().readInt(key: 'recentItemsCount');
    Config.deviceInfo = DeviceInfoPlugin().deviceInfo;
    Config.packageInfo = PackageInfo.fromPlatform();

    ThemeMode themeMode = ThemeMode.system;
    if (await themeModeIndex != null) {
      themeMode = ThemeMode.values[(await themeModeIndex)!];
    }

    emit(SettingsState(
      themeMode: themeMode,
      dynamicAccentColor: await dynamicAccentColor ?? false,
      gridSize: (await gridSize) != null
          ? GridSize.values[(await gridSize)!]
          : GridSize.normal,
      recentItemsCount: await recentItemsCount ?? 9,
    ));
  }

  void setTheme(ThemeMode themeMode) {
    PreferenceStorage.getInstance()
        .writeInt(key: 'themeMode', value: themeMode.index);
    emit(state.copyWith(themeMode: themeMode));
  }

  void setUseDynamicAccentColor(bool dynamicAccentColor) {
    PreferenceStorage.getInstance()
        .writeBool(key: 'dynamicAccentColor', value: dynamicAccentColor);
    emit(state.copyWith(dynamicAccentColor: dynamicAccentColor));
  }

  void setGridSize(GridSize gridSize) {
    PreferenceStorage.getInstance()
        .writeInt(key: 'gridSize', value: gridSize.index);
    emit(state.copyWith(gridSize: gridSize));
  }

  void setRecentItemsCount(int recentItemsCount) {
    if (recentItemsCount > 0) {
      PreferenceStorage.getInstance()
          .writeInt(key: 'recentItemsCount', value: recentItemsCount);
      emit(state.copyWith(recentItemsCount: recentItemsCount));
    }
  }
}

class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final bool dynamicAccentColor;
  final int recentItemsCount;
  final GridSize gridSize;

  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.dynamicAccentColor = false,
    this.gridSize = GridSize.normal,
    this.recentItemsCount = 9,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    bool? dynamicAccentColor,
    GridSize? gridSize,
    int? recentItemsCount,
  }) =>
      SettingsState(
        themeMode: themeMode ?? this.themeMode,
        dynamicAccentColor: dynamicAccentColor ?? this.dynamicAccentColor,
        gridSize: gridSize ?? this.gridSize,
        recentItemsCount: recentItemsCount ?? this.recentItemsCount,
      );

  @override
  List<Object?> get props =>
      [themeMode, dynamicAccentColor, gridSize, recentItemsCount];
}
