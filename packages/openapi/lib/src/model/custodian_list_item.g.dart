// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custodian_list_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustodianListItem extends CustodianListItem {
  @override
  final String id;
  @override
  final String name;
  @override
  final String shortcode;

  factory _$CustodianListItem(
          [void Function(CustodianListItemBuilder)? updates]) =>
      (CustodianListItemBuilder()..update(updates))._build();

  _$CustodianListItem._(
      {required this.id, required this.name, required this.shortcode})
      : super._();
  @override
  CustodianListItem rebuild(void Function(CustodianListItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CustodianListItemBuilder toBuilder() =>
      CustodianListItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustodianListItem &&
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
    return (newBuiltValueToStringHelper(r'CustodianListItem')
          ..add('id', id)
          ..add('name', name)
          ..add('shortcode', shortcode))
        .toString();
  }
}

class CustodianListItemBuilder
    implements Builder<CustodianListItem, CustodianListItemBuilder> {
  _$CustodianListItem? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _shortcode;
  String? get shortcode => _$this._shortcode;
  set shortcode(String? shortcode) => _$this._shortcode = shortcode;

  CustodianListItemBuilder() {
    CustodianListItem._defaults(this);
  }

  CustodianListItemBuilder get _$this {
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
  void replace(CustodianListItem other) {
    _$v = other as _$CustodianListItem;
  }

  @override
  void update(void Function(CustodianListItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustodianListItem build() => _build();

  _$CustodianListItem _build() {
    final _$result = _$v ??
        _$CustodianListItem._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'CustodianListItem', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'CustodianListItem', 'name'),
          shortcode: BuiltValueNullFieldError.checkNotNull(
              shortcode, r'CustodianListItem', 'shortcode'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
