import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../repository/home_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<SetUserStatusOnlineEvent>(handleSetUserStatusOnlineEvent);
    on<SetUserStatusOfflineEvent>(handleSetUserStatusOfflineEvent);
    on<GetOnlineUserNamesEvent>(handleGetOnlineUserNamesEvent);
    on<SendImageAndStartGameEvent>(handleSendImageAndStartGameEvent);
    on<ExitGameEvent>(handleExitGameEvent);
    on<GetGameLobbySteamEvent>(handleGetGameLobbySteamEvent);
    on<UpdatePositionEvent>(handleUpdatePositionEvent);
    on<UpdatePointsEvent>(handleUpdatePointsEvent);
    on<DecreasePointsEvent>(handleDecreasePointsEvent);
  }
  void handleSetUserStatusOnlineEvent(
      SetUserStatusOnlineEvent event, Emitter<HomeState> emit) async {
    try {
      emit(HomeLoadingState());
      await HomeRepository().setUserStatusOnline();
      emit(HomeSetOnlineSuccessState());
    } catch (e) {
      emit(HomeErrorState(e.toString()));
    }
  }

  void handleSetUserStatusOfflineEvent(
      SetUserStatusOfflineEvent event, Emitter<HomeState> emit) async {
    try {
      await HomeRepository().setUserStatusOffline();
    } catch (e) {
      emit(HomeErrorState(e.toString()));
    }
  }

  void handleGetOnlineUserNamesEvent(
      GetOnlineUserNamesEvent event, Emitter<HomeState> emit) async {
    try {
      emit(HomeLoadingState());
      final onlineUserNames = HomeRepository().getOnlineUserNames();
      emit(HomeGetOnlineUserNamesSuccessState(onlineUserNames));
    } catch (e) {
      emit(HomeErrorState(e.toString()));
    }
  }

  void handleSendImageAndStartGameEvent(
      SendImageAndStartGameEvent event, Emitter<HomeState> emit) async {
    try {
      emit(HomeLoadingState());
      await HomeRepository()
          .sendImageAndStartGame(event.imageFile, event.playerId);
      emit(HomeSendImageAndStartGameSuccessState());
    } catch (e) {
      emit(HomeErrorState(e.toString()));
    }
  }

  void handleExitGameEvent(ExitGameEvent event, Emitter<HomeState> emit) async {
    try {
      emit(HomeLoadingState());
      await HomeRepository().resetGame(event.gameLobbyId, event.battleWithId);
      emit(ExitGameSuccessState());
    } catch (e) {
      emit(HomeErrorState(e.toString()));
    }
  }

  void handleGetGameLobbySteamEvent(
      GetGameLobbySteamEvent event, Emitter<HomeState> emit) async {
    try {
      emit(HomeLoadingState());
      final gameLobbyStream =
          HomeRepository().getGameLobbyStream(event.gameLobbyId);
      emit(GetGameLobbySteamSuccessState(gameLobbyStream));
    } catch (e) {
      emit(HomeErrorState(e.toString()));
    }
  }

  void handleUpdatePositionEvent(
      UpdatePositionEvent event, Emitter<HomeState> emit) async {
    try {
      emit(HomeLoadingState());
      await HomeRepository().updatePosition(event.position, event.gameLobbyId);
      emit(UpdatePositionSuccessState());
    } catch (e) {
      emit(HomeErrorState(e.toString()));
    }
  }

  void handleUpdatePointsEvent(
      UpdatePointsEvent event, Emitter<HomeState> emit) async {
    try {
      emit(HomeLoadingState());
      await HomeRepository().updatePoints(event.gameLobbyId);
      emit(UpdatePointsSuccessState());
    } catch (e) {
      emit(HomeErrorState(e.toString()));
    }
  }

  void handleDecreasePointsEvent(
      DecreasePointsEvent event, Emitter<HomeState> emit) async {
    try {
      emit(HomeLoadingState());
      await HomeRepository().decreasePoints(event.gameLobbyId);
      emit(DecreasePointsSuccessState());
    } catch (e) {
      emit(HomeErrorState(e.toString()));
    }
  }
}
