import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(Initial()) {
    on<LoginWithCredentialsEvent>((event, emit) async {
      emit(LoggingIn());
      final failureOrLoggedIn = await event.func();
      emit(failureOrLoggedIn.fold((failure) => Error("Failed to Log In"),
          (success) => success ? LoggedIn() : Error("Failed to Log In")));
    });
  }
}
