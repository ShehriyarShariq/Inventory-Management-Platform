import 'package:equatable/equatable.dart';

class Chilli extends Equatable {
  final String id, label;

  const Chilli({
    required this.id,
    required this.label,
  });

  @override
  List<Object?> get props => [id, label];
}
