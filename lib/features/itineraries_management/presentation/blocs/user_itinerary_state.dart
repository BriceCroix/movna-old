part of 'user_itinerary_bloc.dart';

abstract class UserItineraryState extends Equatable {
  const UserItineraryState();

  @override
  List<Object?> get props => [];
}

class UserItineraryInitial extends UserItineraryState {}

class UserItineraryLoading extends UserItineraryState {
  /// The itinerary to be represented on the page.
  final Itinerary? itinerary;

  /// Current user position, not mandatory to load page.
  final Position? userPosition;

  const UserItineraryLoading({this.itinerary, this.userPosition});

  @override
  List<Object?> get props => [itinerary, userPosition];

  UserItineraryLoading copyWith({
    Itinerary? itinerary,
    Position? userPosition,
  }) {
    return UserItineraryLoading(
      itinerary: itinerary ?? this.itinerary,
      userPosition: userPosition ?? this.userPosition,
    );
  }
}

class UserItineraryLoaded extends UserItineraryState {
  /// The itinerary to be represented on the page.
  final Itinerary itinerary;

  /// Current user position, not mandatory to load page.
  final Position? userPosition;

  const UserItineraryLoaded({required this.itinerary, this.userPosition});

  @override
  List<Object?> get props => [itinerary, userPosition];

  UserItineraryLoaded copyWith({
    Itinerary? itinerary,
    Position? userPosition,
  }) {
    return UserItineraryLoaded(
      itinerary: itinerary ?? this.itinerary,
      userPosition: userPosition ?? this.userPosition,
    );
  }
}

/// Indicates that page should be popped.
class UserItineraryDone extends UserItineraryState {}
