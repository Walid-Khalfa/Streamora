import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsState {
  final bool notificationsEnabled;
  final bool autoPlayEnabled;
  final String videoQuality;
  final String subtitleLanguage;
  final String audioLanguage;
  final bool parentalControlEnabled;
  final int? parentalControlPin;

  const SettingsState({
    this.notificationsEnabled = true,
    this.autoPlayEnabled = true,
    this.videoQuality = 'Auto',
    this.subtitleLanguage = 'Off',
    this.audioLanguage = 'English',
    this.parentalControlEnabled = false,
    this.parentalControlPin,
  });

  SettingsState copyWith({
    bool? notificationsEnabled,
    bool? autoPlayEnabled,
    String? videoQuality,
    String? subtitleLanguage,
    String? audioLanguage,
    bool? parentalControlEnabled,
    int? parentalControlPin,
  }) {
    return SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      autoPlayEnabled: autoPlayEnabled ?? this.autoPlayEnabled,
      videoQuality: videoQuality ?? this.videoQuality,
      subtitleLanguage: subtitleLanguage ?? this.subtitleLanguage,
      audioLanguage: audioLanguage ?? this.audioLanguage,
      parentalControlEnabled: parentalControlEnabled ?? this.parentalControlEnabled,
      parentalControlPin: parentalControlPin ?? this.parentalControlPin,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState());

  void toggleNotifications(bool enabled) {
    state = state.copyWith(notificationsEnabled: enabled);
  }

  void toggleAutoPlay(bool enabled) {
    state = state.copyWith(autoPlayEnabled: enabled);
  }

  void setVideoQuality(String quality) {
    state = state.copyWith(videoQuality: quality);
  }

  void setSubtitleLanguage(String language) {
    state = state.copyWith(subtitleLanguage: language);
  }

  void setAudioLanguage(String language) {
    state = state.copyWith(audioLanguage: language);
  }

  void toggleParentalControl(bool enabled) {
    state = state.copyWith(parentalControlEnabled: enabled);
  }

  void setParentalControlPin(int pin) {
    state = state.copyWith(parentalControlPin: pin);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
