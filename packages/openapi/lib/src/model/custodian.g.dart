// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custodian.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Custodian extends Custodian {
  @override
  final String? depotno;
  @override
  final BuiltList<Exchange2CustodianListItem>? exchanges;
  @override
  final int flags;
  @override
  final String id;
  @override
  final String idcountry;
  @override
  final String? idexchangedefault;
  @override
  final String name;
  @override
  final String shortcode;

  factory _$Custodian([void Function(CustodianBuilder)? updates]) =>
      (CustodianBuilder()..update(updates))._build();

  _$Custodian._(
      {this.depotno,
      this.exchanges,
      required this.flags,
      required this.id,
      required this.idcountry,
      this.idexchangedefault,
      required this.name,
      required this.shortcode})
      : super._();
  @override
  Custodian rebuild(void Function(CustodianBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CustodianBuilder toBuilder() => CustodianBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Custodian &&
        depotno == other.depotno &&
        exchanges == other.exchanges &&
        flags == other.flags &&
        id == other.id &&
        idcountry == other.idcountry &&
        idexchangedefault == other.idexchangedefault &&
        name == other.name &&
        shortcode == other.shortcode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, depotno.hashCode);
    _$hash = $jc(_$hash, exchanges.hashCode);
    _$hash = $jc(_$hash, flags.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, idcountry.hashCode);
    _$hash = $jc(_$hash, idexchangedefault.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, shortcode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Custodian')
          ..add('depotno', depotno)
          ..add('exchanges', exchanges)
          ..add('flags', flags)
          ..add('id', id)
          ..add('idcountry', idcountry)
          ..add('idexchangedefault', idexchangedefault)
          ..add('name', name)
          ..add('shortcode', shortcode))
        .toString();
  }
}

class CustodianBuilder implements Builder<Custodian, CustodianBuilder> {
  _$Custodian? _$v;

  String? _depotno;
  String? get depotno => _$this._depotno;
  set depotno(String? depotno) => _$this._depotno = depotno;

  ListBuilder<Exchange2CustodianListItem>? _exchanges;
  ListBuilder<Exchange2CustodianListItem> get exchanges =>
      _$this._exchanges ??= ListBuilder<Exchange2CustodianListItem>();
  set exchanges(ListBuilder<Exchange2CustodianListItem>? exchanges) =>
      _$this._exchanges = exchanges;

  int? _flags;
  int? get flags => _$this._flags;
  set flags(int? flags) => _$this._flags = flags;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _idcountry;
  String? get idcountry => _$this._idcountry;
  set idcountry(String? idcountry) => _$this._idcountry = idcountry;

  String? _idexchangedefault;
  String? get idexchangedefault => _$this._idexchangedefault;
  set idexchangedefault(String? idexchangedefault) =>
      _$this._idexchangedefault = idexchangedefault;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _shortcode;
  String? get shortcode => _$this._shortcode;
  set shortcode(String? shortcode) => _$this._shortcode = shortcode;

  CustodianBuilder() {
    Custodian._defaults(this);
  }

  CustodianBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _depotno = $v.depotno;
      _exchanges = $v.exchanges?.toBuilder();
      _flags = $v.flags;
      _id = $v.id;
      _idcountry = $v.idcountry;
      _idexchangedefault = $v.idexchangedefault;
      _name = $v.name;
      _shortcode = $v.shortcode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Custodian other) {
    _$v = other as _$Custodian;
  }

  @override
  void update(void Function(CustodianBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Custodian build() => _build();

  _$Custodian _build() {
    _$Custodian _$result;
    try {
      _$result = _$v ??
          _$Custodian._(
            depotno: depotno,
            exchanges: _exchanges?.build(),
            flags: BuiltValueNullFieldError.checkNotNull(
                flags, r'Custodian', 'flags'),
            id: BuiltValueNullFieldError.checkNotNull(id, r'Custodian', 'id'),
            idcountry: BuiltValueNullFieldError.checkNotNull(
                idcountry, r'Custodian', 'idcountry'),
            idexchangedefault: idexchangedefault,
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'Custodian', 'name'),
            shortcode: BuiltValueNullFieldError.checkNotNull(
                shortcode, r'Custodian', 'shortcode'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'exchanges';
        _exchanges?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'Custodian', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
