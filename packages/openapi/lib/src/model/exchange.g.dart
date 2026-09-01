// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Exchange extends Exchange {
  @override
  final int flags;
  @override
  final String id;
  @override
  final String name;
  @override
  final String shortcode;

  factory _$Exchange([void Function(ExchangeBuilder)? updates]) =>
      (ExchangeBuilder()..update(updates))._build();

  _$Exchange._(
      {required this.flags,
      required this.id,
      required this.name,
      required this.shortcode})
      : super._();
  @override
  Exchange rebuild(void Function(ExchangeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExchangeBuilder toBuilder() => ExchangeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Exchange &&
        flags == other.flags &&
        id == other.id &&
        name == other.name &&
        shortcode == other.shortcode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, flags.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, shortcode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Exchange')
          ..add('flags', flags)
          ..add('id', id)
          ..add('name', name)
          ..add('shortcode', shortcode))
        .toString();
  }
}

class ExchangeBuilder implements Builder<Exchange, ExchangeBuilder> {
  _$Exchange? _$v;

  int? _flags;
  int? get flags => _$this._flags;
  set flags(int? flags) => _$this._flags = flags;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _shortcode;
  String? get shortcode => _$this._shortcode;
  set shortcode(String? shortcode) => _$this._shortcode = shortcode;

  ExchangeBuilder() {
    Exchange._defaults(this);
  }

  ExchangeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _flags = $v.flags;
      _id = $v.id;
      _name = $v.name;
      _shortcode = $v.shortcode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Exchange other) {
    _$v = other as _$Exchange;
  }

  @override
  void update(void Function(ExchangeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Exchange build() => _build();

  _$Exchange _build() {
    final _$result = _$v ??
        _$Exchange._(
          flags: BuiltValueNullFieldError.checkNotNull(
              flags, r'Exchange', 'flags'),
          id: BuiltValueNullFieldError.checkNotNull(id, r'Exchange', 'id'),
          name:
              BuiltValueNullFieldError.checkNotNull(name, r'Exchange', 'name'),
          shortcode: BuiltValueNullFieldError.checkNotNull(
              shortcode, r'Exchange', 'shortcode'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
