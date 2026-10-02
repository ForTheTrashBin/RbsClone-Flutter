// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_header.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LocationHeader extends LocationHeader {
  @override
  final String location;

  factory _$LocationHeader([void Function(LocationHeaderBuilder)? updates]) =>
      (LocationHeaderBuilder()..update(updates))._build();

  _$LocationHeader._({required this.location}) : super._();
  @override
  LocationHeader rebuild(void Function(LocationHeaderBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LocationHeaderBuilder toBuilder() => LocationHeaderBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LocationHeader && location == other.location;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LocationHeader')
          ..add('location', location))
        .toString();
  }
}

class LocationHeaderBuilder
    implements Builder<LocationHeader, LocationHeaderBuilder> {
  _$LocationHeader? _$v;

  String? _location;
  String? get location => _$this._location;
  set location(String? location) => _$this._location = location;

  LocationHeaderBuilder() {
    LocationHeader._defaults(this);
  }

  LocationHeaderBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _location = $v.location;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LocationHeader other) {
    _$v = other as _$LocationHeader;
  }

  @override
  void update(void Function(LocationHeaderBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LocationHeader build() => _build();

  _$LocationHeader _build() {
    final _$result = _$v ??
        _$LocationHeader._(
          location: BuiltValueNullFieldError.checkNotNull(
              location, r'LocationHeader', 'location'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
