// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange2_custodian_list_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Exchange2CustodianListItem extends Exchange2CustodianListItem {
  @override
  final String idexchange;
  @override
  final int value1;
  @override
  final int value2;

  factory _$Exchange2CustodianListItem(
          [void Function(Exchange2CustodianListItemBuilder)? updates]) =>
      (Exchange2CustodianListItemBuilder()..update(updates))._build();

  _$Exchange2CustodianListItem._(
      {required this.idexchange, required this.value1, required this.value2})
      : super._();
  @override
  Exchange2CustodianListItem rebuild(
          void Function(Exchange2CustodianListItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  Exchange2CustodianListItemBuilder toBuilder() =>
      Exchange2CustodianListItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Exchange2CustodianListItem &&
        idexchange == other.idexchange &&
        value1 == other.value1 &&
        value2 == other.value2;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, idexchange.hashCode);
    _$hash = $jc(_$hash, value1.hashCode);
    _$hash = $jc(_$hash, value2.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Exchange2CustodianListItem')
          ..add('idexchange', idexchange)
          ..add('value1', value1)
          ..add('value2', value2))
        .toString();
  }
}

class Exchange2CustodianListItemBuilder
    implements
        Builder<Exchange2CustodianListItem, Exchange2CustodianListItemBuilder> {
  _$Exchange2CustodianListItem? _$v;

  String? _idexchange;
  String? get idexchange => _$this._idexchange;
  set idexchange(String? idexchange) => _$this._idexchange = idexchange;

  int? _value1;
  int? get value1 => _$this._value1;
  set value1(int? value1) => _$this._value1 = value1;

  int? _value2;
  int? get value2 => _$this._value2;
  set value2(int? value2) => _$this._value2 = value2;

  Exchange2CustodianListItemBuilder() {
    Exchange2CustodianListItem._defaults(this);
  }

  Exchange2CustodianListItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _idexchange = $v.idexchange;
      _value1 = $v.value1;
      _value2 = $v.value2;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Exchange2CustodianListItem other) {
    _$v = other as _$Exchange2CustodianListItem;
  }

  @override
  void update(void Function(Exchange2CustodianListItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Exchange2CustodianListItem build() => _build();

  _$Exchange2CustodianListItem _build() {
    final _$result = _$v ??
        _$Exchange2CustodianListItem._(
          idexchange: BuiltValueNullFieldError.checkNotNull(
              idexchange, r'Exchange2CustodianListItem', 'idexchange'),
          value1: BuiltValueNullFieldError.checkNotNull(
              value1, r'Exchange2CustodianListItem', 'value1'),
          value2: BuiltValueNullFieldError.checkNotNull(
              value2, r'Exchange2CustodianListItem', 'value2'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
