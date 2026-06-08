import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final double scrollOffset;
  final bool isNavbarOpaque;

  const HomeState({
    this.scrollOffset = 0,
    this.isNavbarOpaque = false,
  });

  HomeState copyWith({
    double? scrollOffset,
    bool? isNavbarOpaque,
  }) {
    return HomeState(
      scrollOffset: scrollOffset ?? this.scrollOffset,
      isNavbarOpaque: isNavbarOpaque ?? this.isNavbarOpaque,
    );
  }

  @override
  List<Object?> get props => [scrollOffset, isNavbarOpaque];
}
