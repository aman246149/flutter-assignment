import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>(handleLogin);
    on<SignupEvent>(handleSignup);
  }

  void handleLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      await AuthRepository().login(event.email, event.password);
      emit(const LoginSuccessState());
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  void handleSignup(SignupEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      await AuthRepository().signup(
        event.email,
        event.password,
        event.username,
      );
      emit(const SignupSuccessState());
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }
}
