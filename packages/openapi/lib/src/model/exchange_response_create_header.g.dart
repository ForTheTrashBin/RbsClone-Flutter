// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_response_create_header.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ExchangeResponseCreateHeader extends ExchangeResponseCreateHeader {
  @override
  final String location;

  factory _$ExchangeResponseCreateHeader(
          [void Function(ExchangeResponseCreateHeaderBuilder)? updates]) =>
      (ExchangeResponseCreateHeaderBuilder()..update(updates))._build();

  _$ExchangeResponseCreateHeader._({required this.location}) : super._();
  @override
  ExchangeResponseCreateHeader rebuild(
          void Function(ExchangeResponseCreateHeaderBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExchangeResponseCreateHeaderBuilder toBuilder() =>
      ExchangeResponseCreateHeaderBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExchangeResponseCreateHeader && location == other.location;
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
    return (newBuiltValueToStringHelper(r'ExchangeResponseCreateHeader')
          ..add('location', location))
        .toString();
  }
}

class ExchangeResponseCreateHeaderBuilder
    implements
        Builder<ExchangeResponseCreateHeader,
            ExchangeResponseCreateHeaderBuilder> {
  _$ExchangeResponseCreateHeader? _$v;

  String? _location;
  String? get location => _$this._location;
  set location(String? location) => _$this._location = location;

  ExchangeResponseCreateHeaderBuilder() {
    ExchangeResponseCreateHeader._defaults(this);
  }

  ExchangeResponseCreateHeaderBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _location = $v.location;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExchangeResponseCreateHeader other) {
    _$v = other as _$ExchangeResponseCreateHeader;
  }

  @override
  void update(void Function(ExchangeResponseCreateHeaderBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExchangeResponseCreateHeader build() => _build();

  _$ExchangeResponseCreateHeader _build() {
    final _$result = _$v ??
        _$ExchangeResponseCreateHeader._(
          location: BuiltValueNullFieldError.checkNotNull(
              location, r'ExchangeResponseCreateHeader', 'location'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
