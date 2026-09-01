// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_no_pk.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CountryNoPK extends CountryNoPK {
  @override
  final int flags;
  @override
  final int? ibanlenth;
  @override
  final String name;
  @override
  final int risktype;
  @override
  final String shortcode;

  factory _$CountryNoPK([void Function(CountryNoPKBuilder)? updates]) =>
      (CountryNoPKBuilder()..update(updates))._build();

  _$CountryNoPK._(
      {required this.flags,
      this.ibanlenth,
      required this.name,
      required this.risktype,
      required this.shortcode})
      : super._();
  @override
  CountryNoPK rebuild(void Function(CountryNoPKBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CountryNoPKBuilder toBuilder() => CountryNoPKBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CountryNoPK &&
        flags == other.flags &&
        ibanlenth == other.ibanlenth &&
        name == other.name &&
        risktype == other.risktype &&
        shortcode == other.shortcode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, flags.hashCode);
    _$hash = $jc(_$hash, ibanlenth.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, risktype.hashCode);
    _$hash = $jc(_$hash, shortcode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CountryNoPK')
          ..add('flags', flags)
          ..add('ibanlenth', ibanlenth)
          ..add('name', name)
          ..add('risktype', risktype)
          ..add('shortcode', shortcode))
        .toString();
  }
}

class CountryNoPKBuilder implements Builder<CountryNoPK, CountryNoPKBuilder> {
  _$CountryNoPK? _$v;

  int? _flags;
  int? get flags => _$this._flags;
  set flags(int? flags) => _$this._flags = flags;

  int? _ibanlenth;
  int? get ibanlenth => _$this._ibanlenth;
  set ibanlenth(int? ibanlenth) => _$this._ibanlenth = ibanlenth;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _risktype;
  int? get risktype => _$this._risktype;
  set risktype(int? risktype) => _$this._risktype = risktype;

  String? _shortcode;
  String? get shortcode => _$this._shortcode;
  set shortcode(String? shortcode) => _$this._shortcode = shortcode;

  CountryNoPKBuilder() {
    CountryNoPK._defaults(this);
  }

  CountryNoPKBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _flags = $v.flags;
      _ibanlenth = $v.ibanlenth;
      _name = $v.name;
      _risktype = $v.risktype;
      _shortcode = $v.shortcode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CountryNoPK other) {
    _$v = other as _$CountryNoPK;
  }

  @override
  void update(void Function(CountryNoPKBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CountryNoPK build() => _build();

  _$CountryNoPK _build() {
    final _$result = _$v ??
        _$CountryNoPK._(
          flags: BuiltValueNullFieldError.checkNotNull(
              flags, r'CountryNoPK', 'flags'),
          ibanlenth: ibanlenth,
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'CountryNoPK', 'name'),
          risktype: BuiltValueNullFieldError.checkNotNull(
              risktype, r'CountryNoPK', 'risktype'),
          shortcode: BuiltValueNullFieldError.checkNotNull(
              shortcode, r'CountryNoPK', 'shortcode'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
