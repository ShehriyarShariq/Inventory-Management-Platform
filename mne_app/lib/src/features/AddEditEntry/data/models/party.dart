import 'package:equatable/equatable.dart';

class Party extends Equatable {
  final String id, name;

  const Party({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
