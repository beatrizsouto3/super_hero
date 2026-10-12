// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'super_hero.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SuperHero {

 int get id; String get name; String get realName; String get publisher; String get alignment; String get imageUrl; Map<HeroStat, int> get stats; Map<String, String> get appearance; Map<String, String> get biography; Map<String, String> get work; Map<String, String> get connections;
/// Create a copy of SuperHero
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuperHeroCopyWith<SuperHero> get copyWith => _$SuperHeroCopyWithImpl<SuperHero>(this as SuperHero, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SuperHero&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.realName, realName) || other.realName == realName)&&(identical(other.publisher, publisher) || other.publisher == publisher)&&(identical(other.alignment, alignment) || other.alignment == alignment)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other.stats, stats)&&const DeepCollectionEquality().equals(other.appearance, appearance)&&const DeepCollectionEquality().equals(other.biography, biography)&&const DeepCollectionEquality().equals(other.work, work)&&const DeepCollectionEquality().equals(other.connections, connections));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,realName,publisher,alignment,imageUrl,const DeepCollectionEquality().hash(stats),const DeepCollectionEquality().hash(appearance),const DeepCollectionEquality().hash(biography),const DeepCollectionEquality().hash(work),const DeepCollectionEquality().hash(connections));

@override
String toString() {
  return 'SuperHero(id: $id, name: $name, realName: $realName, publisher: $publisher, alignment: $alignment, imageUrl: $imageUrl, stats: $stats, appearance: $appearance, biography: $biography, work: $work, connections: $connections)';
}


}

/// @nodoc
abstract mixin class $SuperHeroCopyWith<$Res>  {
  factory $SuperHeroCopyWith(SuperHero value, $Res Function(SuperHero) _then) = _$SuperHeroCopyWithImpl;
@useResult
$Res call({
 int id, String name, String realName, String publisher, String alignment, String imageUrl, Map<HeroStat, int> stats, Map<String, String> appearance, Map<String, String> biography, Map<String, String> work, Map<String, String> connections
});




}
/// @nodoc
class _$SuperHeroCopyWithImpl<$Res>
    implements $SuperHeroCopyWith<$Res> {
  _$SuperHeroCopyWithImpl(this._self, this._then);

  final SuperHero _self;
  final $Res Function(SuperHero) _then;

/// Create a copy of SuperHero
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? realName = null,Object? publisher = null,Object? alignment = null,Object? imageUrl = null,Object? stats = null,Object? appearance = null,Object? biography = null,Object? work = null,Object? connections = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,realName: null == realName ? _self.realName : realName // ignore: cast_nullable_to_non_nullable
as String,publisher: null == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String,alignment: null == alignment ? _self.alignment : alignment // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as Map<HeroStat, int>,appearance: null == appearance ? _self.appearance : appearance // ignore: cast_nullable_to_non_nullable
as Map<String, String>,biography: null == biography ? _self.biography : biography // ignore: cast_nullable_to_non_nullable
as Map<String, String>,work: null == work ? _self.work : work // ignore: cast_nullable_to_non_nullable
as Map<String, String>,connections: null == connections ? _self.connections : connections // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SuperHero].
extension SuperHeroPatterns on SuperHero {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SuperHero value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SuperHero() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SuperHero value)  $default,){
final _that = this;
switch (_that) {
case _SuperHero():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SuperHero value)?  $default,){
final _that = this;
switch (_that) {
case _SuperHero() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String realName,  String publisher,  String alignment,  String imageUrl,  Map<HeroStat, int> stats,  Map<String, String> appearance,  Map<String, String> biography,  Map<String, String> work,  Map<String, String> connections)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SuperHero() when $default != null:
return $default(_that.id,_that.name,_that.realName,_that.publisher,_that.alignment,_that.imageUrl,_that.stats,_that.appearance,_that.biography,_that.work,_that.connections);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String realName,  String publisher,  String alignment,  String imageUrl,  Map<HeroStat, int> stats,  Map<String, String> appearance,  Map<String, String> biography,  Map<String, String> work,  Map<String, String> connections)  $default,) {final _that = this;
switch (_that) {
case _SuperHero():
return $default(_that.id,_that.name,_that.realName,_that.publisher,_that.alignment,_that.imageUrl,_that.stats,_that.appearance,_that.biography,_that.work,_that.connections);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String realName,  String publisher,  String alignment,  String imageUrl,  Map<HeroStat, int> stats,  Map<String, String> appearance,  Map<String, String> biography,  Map<String, String> work,  Map<String, String> connections)?  $default,) {final _that = this;
switch (_that) {
case _SuperHero() when $default != null:
return $default(_that.id,_that.name,_that.realName,_that.publisher,_that.alignment,_that.imageUrl,_that.stats,_that.appearance,_that.biography,_that.work,_that.connections);case _:
  return null;

}
}

}

