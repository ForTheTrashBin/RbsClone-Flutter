// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Country extends Country {
  @override
  final int flags;
  @override
  final int? ibanlenth;
  @override
  final String id;
  @override
  final String name;
  @override
  final int risktype;
  @override
  final String shortcode;

  factory _$Country([void Function(CountryBuilder)? updates]) =>
      (CountryBuilder()..update(updates))._build();

  _$Country._(
      {required this.flags,
      this.ibanlenth,
      required this.id,
      required this.name,
      required this.risktype,
      required this.shortcode})
      : super._();
  @override
  Country rebuild(void Function(CountryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CountryBuilder toBuilder() => CountryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Country &&
        flags == other.flags &&
        ibanlenth == other.ibanlenth &&
        id == other.id &&
        name == other.name &&
        risktype == other.risktype &&
        shortcode == other.shortcode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, flags.hashCode);
    _$hash = $jc(_$hash, ibanlenth.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, risktype.hashCode);
    _$hash = $jc(_$hash, shortcode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Country')
          ..add('flags', flags)
          ..add('ibanlenth', ibanlenth)
          ..add('id', id)
          ..add('name', name)
          ..add('risktype', risktype)
          ..add('shortcode', shortcode))
        .toString();
  }
}

class CountryBuilder implements Builder<Country, CountryBuilder> {
  _$Country? _$v;

  int? _flags;
  int? get flags => _$this._flags;
  set flags(int? flags) => _$this._flags = flags;

  int? _ibanlenth;
  int? get ibanlenth => _$this._ibanlenth;
  set ibanlenth(int? ibanlenth) => _$this._ibanlenth = ibanlenth;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _risktype;
  int? get risktype => _$this._risktype;
  set risktype(int? risktype) => _$this._risktype = risktype;

  String? _shortcode;
  String? get shortcode => _$this._shortcode;
  set shortcode(String? shortcode) => _$this._shortcode = shortcode;

  CountryBuilder() {
    Country._defaults(this);
  }

  CountryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _flags = $v.flags;
      _ibanlenth = $v.ibanlenth;
      _id = $v.id;
      _name = $v.name;
      _risktype = $v.risktype;
      _shortcode = $v.shortcode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Country other) {
    _$v = other as _$Country;
  }

  @override
  void update(void Function(CountryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Country build() => _build();

  _$Country _build() {
    final _$result = _$v ??
        _$Country._(
          flags:
              BuiltValueNullFieldError.checkNotNull(flags, r'Country', 'flags'),
          ibanlenth: ibanlenth,
          id: BuiltValueNullFieldError.checkNotNull(id, r'Country', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(name, r'Country', 'name'),
          risktype: BuiltValueNullFieldError.checkNotNull(
              risktype, r'Country', 'risktype'),
          shortcode: BuiltValueNullFieldError.checkNotNull(
              shortcode, r'Country', 'shortcode'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
