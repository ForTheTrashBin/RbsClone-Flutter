// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_custodian2_exchange.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MapCustodian2Exchange extends MapCustodian2Exchange {
  @override
  final int flags;
  @override
  final String idcustodian;
  @override
  final String value01;
  @override
  final int value02;

  factory _$MapCustodian2Exchange(
          [void Function(MapCustodian2ExchangeBuilder)? updates]) =>
      (MapCustodian2ExchangeBuilder()..update(updates))._build();

  _$MapCustodian2Exchange._(
      {required this.flags,
      required this.idcustodian,
      required this.value01,
      required this.value02})
      : super._();
  @override
  MapCustodian2Exchange rebuild(
          void Function(MapCustodian2ExchangeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MapCustodian2ExchangeBuilder toBuilder() =>
      MapCustodian2ExchangeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MapCustodian2Exchange &&
        flags == other.flags &&
        idcustodian == other.idcustodian &&
        value01 == other.value01 &&
        value02 == other.value02;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, flags.hashCode);
    _$hash = $jc(_$hash, idcustodian.hashCode);
    _$hash = $jc(_$hash, value01.hashCode);
    _$hash = $jc(_$hash, value02.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MapCustodian2Exchange')
          ..add('flags', flags)
          ..add('idcustodian', idcustodian)
          ..add('value01', value01)
          ..add('value02', value02))
        .toString();
  }
}

class MapCustodian2ExchangeBuilder
    implements Builder<MapCustodian2Exchange, MapCustodian2ExchangeBuilder> {
  _$MapCustodian2Exchange? _$v;

  int? _flags;
  int? get flags => _$this._flags;
  set flags(int? flags) => _$this._flags = flags;

  String? _idcustodian;
  String? get idcustodian => _$this._idcustodian;
  set idcustodian(String? idcustodian) => _$this._idcustodian = idcustodian;

  String? _value01;
  String? get value01 => _$this._value01;
  set value01(String? value01) => _$this._value01 = value01;

  int? _value02;
  int? get value02 => _$this._value02;
  set value02(int? value02) => _$this._value02 = value02;

  MapCustodian2ExchangeBuilder() {
    MapCustodian2Exchange._defaults(this);
  }

  MapCustodian2ExchangeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _flags = $v.flags;
      _idcustodian = $v.idcustodian;
      _value01 = $v.value01;
      _value02 = $v.value02;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MapCustodian2Exchange other) {
    _$v = other as _$MapCustodian2Exchange;
  }

  @override
  void update(void Function(MapCustodian2ExchangeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MapCustodian2Exchange build() => _build();

  _$MapCustodian2Exchange _build() {
    final _$result = _$v ??
        _$MapCustodian2Exchange._(
          flags: BuiltValueNullFieldError.checkNotNull(
              flags, r'MapCustodian2Exchange', 'flags'),
          idcustodian: BuiltValueNullFieldError.checkNotNull(
              idcustodian, r'MapCustodian2Exchange', 'idcustodian'),
          value01: BuiltValueNullFieldError.checkNotNull(
              value01, r'MapCustodian2Exchange', 'value01'),
          value02: BuiltValueNullFieldError.checkNotNull(
              value02, r'MapCustodian2Exchange', 'value02'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
