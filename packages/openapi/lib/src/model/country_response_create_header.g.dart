// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_response_create_header.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CountryResponseCreateHeader extends CountryResponseCreateHeader {
  @override
  final String location;

  factory _$CountryResponseCreateHeader(
          [void Function(CountryResponseCreateHeaderBuilder)? updates]) =>
      (CountryResponseCreateHeaderBuilder()..update(updates))._build();

  _$CountryResponseCreateHeader._({required this.location}) : super._();
  @override
  CountryResponseCreateHeader rebuild(
          void Function(CountryResponseCreateHeaderBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CountryResponseCreateHeaderBuilder toBuilder() =>
      CountryResponseCreateHeaderBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CountryResponseCreateHeader && location == other.location;
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
    return (newBuiltValueToStringHelper(r'CountryResponseCreateHeader')
          ..add('location', location))
        .toString();
  }
}

class CountryResponseCreateHeaderBuilder
    implements
        Builder<CountryResponseCreateHeader,
            CountryResponseCreateHeaderBuilder> {
  _$CountryResponseCreateHeader? _$v;

  String? _location;
  String? get location => _$this._location;
  set location(String? location) => _$this._location = location;

  CountryResponseCreateHeaderBuilder() {
    CountryResponseCreateHeader._defaults(this);
  }

  CountryResponseCreateHeaderBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _location = $v.location;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CountryResponseCreateHeader other) {
    _$v = other as _$CountryResponseCreateHeader;
  }

  @override
  void update(void Function(CountryResponseCreateHeaderBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CountryResponseCreateHeader build() => _build();

  _$CountryResponseCreateHeader _build() {
    final _$result = _$v ??
        _$CountryResponseCreateHeader._(
          location: BuiltValueNullFieldError.checkNotNull(
              location, r'CountryResponseCreateHeader', 'location'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
