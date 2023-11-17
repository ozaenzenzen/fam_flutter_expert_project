// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:ditonton/common/enum/enum_home_state.dart';
import 'package:equatable/equatable.dart';

part 'home_state_handler_event.dart';
part 'home_state_handler_state.dart';

class HomeStateHandlerBloc extends Bloc<HomeStateHandlerEvent, HomeStateHandlerState> {
  HomeStateHandlerBloc() : super(HomeStateHandlerMovies()) {
    on<HomeStateHandlerEvent>((event, emit) {
      if (event is ActionChangeHomeState) {
        _changeHomeState(event);
      }
    });
  }

  Future<void> _changeHomeState(
    ActionChangeHomeState event,
  ) async {
    if (event.homeState == HomeState.TvSeries) {
      emit(HomeStateHandlerTvSeries());
    } else {
      emit(HomeStateHandlerMovies());
    }
  }
}
