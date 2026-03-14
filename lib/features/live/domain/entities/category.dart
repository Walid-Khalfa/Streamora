import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int id;
  final String name;
  final String type;

  const Category({
    required this.id,
    required this.name,
    required this.type,
  });

  @override
  List<Object?> get props => [id, name, type];
}
