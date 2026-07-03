import 'package:flutter/material.dart';

class PtsSocialSituationNotifier extends ChangeNotifier {
  String? _socialSituation;
  String? get socialSituation => _socialSituation;

  static final instance = PtsSocialSituationNotifier();

  void updateSocialSituation(String? socialSituation) {
    _socialSituation = socialSituation;
    notifyListeners();
  }
}
