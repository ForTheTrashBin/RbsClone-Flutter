// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custodian_response_create_header.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustodianResponseCreateHeader extends CustodianResponseCreateHeader {
  @override
  final String location;

  factory _$CustodianResponseCreateHeader(
          [void Function(CustodianResponseCreateHeaderBuilder)? updates]) =>
      (CustodianResponseCreateHeaderBuilder()..update(updates))._build();

  _$CustodianResponseCreateHeader._({required this.location}) : super._();
  @override
  CustodianResponseCreateHeader rebuild(
          void Function(CustodianResponseCreateHeaderBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CustodianResponseCreateHeaderBuilder toBuilder() =>
      CustodianResponseCreateHeaderBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustodianResponseCreateHeader && location == other.location;
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
    return (newBuiltValueToStringHelper(r'CustodianResponseCreateHeader')
          ..add('location', location))
        .toString();
  }
}

class CustodianResponseCreateHeaderBuilder
    implements
        Builder<CustodianResponseCreateHeader,
            CustodianResponseCreateHeaderBuilder> {
  _$CustodianResponseCreateHeader? _$v;

  String? _location;
  String? get location => _$this._location;
  set location(String? location) => _$this._location = location;

  CustodianResponseCreateHeaderBuilder() {
    CustodianResponseCreateHeader._defaults(this);
  }

  CustodianResponseCreateHeaderBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _location = $v.location;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustodianResponseCreateHeader other) {
    _$v = other as _$CustodianResponseCreateHeader;
  }

  @override
  void update(void Function(CustodianResponseCreateHeaderBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustodianResponseCreateHeader build() => _build();

  _$CustodianResponseCreateHeader _build() {
    final _$result = _$v ??
        _$CustodianResponseCreateHeader._(
          location: BuiltValueNullFieldError.checkNotNull(
              location, r'CustodianResponseCreateHeader', 'location'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
