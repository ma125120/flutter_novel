// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ArticleStore on _ArticleStore, Store {
  final _$listAtom = Atom(name: '_ArticleStore.list');

  @override
  List<Article> get list {
    _$listAtom.context.enforceReadPolicy(_$listAtom);
    _$listAtom.reportObserved();
    return super.list;
  }

  @override
  set list(List<Article> value) {
    _$listAtom.context.conditionallyRunInAction(() {
      super.list = value;
      _$listAtom.reportChanged();
    }, _$listAtom, name: '${_$listAtom.name}_set');
  }

  final _$currentArticleAtom = Atom(name: '_ArticleStore.currentArticle');

  @override
  Article get currentArticle {
    _$currentArticleAtom.context.enforceReadPolicy(_$currentArticleAtom);
    _$currentArticleAtom.reportObserved();
    return super.currentArticle;
  }

  @override
  set currentArticle(Article value) {
    _$currentArticleAtom.context.conditionallyRunInAction(() {
      super.currentArticle = value;
      _$currentArticleAtom.reportChanged();
    }, _$currentArticleAtom, name: '${_$currentArticleAtom.name}_set');
  }

  final _$prevArticleAtom = Atom(name: '_ArticleStore.prevArticle');

  @override
  Article get prevArticle {
    _$prevArticleAtom.context.enforceReadPolicy(_$prevArticleAtom);
    _$prevArticleAtom.reportObserved();
    return super.prevArticle;
  }

  @override
  set prevArticle(Article value) {
    _$prevArticleAtom.context.conditionallyRunInAction(() {
      super.prevArticle = value;
      _$prevArticleAtom.reportChanged();
    }, _$prevArticleAtom, name: '${_$prevArticleAtom.name}_set');
  }

  final _$nextArticleAtom = Atom(name: '_ArticleStore.nextArticle');

  @override
  Article get nextArticle {
    _$nextArticleAtom.context.enforceReadPolicy(_$nextArticleAtom);
    _$nextArticleAtom.reportObserved();
    return super.nextArticle;
  }

  @override
  set nextArticle(Article value) {
    _$nextArticleAtom.context.conditionallyRunInAction(() {
      super.nextArticle = value;
      _$nextArticleAtom.reportChanged();
    }, _$nextArticleAtom, name: '${_$nextArticleAtom.name}_set');
  }

  final _$getArticleAllInfoAsyncAction = AsyncAction('getArticleAllInfo');

  @override
  Future getArticleAllInfo(Novel novel) {
    return _$getArticleAllInfoAsyncAction
        .run(() => super.getArticleAllInfo(novel));
  }

  @override
  String toString() {
    final string =
        'list: ${list.toString()},currentArticle: ${currentArticle.toString()},prevArticle: ${prevArticle.toString()},nextArticle: ${nextArticle.toString()}';
    return '{$string}';
  }
}
