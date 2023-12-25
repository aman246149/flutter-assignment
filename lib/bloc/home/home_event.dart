part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class SetUserStatusOnlineEvent extends HomeEvent {}

class SetUserStatusOfflineEvent extends HomeEvent {}

class GetOnlineUserNamesEvent extends HomeEvent {}

class SendImageAndStartGameEvent extends HomeEvent {
  final File imageFile;
  final String playerId;


  SendImageAndStartGameEvent(
      {required this.imageFile,
      required this.playerId,
     });
}

class ExitGameEvent extends HomeEvent {

  final String opponentId;

  ExitGameEvent({required this.opponentId});

}

class GetGameLobbySteamEvent extends HomeEvent {

final String gameLobbyId;

  GetGameLobbySteamEvent({required this.gameLobbyId});


}

class UpdatePositionEvent extends HomeEvent {

final List<double> position;

final String gameLobbyId;

  UpdatePositionEvent({required this.position,required this.gameLobbyId});


}