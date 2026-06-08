import 'package:flutter_bloc/flutter_bloc.dart';
import 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  ContactCubit() : super(const ContactState());

  void selectTab(String tab) => emit(state.copyWith(selectedTab: tab));
  void setName(String v) => emit(state.copyWith(name: v));
  void setCompany(String v) => emit(state.copyWith(company: v));
  void setCountry(String v) => emit(state.copyWith(country: v));
  void setEmail(String v) => emit(state.copyWith(email: v));
  void setPhone(String v) => emit(state.copyWith(phone: v));
  void setMoq(String v) => emit(state.copyWith(moq: v));
  void setMessage(String v) => emit(state.copyWith(message: v));

  Future<void> submitRequest() async {
    if (!state.isValid) {
      emit(state.copyWith(errorMessage: 'Please fill in all required fields.'));
      return;
    }
    emit(state.copyWith(status: ContactStatus.loading));
    // Simulate network delay (local-only, no backend)
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(status: ContactStatus.success));
  }

  void reset() => emit(const ContactState());
}
