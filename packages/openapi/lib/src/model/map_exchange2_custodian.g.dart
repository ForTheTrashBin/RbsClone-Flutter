// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_exchange2_custodian.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MapExchange2Custodian extends MapExchange2Custodian {
  @override
  final int flags;
  @override
  final String idexchange;
  @override
  final String value01;
  @override
  final int value02;

  factory _$MapExchange2Custodian(
          [void Function(MapExchange2CustodianBuilder)? updates]) =>
      (MapExchange2CustodianBuilder()..update(updates))._build();

  _$MapExchange2Custodian._(
      {required this.flags,
      required this.idexchange,
      required this.value01,
      required this.value02})
      : super._();
  @override
  MapExchange2Custodian rebuild(
          void Function(MapExchange2CustodianBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MapExchange2CustodianBuilder toBuilder() =>
      MapExchange2CustodianBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MapExchange2Custodian &&
        flags == other.flags &&
        idexchange == other.idexchange &&
        value01 == other.value01 &&
        value02 == other.value02;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, flags.hashCode);
    _$hash = $jc(_$hash, idexchange.hashCode);
    _$hash = $jc(_$hash, value01.hashCode);
    _$hash = $jc(_$hash, value02.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MapExchange2Custodian')
          ..add('flags', flags)
          ..add('idexchange', idexchange)
          ..add('value01', value01)
          ..add('value02', value02))
        .toString();
  }
}

class MapExchange2CustodianBuilder
    implements Builder<MapExchange2Custodian, MapExchange2CustodianBuilder> {
  _$MapExchange2Custodian? _$v;

  int? _flags;
  int? get flags => _$this._flags;
  set flags(int? flags) => _$this._flags = flags;

  String? _idexchange;
  String? get idexchange => _$this._idexchange;
  set idexchange(String? idexchange) => _$this._idexchange = idexchange;

  String? _value01;
  String? get value01 => _$this._value01;
  set value01(String? value01) => _$this._value01 = value01;

  int? _value02;
  int? get value02 => _$this._value02;
  set value02(int? value02) => _$this._value02 = value02;

  MapExchange2CustodianBuilder() {
    MapExchange2Custodian._defaults(this);
  }

  MapExchange2CustodianBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _flags = $v.flags;
      _idexchange = $v.idexchange;
      _value01 = $v.value01;
      _value02 = $v.value02;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MapExchange2Custodian other) {
    _$v = other as _$MapExchange2Custodian;
  }

  @override
  void update(void Function(MapExchange2CustodianBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MapExchange2Custodian build() => _build();

  _$MapExchange2Custodian _build() {
    final _$result = _$v ??
        _$MapExchange2Custodian._(
          flags: BuiltValueNullFieldError.checkNotNull(
              flags, r'MapExchange2Custodian', 'flags'),
          idexchange: BuiltValueNullFieldError.checkNotNull(
              idexchange, r'MapExchange2Custodian', 'idexchange'),
          value01: BuiltValueNullFieldError.checkNotNull(
              value01, r'MapExchange2Custodian', 'value01'),
          value02: BuiltValueNullFieldError.checkNotNull(
              value02, r'MapExchange2Custodian', 'value02'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
