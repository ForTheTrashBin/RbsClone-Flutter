// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_no_pk.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ExchangeNoPK extends ExchangeNoPK {
  @override
  final int flags;
  @override
  final String name;
  @override
  final String shortcode;

  factory _$ExchangeNoPK([void Function(ExchangeNoPKBuilder)? updates]) =>
      (ExchangeNoPKBuilder()..update(updates))._build();

  _$ExchangeNoPK._(
      {required this.flags, required this.name, required this.shortcode})
      : super._();
  @override
  ExchangeNoPK rebuild(void Function(ExchangeNoPKBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExchangeNoPKBuilder toBuilder() => ExchangeNoPKBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExchangeNoPK &&
        flags == other.flags &&
        name == other.name &&
        shortcode == other.shortcode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, flags.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, shortcode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ExchangeNoPK')
          ..add('flags', flags)
          ..add('name', name)
          ..add('shortcode', shortcode))
        .toString();
  }
}

class ExchangeNoPKBuilder
    implements Builder<ExchangeNoPK, ExchangeNoPKBuilder> {
  _$ExchangeNoPK? _$v;

  int? _flags;
  int? get flags => _$this._flags;
  set flags(int? flags) => _$this._flags = flags;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _shortcode;
  String? get shortcode => _$this._shortcode;
  set shortcode(String? shortcode) => _$this._shortcode = shortcode;

  ExchangeNoPKBuilder() {
    ExchangeNoPK._defaults(this);
  }

  ExchangeNoPKBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _flags = $v.flags;
      _name = $v.name;
      _shortcode = $v.shortcode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExchangeNoPK other) {
    _$v = other as _$ExchangeNoPK;
  }

  @override
  void update(void Function(ExchangeNoPKBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExchangeNoPK build() => _build();

  _$ExchangeNoPK _build() {
    final _$result = _$v ??
        _$ExchangeNoPK._(
          flags: BuiltValueNullFieldError.checkNotNull(
              flags, r'ExchangeNoPK', 'flags'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'ExchangeNoPK', 'name'),
          shortcode: BuiltValueNullFieldError.checkNotNull(
              shortcode, r'ExchangeNoPK', 'shortcode'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
