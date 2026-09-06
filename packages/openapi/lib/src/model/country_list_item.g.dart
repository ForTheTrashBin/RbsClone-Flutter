// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_list_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CountryListItem extends CountryListItem {
  @override
  final String id;
  @override
  final String name;
  @override
  final String shortcode;

  factory _$CountryListItem([void Function(CountryListItemBuilder)? updates]) =>
      (CountryListItemBuilder()..update(updates))._build();

  _$CountryListItem._(
      {required this.id, required this.name, required this.shortcode})
      : super._();
  @override
  CountryListItem rebuild(void Function(CountryListItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CountryListItemBuilder toBuilder() => CountryListItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CountryListItem &&
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
    return (newBuiltValueToStringHelper(r'CountryListItem')
          ..add('id', id)
          ..add('name', name)
          ..add('shortcode', shortcode))
        .toString();
  }
}

class CountryListItemBuilder
    implements Builder<CountryListItem, CountryListItemBuilder> {
  _$CountryListItem? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _shortcode;
  String? get shortcode => _$this._shortcode;
  set shortcode(String? shortcode) => _$this._shortcode = shortcode;

  CountryListItemBuilder() {
    CountryListItem._defaults(this);
  }

  CountryListItemBuilder get _$this {
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
  void replace(CountryListItem other) {
    _$v = other as _$CountryListItem;
  }

  @override
  void update(void Function(CountryListItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CountryListItem build() => _build();

  _$CountryListItem _build() {
    final _$result = _$v ??
        _$CountryListItem._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'CountryListItem', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'CountryListItem', 'name'),
          shortcode: BuiltValueNullFieldError.checkNotNull(
              shortcode, r'CountryListItem', 'shortcode'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
