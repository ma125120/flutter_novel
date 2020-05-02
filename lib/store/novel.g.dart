// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$NovelStore on _NovelStore, Store {
  final _$listAtom = Atom(name: '_NovelStore.list');

  @override
  List<Novel> get list {
    _$listAtom.context.enforceReadPolicy(_$listAtom);
    _$listAtom.reportObserved();
    return super.list;
  }

  @override
  set list(List<Novel> value) {
    _$listAtom.context.conditionallyRunInAction(() {
      super.list = value;
      _$listAtom.reportChanged();
    }, _$listAtom, name: '${_$listAtom.name}_set');
  }

  final _$getShelfAsyncAction = AsyncAction('getShelf');

  @override
  Future getShelf([bool needUpdate = false]) {
    return _$getShelfAsyncAction.run(() => super.getShelf(needUpdate));
  }

  final _$deleteAsyncAction = AsyncAction('delete');

  @override
  Future delete(String id, int idx) {
    return _$deleteAsyncAction.run(() => super.delete(id, idx));
  }

  final _$_NovelStoreActionController = ActionController(name: '_NovelStore');

  @override
  dynamic destory() {
    final _$actionInfo = _$_NovelStoreActionController.startAction();
    try {
      return super.destory();
    } finally {
      _$_NovelStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string = 'list: ${list.toString()}';
    return '{$string}';
  }
}
