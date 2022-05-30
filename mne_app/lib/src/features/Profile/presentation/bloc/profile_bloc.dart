import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mne_app/src/features/Profile/data/models/profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(Initial()) {
    on<LoadProfileEvent>((event, emit) async {
      emit(Loading());
      final failureOrProfile = await event.eventFunc();
      failureOrProfile.fold(
        (failure) => emit(Error()),
        (profile) => emit(Loaded(profile: profile)),
      );
    });

    on<SaveProfileImageEvent>((event, emit) async {
      emit(Saving());
      final failureOrSaved = await event.eventFunc();
      failureOrSaved.fold(
        (failure) => emit(Error()),
        (profile) => emit(Saved()),
      );
    });
  }
}
