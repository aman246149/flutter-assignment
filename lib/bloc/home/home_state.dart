part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  
  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeSetOfflineSuccessState extends HomeState {}

class HomeSetOnlineSuccessState extends HomeState {}

class HomeErrorState extends HomeState {
  final String message;

  const HomeErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class HomeGetOnlineUserNamesSuccessState extends HomeState {
  final Stream<QuerySnapshot<Map<String, dynamic>>> onlineUserNames;

  const HomeGetOnlineUserNamesSuccessState(this.onlineUserNames);

  @override
  List<Object> get props => [onlineUserNames];
}

class HomeSendImageAndStartGameSuccessState extends HomeState {}

class ExitGameSuccessState extends HomeState {}

class GetGameLobbySteamSuccessState extends HomeState {
  final Stream<DocumentSnapshot<Map<String, dynamic>>> gameLobbyStream;

  const GetGameLobbySteamSuccessState(this.gameLobbyStream);

  @override
  List<Object> get props => [gameLobbyStream];
}

class UpdatePositionSuccessState extends HomeState {}

class UpdatePointsSuccessState extends HomeState {}

class DecreasePointsSuccessState extends HomeState {}