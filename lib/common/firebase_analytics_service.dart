import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class FirebaseAnalyticsService {
  // String _message = '';

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  // FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(
  //   analytics: _analytics,
  // );

  FirebaseAnalyticsObserver initAnalytics() {
    return FirebaseAnalyticsObserver(
      analytics: analytics,
    );
  }

  void setMessage(String message) {
    // setState(() {
    //   _message = message;
    // });
    debugPrint('message $message');
  }

  Future<void> setDefaultEventParameters() async {
    if (kIsWeb) {
      setMessage(
        '"setDefaultEventParameters()" is not supported on web platform',
      );
    } else {
      // Only strings, numbers & null (longs & doubles for android, ints and doubles for iOS) are supported for default event parameters:
      await analytics.setDefaultEventParameters(<String, dynamic>{
        'string': 'string',
        'int': 42,
        'long': 12345678910,
        'double': 42.0,
        'bool': true.toString(),
      });
      setMessage('setDefaultEventParameters succeeded');
    }
  }

  Future<void> sendAnalyticsEvent(String event, Map<String, dynamic> data) async {
    // Only strings and numbers (longs & doubles for android, ints and doubles for iOS) are supported for GA custom event parameters:
    // https://firebase.google.com/docs/reference/ios/firebaseanalytics/api/reference/Classes/FIRAnalytics#+logeventwithname:parameters:
    // https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics#public-void-logevent-string-name,-bundle-params
    await analytics.logEvent(
      // name: event,
      // parameters: data,
      name: event,
      parameters: <String, dynamic>{
        'data': data.toString(),
      },
      // name: 'test_event',
      // parameters: <String, dynamic>{
      //   'string': 'string',
      //   'int': 42,
      //   'long': 12345678910,
      //   'double': 42.0,
      //   // Only strings and numbers (ints & doubles) are supported for GA custom event parameters:
      //   // https://developers.google.com/analytics/devguides/collection/analyticsjs/custom-dims-mets#overview
      //   'bool': true.toString(),
      // },
    );

    setMessage('logEvent succeeded');
  }

  Future<void> testSetUserId() async {
    await analytics.setUserId(id: 'some-user');
    setMessage('setUserId succeeded');
  }

  Future<void> testSetCurrentScreen() async {
    await analytics.setCurrentScreen(
      screenName: 'Analytics Demo',
      screenClassOverride: 'AnalyticsDemo',
    );
    setMessage('setCurrentScreen succeeded');
  }

  Future<void> testSetAnalyticsCollectionEnabled() async {
    await analytics.setAnalyticsCollectionEnabled(false);
    await analytics.setAnalyticsCollectionEnabled(true);
    setMessage('setAnalyticsCollectionEnabled succeeded');
  }

  Future<void> testSetSessionTimeoutDuration() async {
    await analytics.setSessionTimeoutDuration(const Duration(milliseconds: 20000));
    setMessage('setSessionTimeoutDuration succeeded');
  }

  Future<void> testSetUserProperty() async {
    await analytics.setUserProperty(name: 'regular', value: 'indeed');
    setMessage('setUserProperty succeeded');
  }

  Future<void> testAppInstanceId() async {
    String? id = await analytics.appInstanceId;
    if (id != null) {
      setMessage('appInstanceId succeeded: $id');
    } else {
      setMessage('appInstanceId failed, consent declined');
    }
  }

  Future<void> testResetAnalyticsData() async {
    await analytics.resetAnalyticsData();
    setMessage('resetAnalyticsData succeeded');
  }

  AnalyticsEventItem itemCreator() {
    return AnalyticsEventItem(
      affiliation: 'affil',
      coupon: 'coup',
      creativeName: 'creativeName',
      creativeSlot: 'creativeSlot',
      discount: 2.22,
      index: 3,
      itemBrand: 'itemBrand',
      itemCategory: 'itemCategory',
      itemCategory2: 'itemCategory2',
      itemCategory3: 'itemCategory3',
      itemCategory4: 'itemCategory4',
      itemCategory5: 'itemCategory5',
      itemId: 'itemId',
      itemListId: 'itemListId',
      itemListName: 'itemListName',
      itemName: 'itemName',
      itemVariant: 'itemVariant',
      locationId: 'locationId',
      price: 9.99,
      currency: 'USD',
      promotionId: 'promotionId',
      promotionName: 'promotionName',
      quantity: 1,
    );
  }

  Future<void> testAllEventTypes() async {
    await analytics.logAddPaymentInfo();
    await analytics.logAddToCart(
      currency: 'USD',
      value: 123,
      items: [itemCreator(), itemCreator()],
    );
    await analytics.logAddToWishlist();
    await analytics.logAppOpen();
    await analytics.logBeginCheckout(
      value: 123,
      currency: 'USD',
      items: [itemCreator(), itemCreator()],
    );
    await analytics.logCampaignDetails(
      source: 'source',
      medium: 'medium',
      campaign: 'campaign',
      term: 'term',
      content: 'content',
      aclid: 'aclid',
      cp1: 'cp1',
    );
    await analytics.logEarnVirtualCurrency(
      virtualCurrencyName: 'bitcoin',
      value: 345.66,
    );

    await analytics.logGenerateLead(
      currency: 'USD',
      value: 123.45,
    );
    await analytics.logJoinGroup(
      groupId: 'test group id',
    );
    await analytics.logLevelUp(
      level: 5,
      character: 'witch doctor',
    );
    await analytics.logLogin(loginMethod: 'login');
    await analytics.logPostScore(
      score: 1000000,
      level: 70,
      character: 'tiefling cleric',
    );
    await analytics.logPurchase(currency: 'USD', transactionId: 'transaction-id');
    await analytics.logSearch(
      searchTerm: 'hotel',
      numberOfNights: 2,
      numberOfRooms: 1,
      numberOfPassengers: 3,
      origin: 'test origin',
      destination: 'test destination',
      startDate: '2015-09-14',
      endDate: '2015-09-16',
      travelClass: 'test travel class',
    );
    await analytics.logSelectContent(
      contentType: 'test content type',
      itemId: 'test item id',
    );
    await analytics.logSelectPromotion(
      creativeName: 'promotion name',
      creativeSlot: 'promotion slot',
      items: [itemCreator()],
      locationId: 'United States',
    );
    await analytics.logSelectItem(
      items: [itemCreator(), itemCreator()],
      itemListName: 't-shirt',
      itemListId: '1234',
    );
    await analytics.logScreenView(
      screenName: 'tabs-page',
    );
    await analytics.logViewCart(
      currency: 'USD',
      value: 123,
      items: [itemCreator(), itemCreator()],
    );
    await analytics.logShare(
      contentType: 'test content type',
      itemId: 'test item id',
      method: 'facebook',
    );
    await analytics.logSignUp(
      signUpMethod: 'test sign up method',
    );
    await analytics.logSpendVirtualCurrency(
      itemName: 'test item name',
      virtualCurrencyName: 'bitcoin',
      value: 34,
    );
    await analytics.logViewPromotion(
      creativeName: 'promotion name',
      creativeSlot: 'promotion slot',
      items: [itemCreator()],
      locationId: 'United States',
      promotionId: '1234',
      promotionName: 'big sale',
    );
    await analytics.logRefund(
      currency: 'USD',
      value: 123,
      items: [itemCreator(), itemCreator()],
    );
    await analytics.logTutorialBegin();
    await analytics.logTutorialComplete();
    await analytics.logUnlockAchievement(id: 'all Firebase API covered');
    await analytics.logViewItem(
      currency: 'usd',
      value: 1000,
      items: [itemCreator()],
    );
    await analytics.logViewItemList(
      itemListId: 't-shirt-4321',
      itemListName: 'green t-shirt',
      items: [itemCreator()],
    );
    await analytics.logViewSearchResults(
      searchTerm: 'test search term',
    );
    setMessage('All standard events logged successfully');
  }
}
