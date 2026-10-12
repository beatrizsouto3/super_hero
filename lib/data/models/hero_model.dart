import 'package:freezed_annotation/freezed_annotation.dart';

part 'hero_model.freezed.dart';
part 'hero_model.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
abstract class HeroModel with _$HeroModel {
  const factory HeroModel({
    required int id,
    required String name,
    required String slug,
    required Map<String, int?> powerstats,
    required Map<String, dynamic> appearance,
    required Map<String, dynamic> biography,
    @Default(<String, dynamic>{}) Map<String, dynamic> work,
    @Default(<String, dynamic>{}) Map<String, dynamic> connections,
    required Map<String, String> images,
  }) = _HeroModel;

  factory HeroModel.fromJson(Map<String, dynamic> json) =>
      _$HeroModelFromJson(json);
}
