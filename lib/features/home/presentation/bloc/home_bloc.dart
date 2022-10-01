import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'home_event.dart';
part 'home_state.dart';

@Injectable()
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  static const int defaultSelectedNavIndex = 1;

  HomeBloc()
      : super(const HomeInitial(selectedIndex: defaultSelectedNavIndex)) {
    on<NavBarIndexChanged>(_onNavBarIndexChanged);
  }

  void _onNavBarIndexChanged(
      NavBarIndexChanged event, Emitter<HomeState> emit) {
    if (state is HomeInitial) {
      emit(HomeInitial(selectedIndex: event.index));
    }
  }
}
