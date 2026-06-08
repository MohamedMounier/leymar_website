import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void onScroll(double offset) {
    emit(state.copyWith(
      scrollOffset: offset,
      isNavbarOpaque: offset > 80,
    ));
  }
}
