import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdbMob extends StatefulWidget {
  const BannerAdbMob({super.key});

  @override
  State<BannerAdbMob> createState() => _VBannerState();
}

class _VBannerState extends State<BannerAdbMob> {
  BannerAd? _bannerAd;

  final adUnitId = "ca-app-pub-5180834275746222/6779001073"; // Seu ID real

  // final adUnitId = "ca-app-pub-5180834275746222/7971470301"; // Seu ID real
  final adUnitIdTeste = "ca-app-pub-3940256099942544/6300978111"; // ID de teste

  @override
  void initState() {
    super.initState();
    // Não faça nada que dependa do context aqui!
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadAd(); // Move o loadAd() para o didChangeDependencies()
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _bannerAd?.size.width.toDouble() ?? 320,
      height: _bannerAd?.size.height.toDouble() ?? 50,
      child: _bannerAd != null ? AdWidget(ad: _bannerAd!) : const SizedBox(),
    );
  }

  void loadAd() {
    _bannerAd = BannerAd(
      adUnitId: adUnitId, // Use adUnitId em produção
      request: const AdRequest(),
      size: AdSize.mediumRectangle,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    )..load();
  }
}
