import '../../domain/entities/tag.dart';

class TagModel extends Tag {
  const TagModel({
    required super.id,
    required super.name
  });

  factory TagModel.fromEntity({
    required int id,
    required String name
  }) {
    return TagModel(
      id: id,
      name: name
    );
  }
}