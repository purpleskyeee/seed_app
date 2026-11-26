import 'package:flutter/material.dart';

ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

ValueNotifier<bool> lightModeNotifier = ValueNotifier(true);

void resetNotifiers() {
  selectedIndexNotifier.value = 0;
  lightModeNotifier.value = true;
}