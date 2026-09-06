// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_list_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ExchangeListItem extends ExchangeListItem {
  @override
  final String id;
  @override
  final String name;
  @override
  final String shortcode;

  factory _$ExchangeListItem(
          [void Function(ExchangeListItemBuilder)? updates]) =>
      (ExchangeListItemBuilder()..update(updates))._build();

  _$ExchangeListItem._(
      {required this.id, required this.name, required this.shortcode})
      : super._();
  @override
  ExchangeListItem rebuild(void Function(ExchangeListItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExchangeListItemBuilder toBuilder() =>
      ExchangeListItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExchangeListItem &&
        id == other.id &&
        name == other.name &&
        shortcode == other.shortcode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, shortcode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ExchangeListItem')
          ..add('id', id)
          ..add('name', name)
          ..add('shortcode', shortcode))
        .toString();
  }
}

class ExchangeListItemBuilder
    implements Builder<ExchangeListItem, ExchangeListItemBuilder> {
  _$ExchangeListItem? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _shortcode;
  String? get shortcode => _$this._shortcode;
  set shortcode(String? shortcode) => _$this._shortcode = shortcode;

  ExchangeListItemBuilder() {
    ExchangeListItem._defaults(this);
  }

  ExchangeListItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _shortcode = $v.shortcode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExchangeListItem other) {
    _$v = other as _$ExchangeListItem;
  }

  @override
  void update(void Function(ExchangeListItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExchangeListItem build() => _build();

  _$ExchangeListItem _build() {
    final _$result = _$v ??
        _$ExchangeListItem._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ExchangeListItem', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'ExchangeListItem', 'name'),
          shortcode: BuiltValueNullFieldError.checkNotNull(
              shortcode, r'ExchangeListItem', 'shortcode'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
