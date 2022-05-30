import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mne_app/injection_container.dart';
import 'package:mne_app/src/core/utils/constants.dart';
import 'package:mne_app/src/core/utils/firebase.dart';
import 'package:mne_app/src/features/Auth/domain/respositories/auth_repository.dart';
import 'package:mne_app/src/features/Profile/data/models/profile.dart';
import 'package:mne_app/src/features/Profile/domain/repositories/profile_repository.dart';
import 'package:mne_app/src/features/Profile/presentation/bloc/profile_bloc.dart';
import '../../../../core/ui/logout_button_widget.dart';
import '../../../../core/ui/top_bar_widget.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileBloc _profileBloc;

  Profile _profile = Profile.empty(dob: DateTime(2021));

  bool _isLoading = false;

  ImagePicker _imagePicker = ImagePicker();
  late XFile _displayImage;

  @override
  void initState() {
    super.initState();

    _profileBloc = sl<ProfileBloc>();

    _profileBloc.add(
      LoadProfileEvent(
        eventFunc: () => sl<ProfileRepository>().getProfile(),
      ),
    );
  }

  Widget _getRow(context, {label, value, isFullBig = false}) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
          child: Text(
            label,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 18.0,
              color: Color.fromRGBO(24, 23, 37, 1),
            ),
          ),
        ),
        const SizedBox(width: 5.0),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: isFullBig ? 18.0 : 16.0,
              color: isFullBig
                  ? const Color.fromRGBO(24, 23, 37, 1)
                  : const Color.fromRGBO(124, 124, 124, 1),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      bloc: _profileBloc,
      listener: (context, state) {
        if (state is Saved) {
          _profileBloc.add(
            LoadProfileEvent(
              eventFunc: () => sl<ProfileRepository>().getProfile(),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: TopBarWidget(
          isBack: true,
          title: "My Details",
          onClick: () => Navigator.pop(context),
          hasNotifIcon: true,
        ),
        body: SafeArea(
          child: BlocBuilder<ProfileBloc, ProfileState>(
            bloc: _profileBloc,
            builder: (context, state) {
              if (state is Loading || state is Saving) {
                return Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.width * 0.2,
                    child: const CircularProgressIndicator(
                      color: Color.fromRGBO(255, 154, 62, 1),
                    ),
                  ),
                );
              } else if (state is Error) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Try Again!",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        _profileBloc.add(
                          LoadProfileEvent(
                            eventFunc: () =>
                                sl<ProfileRepository>().getProfile(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(255, 154, 62, 1),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12.5,
                        ),
                        child: Text(
                          "Reload",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else if (state is Loaded) {
                _profile = state.profile;
              }

              return _getBody(context);
            },
          ),
        ),
      ),
    );
  }

  void _openCamera() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
      );

      Navigator.pop(context);

      _profileBloc.add(SaveProfileImageEvent(
          eventFunc: () => sl<ProfileRepository>()
              .uploadProfileImage(imageFile: File(pickedFile!.path))));
    } catch (e) {
      print(e);
    }
  }

  void _openGallery() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      Navigator.pop(context);

      _profileBloc.add(SaveProfileImageEvent(
          eventFunc: () => sl<ProfileRepository>()
              .uploadProfileImage(imageFile: File(pickedFile!.path))));
    } catch (e) {
      print(e);
    }
  }

  SingleChildScrollView _getBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20.0),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.15,
              height: MediaQuery.of(context).size.width * 0.15,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.15,
                ),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: FadeInImage(
                    placeholder: const AssetImage("assets/images/user.png"),
                    image: FirebaseInit.auth.currentUser!.photoURL != null
                        ? Image.network(
                                FirebaseInit.auth.currentUser!.photoURL ??
                                    Constants.PROFILE_IMAGE_DEFAULT)
                            .image
                        : Image.asset("assets/images/user.png").image,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 25,
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 12.5,
                    right: MediaQuery.of(context).size.width * 0.05,
                  ),
                  child: Container(
                    height: 1,
                    color: const Color.fromRGBO(226, 226, 226, 1),
                  ),
                ),
                Center(
                  child: InkWell(
                    onTap: () {
                      _showProfileImageBottomSheet();
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 5.0,
                      ),
                      child: Text(
                        "Edit Profile Picture",
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            child: Column(
              children: [
                const SizedBox(height: 40.0),
                _getRow(context,
                    label: "Name", value: _profile.name, isFullBig: true),
                const SizedBox(height: 30.0),
                _getRow(context, label: "Email", value: _profile.email),
                const SizedBox(height: 30.0),
                _getRow(context,
                    label: "Mobile Number", value: _profile.formattedPhoneNum),
                const SizedBox(height: 30.0),
                _getRow(context, label: "Gender", value: _profile.gender),
                const SizedBox(height: 30.0),
                _getRow(
                  context,
                  label: "DOB",
                  value: _profile.dobStr,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 120.0,
            child: ListView.builder(
              itemCount: 2,
              itemBuilder: (context, index) => Container(
                height: 60,
                margin: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.05,
                ),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color.fromRGBO(226, 226, 226, 1),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40.0),
          LogoutButtonWidget(),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

  _showProfileImageBottomSheet() {
    return showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                color: Colors.white.withOpacity(0.2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _bottomSheetRowItem(
                      icon: Icons.camera_alt,
                      label: "Camera",
                      onTap: () => _openCamera(),
                    ),
                    _bottomSheetRowItem(
                      icon: Icons.image,
                      label: "Gallery",
                      onTap: () => _openGallery(),
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }

  Widget _bottomSheetRowItem(
      {required IconData icon,
      required String label,
      required Function onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFF1B5E79), width: 0.1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: const Color(0xFF1B5E79),
              ),
              const SizedBox(width: 15),
              Text(
                label,
                style: TextStyle(
                    fontSize: 15, color: Colors.black.withOpacity(0.7)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
