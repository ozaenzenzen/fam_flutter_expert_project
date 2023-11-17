import 'package:equatable/equatable.dart';

class GenreEntity extends Equatable {
  GenreEntity({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory GenreEntity.fromJson(Map<String, dynamic> json) => GenreEntity(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  @override
  List<Object> get props => [id, name];
}