/// @nodoc


class _SuperHero extends SuperHero {
  const _SuperHero({required this.id, required this.name, required this.realName, required this.publisher, required this.alignment, required this.imageUrl, required this.stats, required this.appearance, required this.biography, this.work = const <String, String>{}, this.connections = const <String, String>{}}): super._();
  

@override final  int id;
@override final  String name;
@override final  String realName;
@override final  String publisher;
@override final  String alignment;
@override final  String imageUrl;
@override final  Map<HeroStat, int> stats;
@override final  Map<String, String> appearance;
@override final  Map<String, String> biography;
@override@JsonKey() final  Map<String, String> work;
@override@JsonKey() final  Map<String, String> connections;

/// Create a copy of SuperHero
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuperHeroCopyWith<_SuperHero> get copyWith => __$SuperHeroCopyWithImpl<_SuperHero>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SuperHero&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.realName, realName) || other.realName == realName)&&(identical(other.publisher, publisher) || other.publisher == publisher)&&(identical(other.alignment, alignment) || other.alignment == alignment)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other.stats, stats)&&const DeepCollectionEquality().equals(other.appearance, appearance)&&const DeepCollectionEquality().equals(other.biography, biography)&&const DeepCollectionEquality().equals(other.work, work)&&const DeepCollectionEquality().equals(other.connections, connections));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,realName,publisher,alignment,imageUrl,const DeepCollectionEquality().hash(stats),const DeepCollectionEquality().hash(appearance),const DeepCollectionEquality().hash(biography),const DeepCollectionEquality().hash(work),const DeepCollectionEquality().hash(connections));

@override
String toString() {
  return 'SuperHero(id: $id, name: $name, realName: $realName, publisher: $publisher, alignment: $alignment, imageUrl: $imageUrl, stats: $stats, appearance: $appearance, biography: $biography, work: $work, connections: $connections)';
}


}

/// @nodoc
abstract mixin class _$SuperHeroCopyWith<$Res> implements $SuperHeroCopyWith<$Res> {
  factory _$SuperHeroCopyWith(_SuperHero value, $Res Function(_SuperHero) _then) = __$SuperHeroCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String realName, String publisher, String alignment, String imageUrl, Map<HeroStat, int> stats, Map<String, String> appearance, Map<String, String> biography, Map<String, String> work, Map<String, String> connections
});




}
/// @nodoc
class __$SuperHeroCopyWithImpl<$Res>
    implements _$SuperHeroCopyWith<$Res> {
  __$SuperHeroCopyWithImpl(this._self, this._then);

  final _SuperHero _self;
  final $Res Function(_SuperHero) _then;

/// Create a copy of SuperHero
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? realName = null,Object? publisher = null,Object? alignment = null,Object? imageUrl = null,Object? stats = null,Object? appearance = null,Object? biography = null,Object? work = null,Object? connections = null,}) {
  return _then(_SuperHero(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,realName: null == realName ? _self.realName : realName // ignore: cast_nullable_to_non_nullable
as String,publisher: null == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String,alignment: null == alignment ? _self.alignment : alignment // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as Map<HeroStat, int>,appearance: null == appearance ? _self.appearance : appearance // ignore: cast_nullable_to_non_nullable
as Map<String, String>,biography: null == biography ? _self.biography : biography // ignore: cast_nullable_to_non_nullable
as Map<String, String>,work: null == work ? _self.work : work // ignore: cast_nullable_to_non_nullable
as Map<String, String>,connections: null == connections ? _self.connections : connections // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
