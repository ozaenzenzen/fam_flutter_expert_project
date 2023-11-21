import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/enum/enum_home_state.dart';
import 'package:ditonton/presentation/bloc/home_state_handler/home_state_handler_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late HomeStateHandlerBloc bloc;

  setUp(() {
    bloc = HomeStateHandlerBloc();
  });

  test('inital state should be HomeStateHandlerMovies', () {
    expect(bloc.state, HomeStateHandlerMovies());
  });

  blocTest(
    'ActionChangeHomeState HomeState.TvSeries Should emit HomeStateHandlerTvSeries',
    build: () {
      return bloc;
    },
    act: (HomeStateHandlerBloc bloc) => bloc.add(ActionChangeHomeState(homeState: HomeState.TvSeries)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      HomeStateHandlerTvSeries(),
    ],
  );

  blocTest(
    'ActionChangeHomeState HomeState.Movies Should emit HomeStateHandlerMovies',
    build: () {
      return bloc;
    },
    act: (HomeStateHandlerBloc bloc) => bloc.add(ActionChangeHomeState(homeState: HomeState.Movies)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      HomeStateHandlerMovies(),
    ],
  );
}
