import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';

class AdvertService {
  static final AdvertService _instance = AdvertService._internal();
  factory AdvertService() => _instance;
  MobileAdTargetingInfo _targetingInfo;
  final String _bannerAd = Platform.isAndroid
      ? "ca-app-pub-3220996413641798/7364196570"
      : "ca-app-pub-3220996413641798/9415644841";

  final String _interstitialAd = Platform.isAndroid
      ? "ca-app-pub-3220996413641798/2966690521"
      : "ca-app-pub-3220996413641798/9627150411";

  AdvertService._internal() {
    _targetingInfo = MobileAdTargetingInfo();
  }

  showBanner() {
    BannerAd banner = BannerAd(
        adUnitId: _bannerAd,
        size: AdSize.smartBanner,
        targetingInfo: _targetingInfo);
    banner
      ..load()
      ..show(anchorOffset: 50);
    banner.dispose();
  }

  showIntersitial() {
    InterstitialAd interstitialAd = InterstitialAd(
        adUnitId: _interstitialAd, targetingInfo: _targetingInfo);
    interstitialAd
      ..load()
      ..show();
    interstitialAd.dispose();
  }
}
