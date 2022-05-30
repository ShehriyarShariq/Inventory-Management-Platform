import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(Initial()) {
    on<LoadHomeInitialEvent>((event, emit) async {
      emit(Loading());
      final failureOrProfile = await event.profileFunc();
      final failureOrCount = await event.countFunc();

      Map<String, String> basicProfile = {};
      String entriesCount = "0";

      bool isProfileLoadedError = false;

      failureOrProfile.fold(
        (failure) => {isProfileLoadedError = true},
        (profile) => {basicProfile = profile},
      );

      failureOrCount.fold(
        (failure) => {},
        (count) => {entriesCount = count},
      );

      emit(
        Loaded(
          basicProfile: isProfileLoadedError ? {} : basicProfile,
          entriesCount: entriesCount,
        ),
      );
    });
  }
}
