// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hero_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HeroModel _$HeroModelFromJson(Map<String, dynamic> json) => _HeroModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  slug: json['slug'] as String,
  powerstats: Map<String, int?>.from(json['powerstats'] as Map),
  appearance: json['appearance'] as Map<String, dynamic>,
  biography: json['biography'] as Map<String, dynamic>,
  images: Map<String, String>.from(json['images'] as Map),
);

Map<String, dynamic> _$HeroModelToJson(_HeroModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'powerstats': instance.powerstats,
      'appearance': instance.appearance,
      'biography': instance.biography,
      'images': instance.images,
    };
