import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class Profile extends Equatable {
  final String name, email, phoneNum, gender, profileImg;
  final DateTime dob;

  const Profile({
    required this.name,
    required this.email,
    required this.phoneNum,
    required this.gender,
    required this.profileImg,
    required this.dob,
  });

  const Profile.empty({
    this.name = "",
    this.email = "",
    this.phoneNum = "",
    this.gender = "",
    this.profileImg = "",
    required this.dob,
  });

  String get formattedPhoneNum => phoneNum.isNotEmpty
      ? "${phoneNum.substring(0, 3)} ${phoneNum.substring(3)}"
      : phoneNum;

  String get dobStr => DateFormat("dd/MM/yyyy").format(dob);

  @override
  List<Object?> get props => [name, email, phoneNum, gender, dob];
}
