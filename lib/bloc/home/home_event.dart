part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class SetUserStatusOnlineEvent extends HomeEvent {}

class SetUserStatusOfflineEvent extends HomeEvent {}

class GetOnlineUserNamesEvent extends HomeEvent {}