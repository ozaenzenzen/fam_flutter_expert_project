part of 'home_state_handler_bloc.dart';

class HomeStateHandlerEvent extends Equatable {
  const HomeStateHandlerEvent();

  @override
  List<Object> get props => [];
}

class ActionChangeHomeState extends HomeStateHandlerEvent {
  final HomeState homeState;
  
  ActionChangeHomeState({required this.homeState});
}
