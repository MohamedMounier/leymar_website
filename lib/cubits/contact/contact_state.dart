import 'package:equatable/equatable.dart';

enum ContactStatus { initial, loading, success, error }

class ContactState extends Equatable {
  final ContactStatus status;
  final String selectedTab;
  final String name;
  final String company;
  final String country;
  final String email;
  final String phone;
  final String moq;
  final String message;
  final String? errorMessage;

  const ContactState({
    this.status = ContactStatus.initial,
    this.selectedTab = 'quote',
    this.name = '',
    this.company = '',
    this.country = '',
    this.email = '',
    this.phone = '',
    this.moq = '',
    this.message = '',
    this.errorMessage,
  });

  ContactState copyWith({
    ContactStatus? status,
    String? selectedTab,
    String? name,
    String? company,
    String? country,
    String? email,
    String? phone,
    String? moq,
    String? message,
    String? errorMessage,
  }) {
    return ContactState(
      status: status ?? this.status,
      selectedTab: selectedTab ?? this.selectedTab,
      name: name ?? this.name,
      company: company ?? this.company,
      country: country ?? this.country,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      moq: moq ?? this.moq,
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isValid =>
      name.isNotEmpty && email.isNotEmpty && email.contains('@');

  @override
  List<Object?> get props => [
        status, selectedTab, name, company, country,
        email, phone, moq, message, errorMessage,
      ];
}
