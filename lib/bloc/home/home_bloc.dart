import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repository/home_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<SetUserStatusOnlineEvent>(handleSetUserStatusOnlineEvent);
    on<SetUserStatusOfflineEvent>(handleSetUserStatusOfflineEvent);
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
}
