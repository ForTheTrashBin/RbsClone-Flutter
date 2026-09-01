// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custodian_no_pk.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustodianNoPK extends CustodianNoPK {
  @override
  final String? depotno;
  @override
  final int flags;
  @override
  final String idcountry;
  @override
  final String name;
  @override
  final String shortcode;

  factory _$CustodianNoPK([void Function(CustodianNoPKBuilder)? updates]) =>
      (CustodianNoPKBuilder()..update(updates))._build();

  _$CustodianNoPK._(
      {this.depotno,
      required this.flags,
      required this.idcountry,
      required this.name,
      required this.shortcode})
      : super._();
  @override
  CustodianNoPK rebuild(void Function(CustodianNoPKBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CustodianNoPKBuilder toBuilder() => CustodianNoPKBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustodianNoPK &&
        depotno == other.depotno &&
        flags == other.flags &&
        idcountry == other.idcountry &&
        name == other.name &&
        shortcode == other.shortcode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, depotno.hashCode);
    _$hash = $jc(_$hash, flags.hashCode);
    _$hash = $jc(_$hash, idcountry.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, shortcode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustodianNoPK')
          ..add('depotno', depotno)
          ..add('flags', flags)
          ..add('idcountry', idcountry)
          ..add('name', name)
          ..add('shortcode', shortcode))
        .toString();
  }
}

class CustodianNoPKBuilder
    implements Builder<CustodianNoPK, CustodianNoPKBuilder> {
  _$CustodianNoPK? _$v;

  String? _depotno;
  String? get depotno => _$this._depotno;
  set depotno(String? depotno) => _$this._depotno = depotno;

  int? _flags;
  int? get flags => _$this._flags;
  set flags(int? flags) => _$this._flags = flags;

  String? _idcountry;
  String? get idcountry => _$this._idcountry;
  set idcountry(String? idcountry) => _$this._idcountry = idcountry;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _shortcode;
  String? get shortcode => _$this._shortcode;
  set shortcode(String? shortcode) => _$this._shortcode = shortcode;

  CustodianNoPKBuilder() {
    CustodianNoPK._defaults(this);
  }

  CustodianNoPKBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _depotno = $v.depotno;
      _flags = $v.flags;
      _idcountry = $v.idcountry;
      _name = $v.name;
      _shortcode = $v.shortcode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustodianNoPK other) {
    _$v = other as _$CustodianNoPK;
  }

  @override
  void update(void Function(CustodianNoPKBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustodianNoPK build() => _build();

  _$CustodianNoPK _build() {
    final _$result = _$v ??
        _$CustodianNoPK._(
          depotno: depotno,
          flags: BuiltValueNullFieldError.checkNotNull(
              flags, r'CustodianNoPK', 'flags'),
          idcountry: BuiltValueNullFieldError.checkNotNull(
              idcountry, r'CustodianNoPK', 'idcountry'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'CustodianNoPK', 'name'),
          shortcode: BuiltValueNullFieldError.checkNotNull(
              shortcode, r'CustodianNoPK', 'shortcode'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
