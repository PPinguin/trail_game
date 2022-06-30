import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

const int maxFailedLoadAttempts = 3;

class AdManager {
  static const AdRequest request = AdRequest();

  static RewardedAd? _rewardedAd;
  static int _numRewardedLoadAttempts = 0;

  static void createRewardedAd() {
    if(_rewardedAd == null) {
      RewardedAd.load(
          adUnitId:
          Platform.isAndroid ? 'ca-app-pub-1147561809272433/6390335642' : '',
          request: request,
          rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (RewardedAd ad) {
              _rewardedAd = ad;
              _numRewardedLoadAttempts = 0;
            },
            onAdFailedToLoad: (LoadAdError error) {
              _rewardedAd = null;
              _numRewardedLoadAttempts += 1;
              if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
                createRewardedAd();
              }
            },
          ));
    }
  }

  static void showRewardedAd(
      {required Function reward, required Function failed}) {
    if (_rewardedAd == null) {
      failed();
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {},
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        failed();
        ad.dispose();
      },
      onAdImpression: (RewardedAd ad) {},
    );
    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem _) {
      reward();
    });
    _rewardedAd = null;
  }
}
