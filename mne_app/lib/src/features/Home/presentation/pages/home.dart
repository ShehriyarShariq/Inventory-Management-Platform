import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mne_app/src/core/utils/firebase.dart';
import '../../domain/repositories/home_repository.dart';
import '../bloc/home_bloc.dart';
import '../../../../../injection_container.dart';
import '../../../../core/ui/top_bar_widget.dart';
import '../../../../core/utils/constants.dart';
import '../widgets/home_option_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeBloc _homeBloc;

  bool _isLoading = false;

  Map<String, String> _basicProfile = {};
  String _entriesCount = "0";

  @override
  void initState() {
    super.initState();

    _homeBloc = sl<HomeBloc>();

    _homeBloc.add(
      LoadHomeInitialEvent(
        profileFunc: () => sl<HomeRepository>().getNameAndProfileImg(),
        countFunc: () => sl<HomeRepository>().getEntryCount(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      bloc: _homeBloc,
      listener: (context, state) {
        if (state is Loading) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is Loaded) {
          setState(() {
            _isLoading = false;
            _basicProfile = state.basicProfile;
            _entriesCount = state.entriesCount;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: TopBarWidget(
          isBack: false,
          onClick: () => Navigator.pushNamed(context, Routes.MENU).then(
            (value) {
              _homeBloc.add(
                LoadHomeInitialEvent(
                  profileFunc: () =>
                      sl<HomeRepository>().getNameAndProfileImg(),
                  countFunc: () => sl<HomeRepository>().getEntryCount(),
                ),
              );
            },
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.09),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      !_isLoading || _basicProfile.isNotEmpty
                          ? RichText(
                              text: TextSpan(
                                text: "Hello, ",
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: FirebaseInit
                                            .auth.currentUser?.displayName ??
                                        "Guest",
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const Text(
                              "Loading...",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                      Container(
                        width: 50.0,
                        height: 50.0,
                        padding: const EdgeInsets.all(2.5),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 2.0,
                              spreadRadius: 2.0,
                              color: Colors.black12,
                            )
                          ],
                        ),
                        child: !_isLoading && _basicProfile.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(25.0),
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: FadeInImage(
                                    placeholder: const AssetImage(
                                        "assets/images/user.png"),
                                    image: FirebaseInit
                                                .auth.currentUser!.photoURL !=
                                            null
                                        ? Image.network(FirebaseInit.auth
                                                    .currentUser!.photoURL ??
                                                Constants.PROFILE_IMAGE_DEFAULT)
                                            .image
                                        : Image.asset("assets/images/user.png")
                                            .image,
                                  ),
                                ),
                              )
                            : const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                      )
                    ],
                  ),
                  const SizedBox(height: 25),
                  HomeOptionWidget(
                    bgColor: const Color.fromRGBO(244, 71, 113, 1),
                    label: "New Entry",
                    onClick: () =>
                        Navigator.pushNamed(context, Routes.NEW_ENTRY).then(
                      (value) {
                        _homeBloc.add(
                          LoadHomeInitialEvent(
                            profileFunc: () =>
                                sl<HomeRepository>().getNameAndProfileImg(),
                            countFunc: () =>
                                sl<HomeRepository>().getEntryCount(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                  HomeOptionWidget(
                    bgColor: const Color.fromRGBO(255, 154, 62, 1),
                    label: "Total Entry",
                    labelValue: _isLoading ? "" : _entriesCount,
                    isLoading: _isLoading,
                    onClick: () =>
                        Navigator.pushNamed(context, Routes.MY_ENTRIES).then(
                      (value) {
                        _homeBloc.add(
                          LoadHomeInitialEvent(
                            profileFunc: () =>
                                sl<HomeRepository>().getNameAndProfileImg(),
                            countFunc: () =>
                                sl<HomeRepository>().getEntryCount(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                  HomeOptionWidget(
                    bgColor: const Color.fromRGBO(244, 71, 113, 1),
                    label: "Reports",
                    onClick: () => Navigator.pushNamed(context, Routes.REPORTS),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
