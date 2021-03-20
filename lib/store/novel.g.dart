// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$NovelStore on _NovelStore, Store {
  final _$listAtom = Atom(name: '_NovelStore.list');

  @override
  List<Novel> get list {
    _$listAtom.reportRead();
    return super.list;
  }

  @override
  set list(List<Novel> value) {
    _$listAtom.reportWrite(value, super.list, () {
      super.list = value;
    });
  }

  final _$getShelfAsyncAction = AsyncAction('_NovelStore.getShelf');

  @override
  Future getShelf([bool needUpdate = false]) {
    return _$getShelfAsyncAction.run(() => super.getShelf(needUpdate));
  }

  final _$deleteAsyncAction = AsyncAction('_NovelStore.delete');

  @override
  Future delete(String id, int idx) {
    return _$deleteAsyncAction.run(() => super.delete(id, idx));
  }

  final _$_NovelStoreActionController = ActionController(name: '_NovelStore');

  @override
  dynamic destory() {
    final _$actionInfo =
        _$_NovelStoreActionController.startAction(name: '_NovelStore.destory');
    try {
      return super.destory();
    } finally {
      _$_NovelStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
list: ${list}
    ''';
  }
}
