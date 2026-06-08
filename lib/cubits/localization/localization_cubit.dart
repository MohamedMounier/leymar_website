import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'localization_state.dart';

class LocalizationCubit extends Cubit<LocalizationState> {
  LocalizationCubit() : super(const LocalizationState());

  void changeLocale(Locale locale) {
    emit(state.copyWith(locale: locale));
  }

  void toggleLocale() {
    final newLocale = state.locale.languageCode == 'en'
        ? const Locale('ar')
        : const Locale('en');
    emit(state.copyWith(locale: newLocale));
  }
}
