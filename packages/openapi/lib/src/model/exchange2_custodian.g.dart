// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange2_custodian.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Exchange2Custodian extends Exchange2Custodian {
  @override
  final String idcustodian;
  @override
  final String idexchange;
  @override
  final int sequenceno;
  @override
  final int value1;
  @override
  final int value2;

  factory _$Exchange2Custodian(
          [void Function(Exchange2CustodianBuilder)? updates]) =>
      (Exchange2CustodianBuilder()..update(updates))._build();

  _$Exchange2Custodian._(
      {required this.idcustodian,
      required this.idexchange,
      required this.sequenceno,
      required this.value1,
      required this.value2})
      : super._();
  @override
  Exchange2Custodian rebuild(
          void Function(Exchange2CustodianBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  Exchange2CustodianBuilder toBuilder() =>
      Exchange2CustodianBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Exchange2Custodian &&
        idcustodian == other.idcustodian &&
        idexchange == other.idexchange &&
        sequenceno == other.sequenceno &&
        value1 == other.value1 &&
        value2 == other.value2;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, idcustodian.hashCode);
    _$hash = $jc(_$hash, idexchange.hashCode);
    _$hash = $jc(_$hash, sequenceno.hashCode);
    _$hash = $jc(_$hash, value1.hashCode);
    _$hash = $jc(_$hash, value2.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Exchange2Custodian')
          ..add('idcustodian', idcustodian)
          ..add('idexchange', idexchange)
          ..add('sequenceno', sequenceno)
          ..add('value1', value1)
          ..add('value2', value2))
        .toString();
  }
}

class Exchange2CustodianBuilder
    implements Builder<Exchange2Custodian, Exchange2CustodianBuilder> {
  _$Exchange2Custodian? _$v;

  String? _idcustodian;
  String? get idcustodian => _$this._idcustodian;
  set idcustodian(String? idcustodian) => _$this._idcustodian = idcustodian;

  String? _idexchange;
  String? get idexchange => _$this._idexchange;
  set idexchange(String? idexchange) => _$this._idexchange = idexchange;

  int? _sequenceno;
  int? get sequenceno => _$this._sequenceno;
  set sequenceno(int? sequenceno) => _$this._sequenceno = sequenceno;

  int? _value1;
  int? get value1 => _$this._value1;
  set value1(int? value1) => _$this._value1 = value1;

  int? _value2;
  int? get value2 => _$this._value2;
  set value2(int? value2) => _$this._value2 = value2;

  Exchange2CustodianBuilder() {
    Exchange2Custodian._defaults(this);
  }

  Exchange2CustodianBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _idcustodian = $v.idcustodian;
      _idexchange = $v.idexchange;
      _sequenceno = $v.sequenceno;
      _value1 = $v.value1;
      _value2 = $v.value2;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Exchange2Custodian other) {
    _$v = other as _$Exchange2Custodian;
  }

  @override
  void update(void Function(Exchange2CustodianBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Exchange2Custodian build() => _build();

  _$Exchange2Custodian _build() {
    final _$result = _$v ??
        _$Exchange2Custodian._(
          idcustodian: BuiltValueNullFieldError.checkNotNull(
              idcustodian, r'Exchange2Custodian', 'idcustodian'),
          idexchange: BuiltValueNullFieldError.checkNotNull(
              idexchange, r'Exchange2Custodian', 'idexchange'),
          sequenceno: BuiltValueNullFieldError.checkNotNull(
              sequenceno, r'Exchange2Custodian', 'sequenceno'),
          value1: BuiltValueNullFieldError.checkNotNull(
              value1, r'Exchange2Custodian', 'value1'),
          value2: BuiltValueNullFieldError.checkNotNull(
              value2, r'Exchange2Custodian', 'value2'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
