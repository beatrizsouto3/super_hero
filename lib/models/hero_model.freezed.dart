// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hero_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HeroModel {

 int get id; String get name; String get slug; Map<String, int?> get powerstats; Map<String, dynamic> get appearance; Map<String, dynamic> get biography; Map<String, String> get images;
/// Create a copy of HeroModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HeroModelCopyWith<HeroModel> get copyWith => _$HeroModelCopyWithImpl<HeroModel>(this as HeroModel, _$identity);

  /// Serializes this HeroModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HeroModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&const DeepCollectionEquality().equals(other.powerstats, powerstats)&&const DeepCollectionEquality().equals(other.appearance, appearance)&&const DeepCollectionEquality().equals(other.biography, biography)&&const DeepCollectionEquality().equals(other.images, images));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,slug,const DeepCollectionEquality().hash(powerstats),const DeepCollectionEquality().hash(appearance),const DeepCollectionEquality().hash(biography),const DeepCollectionEquality().hash(images));

@override
String toString() {
  return 'HeroModel(id: $id, name: $name, slug: $slug, powerstats: $powerstats, appearance: $appearance, biography: $biography, images: $images)';
}


}

/// @nodoc
abstract mixin class $HeroModelCopyWith<$Res>  {
  factory $HeroModelCopyWith(HeroModel value, $Res Function(HeroModel) _then) = _$HeroModelCopyWithImpl;
@useResult
$Res call({
 int id, String name, String slug, Map<String, int?> powerstats, Map<String, dynamic> appearance, Map<String, dynamic> biography, Map<String, String> images
});




}
/// @nodoc
class _$HeroModelCopyWithImpl<$Res>
    implements $HeroModelCopyWith<$Res> {
  _$HeroModelCopyWithImpl(this._self, this._then);

  final HeroModel _self;
  final $Res Function(HeroModel) _then;

/// Create a copy of HeroModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? slug = null,Object? powerstats = null,Object? appearance = null,Object? biography = null,Object? images = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,powerstats: null == powerstats ? _self.powerstats : powerstats // ignore: cast_nullable_to_non_nullable
as Map<String, int?>,appearance: null == appearance ? _self.appearance : appearance // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,biography: null == biography ? _self.biography : biography // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [HeroModel].
extension HeroModelPatterns on HeroModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HeroModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HeroModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HeroModel value)  $default,){
final _that = this;
switch (_that) {
case _HeroModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HeroModel value)?  $default,){
final _that = this;
switch (_that) {
case _HeroModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String slug,  Map<String, int?> powerstats,  Map<String, dynamic> appearance,  Map<String, dynamic> biography,  Map<String, String> images)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HeroModel() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.powerstats,_that.appearance,_that.biography,_that.images);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String slug,  Map<String, int?> powerstats,  Map<String, dynamic> appearance,  Map<String, dynamic> biography,  Map<String, String> images)  $default,) {final _that = this;
switch (_that) {
case _HeroModel():
return $default(_that.id,_that.name,_that.slug,_that.powerstats,_that.appearance,_that.biography,_that.images);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String slug,  Map<String, int?> powerstats,  Map<String, dynamic> appearance,  Map<String, dynamic> biography,  Map<String, String> images)?  $default,) {final _that = this;
switch (_that) {
case _HeroModel() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.powerstats,_that.appearance,_that.biography,_that.images);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HeroModel implements HeroModel {
  const _HeroModel({required this.id, required this.name, required this.slug, required this.powerstats, required this.appearance, required this.biography, required this.images});
  factory _HeroModel.fromJson(Map<String, dynamic> json) => _$HeroModelFromJson(json);

@override final  int id;
@override final  String name;
@override final  String slug;
@override final  Map<String, int?> powerstats;
@override final  Map<String, dynamic> appearance;
@override final  Map<String, dynamic> biography;
@override final  Map<String, String> images;

/// Create a copy of HeroModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HeroModelCopyWith<_HeroModel> get copyWith => __$HeroModelCopyWithImpl<_HeroModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HeroModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HeroModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&const DeepCollectionEquality().equals(other.powerstats, powerstats)&&const DeepCollectionEquality().equals(other.appearance, appearance)&&const DeepCollectionEquality().equals(other.biography, biography)&&const DeepCollectionEquality().equals(other.images, images));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,slug,const DeepCollectionEquality().hash(powerstats),const DeepCollectionEquality().hash(appearance),const DeepCollectionEquality().hash(biography),const DeepCollectionEquality().hash(images));

@override
String toString() {
  return 'HeroModel(id: $id, name: $name, slug: $slug, powerstats: $powerstats, appearance: $appearance, biography: $biography, images: $images)';
}


}

/// @nodoc
abstract mixin class _$HeroModelCopyWith<$Res> implements $HeroModelCopyWith<$Res> {
  factory _$HeroModelCopyWith(_HeroModel value, $Res Function(_HeroModel) _then) = __$HeroModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String slug, Map<String, int?> powerstats, Map<String, dynamic> appearance, Map<String, dynamic> biography, Map<String, String> images
});




}
/// @nodoc
class __$HeroModelCopyWithImpl<$Res>
    implements _$HeroModelCopyWith<$Res> {
  __$HeroModelCopyWithImpl(this._self, this._then);

  final _HeroModel _self;
  final $Res Function(_HeroModel) _then;

/// Create a copy of HeroModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? slug = null,Object? powerstats = null,Object? appearance = null,Object? biography = null,Object? images = null,}) {
  return _then(_HeroModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,powerstats: null == powerstats ? _self.powerstats : powerstats // ignore: cast_nullable_to_non_nullable
as Map<String, int?>,appearance: null == appearance ? _self.appearance : appearance // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,biography: null == biography ? _self.biography : biography // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
