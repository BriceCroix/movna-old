part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial({required this.selectedIndex});

  /// The selected tab index in the bottom navigation bar
  final int selectedIndex;

  @override
  List<Object?> get props => [selectedIndex];
}