// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ArticleStore on _ArticleStore, Store {
  final _$listAtom = Atom(name: '_ArticleStore.list');

  @override
  List<Article> get list {
    _$listAtom.reportRead();
    return super.list;
  }

  @override
  set list(List<Article> value) {
    _$listAtom.reportWrite(value, super.list, () {
      super.list = value;
    });
  }

  final _$currentArticleAtom = Atom(name: '_ArticleStore.currentArticle');

  @override
  Article get currentArticle {
    _$currentArticleAtom.reportRead();
    return super.currentArticle;
  }

  @override
  set currentArticle(Article value) {
    _$currentArticleAtom.reportWrite(value, super.currentArticle, () {
      super.currentArticle = value;
    });
  }

  final _$prevArticleAtom = Atom(name: '_ArticleStore.prevArticle');

  @override
  Article get prevArticle {
    _$prevArticleAtom.reportRead();
    return super.prevArticle;
  }

  @override
  set prevArticle(Article value) {
    _$prevArticleAtom.reportWrite(value, super.prevArticle, () {
      super.prevArticle = value;
    });
  }

  final _$nextArticleAtom = Atom(name: '_ArticleStore.nextArticle');

  @override
  Article get nextArticle {
    _$nextArticleAtom.reportRead();
    return super.nextArticle;
  }

  @override
  set nextArticle(Article value) {
    _$nextArticleAtom.reportWrite(value, super.nextArticle, () {
      super.nextArticle = value;
    });
  }

  final _$getArticleAllInfoAsyncAction =
      AsyncAction('_ArticleStore.getArticleAllInfo');

  @override
  Future getArticleAllInfo(Novel novel) {
    return _$getArticleAllInfoAsyncAction
        .run(() => super.getArticleAllInfo(novel));
  }

  @override
  String toString() {
    return '''
list: ${list},
currentArticle: ${currentArticle},
prevArticle: ${prevArticle},
nextArticle: ${nextArticle}
    ''';
  }
}
