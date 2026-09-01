// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custodian2_exchange.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Custodian2Exchange extends Custodian2Exchange {
  @override
  final int flags;
  @override
  final String idcustodian;
  @override
  final String idexchange;
  @override
  final String value01;
  @override
  final int value02;

  factory _$Custodian2Exchange(
          [void Function(Custodian2ExchangeBuilder)? updates]) =>
      (Custodian2ExchangeBuilder()..update(updates))._build();

  _$Custodian2Exchange._(
      {required this.flags,
      required this.idcustodian,
      required this.idexchange,
      required this.value01,
      required this.value02})
      : super._();
  @override
  Custodian2Exchange rebuild(
          void Function(Custodian2ExchangeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  Custodian2ExchangeBuilder toBuilder() =>
      Custodian2ExchangeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Custodian2Exchange &&
        flags == other.flags &&
        idcustodian == other.idcustodian &&
        idexchange == other.idexchange &&
        value01 == other.value01 &&
        value02 == other.value02;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, flags.hashCode);
    _$hash = $jc(_$hash, idcustodian.hashCode);
    _$hash = $jc(_$hash, idexchange.hashCode);
    _$hash = $jc(_$hash, value01.hashCode);
    _$hash = $jc(_$hash, value02.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Custodian2Exchange')
          ..add('flags', flags)
          ..add('idcustodian', idcustodian)
          ..add('idexchange', idexchange)
          ..add('value01', value01)
          ..add('value02', value02))
        .toString();
  }
}

class Custodian2ExchangeBuilder
    implements Builder<Custodian2Exchange, Custodian2ExchangeBuilder> {
  _$Custodian2Exchange? _$v;

  int? _flags;
  int? get flags => _$this._flags;
  set flags(int? flags) => _$this._flags = flags;

  String? _idcustodian;
  String? get idcustodian => _$this._idcustodian;
  set idcustodian(String? idcustodian) => _$this._idcustodian = idcustodian;

  String? _idexchange;
  String? get idexchange => _$this._idexchange;
  set idexchange(String? idexchange) => _$this._idexchange = idexchange;

  String? _value01;
  String? get value01 => _$this._value01;
  set value01(String? value01) => _$this._value01 = value01;

  int? _value02;
  int? get value02 => _$this._value02;
  set value02(int? value02) => _$this._value02 = value02;

  Custodian2ExchangeBuilder() {
    Custodian2Exchange._defaults(this);
  }

  Custodian2ExchangeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _flags = $v.flags;
      _idcustodian = $v.idcustodian;
      _idexchange = $v.idexchange;
      _value01 = $v.value01;
      _value02 = $v.value02;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Custodian2Exchange other) {
    _$v = other as _$Custodian2Exchange;
  }

  @override
  void update(void Function(Custodian2ExchangeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Custodian2Exchange build() => _build();

  _$Custodian2Exchange _build() {
    final _$result = _$v ??
        _$Custodian2Exchange._(
          flags: BuiltValueNullFieldError.checkNotNull(
              flags, r'Custodian2Exchange', 'flags'),
          idcustodian: BuiltValueNullFieldError.checkNotNull(
              idcustodian, r'Custodian2Exchange', 'idcustodian'),
          idexchange: BuiltValueNullFieldError.checkNotNull(
              idexchange, r'Custodian2Exchange', 'idexchange'),
          value01: BuiltValueNullFieldError.checkNotNull(
              value01, r'Custodian2Exchange', 'value01'),
          value02: BuiltValueNullFieldError.checkNotNull(
              value02, r'Custodian2Exchange', 'value02'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
