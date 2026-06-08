import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LocalizationState extends Equatable {
  final Locale locale;

  const LocalizationState({this.locale = const Locale('en')});

  bool get isRtl => locale.languageCode == 'ar';

  LocalizationState copyWith({Locale? locale}) {
    return LocalizationState(locale: locale ?? this.locale);
  }

  @override
  List<Object?> get props => [locale];
}
