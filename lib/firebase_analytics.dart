// ignore_for_file: constant_identifier_names

import 'package:firebase_analytics/firebase_analytics.dart';

///
/// 対象画面一覧
///
enum AnalyticsScreenId {
  SPLASH_START('スプラッシュ画面', eventName: 'splash_start'),
  SPLASH_END('スプラッシュ画面', eventName: 'splash_end'),
  HOME('ホーム画面'),
  FEATURE('特集画面'),
  FEATURE_DETAIL('特集詳細画面'),
  FEATURE_DETAIL_WEB('特集詳細画面（Web）'),
  FEATURE_DETAIL_WEB_ERROR('特集詳細画面（Web）エラー'),
  ;

  const AnalyticsScreenId(this.screenName, {this.eventName = ''});

  final String screenName;
  final String eventName;
}

///
/// ボタン種別一覧
///
enum AnalyticsButtonName {
  signUp('新規登録'),
  login('ログイン'),
  logout('ログアウト'),
  search('検索'),
  favoriteAdd('お気に入り追加'),
  favoriteRemove('お気に入り削除'),
  navigator('画面遷移'),
  create('作成'),
  edit('編集'),
  delete('削除'),
  share('シェア'),
  ;

  const AnalyticsButtonName(this.rawValue);

  final String rawValue;
}

///
/// firebaseにイベントを送信するためのクラス
///
class AnalyticsManager {
  factory AnalyticsManager() {
    return _manager;
  }
  AnalyticsManager._internal();
  static final AnalyticsManager _manager = AnalyticsManager._internal();
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // カスタムパラメータのキー名称
  static const String screenIdKey = '画面ID';
  static const String screenTitleKey = '画面タイトル';
  static const String urlKey = '遷移先URL';
  static const String contentsIdKey = 'コンテンツID';
  static const String userIdKey = 'userId';
  static const String categoryKey = 'カテゴリ名';
  static const String loginKey = 'ログインステータス';

  ///
  /// Firebaseにイベント送信するメソッド。sendScreenEventおよびsendButtonEventからのみ呼び出される
  ///
  /// [name] firebaseに通知するイベント名を指定。
  ///
  /// [screenId] 表示した画面IDもしくは押下したボタンが設置されている画面の画面IDを、enum型AnalyticsScreenIdに定義された画面IDから指定する
  ///
  /// [type] 押下したボタンの詳細を指定する（ログイン利用の有無、カテゴリ名、感情種別　など）
  ///
  /// [url] ディープリンクURLが存在する場合は、その値を指定する
  ///
  /// [contentsId] 表示した画面もしくは押下したボタンが特定コンテンツである場合、コンテンツIDを指定する
  ///
  /// return:なし
  ///
  void sendEvent({
    required String name,
    AnalyticsScreenId? screenId,
    String? type,
    String? url,
    String? contentsId,
  }) {
    final param = <String, dynamic>{};

    // 画面IDを画面タイトルにマッピングし、mapへ格納する
    if (screenId != null) {
      param[screenIdKey] = screenId.name;
      param[screenTitleKey] = screenId.screenName;
    }

    // url・contentsIdをマッピングし、mapへの格納する
    if (url?.isNotEmpty == true) {
      param[urlKey] = url;
    }
    if (contentsId?.isNotEmpty == true) {
      param[contentsIdKey] = contentsId;
    }

    if (type?.isNotEmpty == true) {
      param[categoryKey] = type;
    }

    _analytics.logEvent(name: name, parameters: param);
  }

  ///
  /// 画面表示イベントを、firebaseに通知するメソッド
  ///
  /// [screenId] 表示した画面IDを、enum型AnalyticsScreenIdに定義された画面IDから指定する
  ///
  /// [contentsId] 表示した画面が特定コンテンツのページの場合、コンテンツIDを指定する
  ///
  /// return:なし
  ///
  void sendScreenEvent({
    required AnalyticsScreenId screenId,
    String? contentsId,
  }) {
    // 画面表示イベント
    if (screenId.eventName.isNotEmpty) {
      sendEvent(name: screenId.eventName);
    }
    // 画面表示イベント
    sendEvent(
      name: screenId.eventName.isNotEmpty ? screenId.eventName : 'screen_view',
      screenId: screenId,
      contentsId: contentsId,
    );
  }

  ///
  /// ボタン押下イベントを、firebaseに通知するメソッド
  ///
  /// [screenId] 押下したボタンが設置されている画面の画面IDを、enum型AnalyticsScreenIdに定義された画面IDから指定する
  ///
  /// [buttonName] 押下したボタン名を、enum型AnalyticsButtonNameに定義されたボタン名から指定する
  ///
  /// [type] 押下したボタンの詳細を指定する（ログイン利用の有無、カテゴリ名、感情種別　など）
  ///
  /// [url] ディープリンクURLが存在する場合は、その値を指定する
  ///
  /// [contentsId] 押下したボタンが特定コンテンツである場合、コンテンツIDを指定する
  ///
  /// return:なし
  ///
  void sendButtonEvent({
    required AnalyticsScreenId screenId,
    required AnalyticsButtonName buttonName,
    String? type,
    String? url,
    String? contentsId,
  }) {
    // ボタン押下イベント
    sendEvent(
      name: buttonName.rawValue,
      screenId: screenId,
      type: type,
      url: url,
      contentsId: contentsId,
    );
  }

  ///
  /// ログイン成功時に、firebaseにユーザ情報をセットするメソッド
  ///
  /// [uniqId] ログインユーザーのIDを指定する
  ///
  /// return:なし
  ///
  void setUserInfo(
    String userId,
  ) {
    _analytics.setUserId(id: userId);
  }

  ///
  /// ログアウト成功時に、firebaseのユーザ情報をリセットするメソッド
  ///
  /// 引数なし
  ///
  /// return:なし
  ///
  void resetUserInfo() {
    _analytics.setUserId(id: '');
    _analytics.resetAnalyticsData();
  }
}
