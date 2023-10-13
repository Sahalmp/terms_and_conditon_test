import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

final speechProvider = Provider<stt.SpeechToText>((ref) {
  return stt.SpeechToText();
});

final textEditingControllerProvider =
    StateProvider<TextEditingController>((ref) => TextEditingController());

final StateProvider<bool> isListeningProvider = StateProvider<bool>((ref) {
  return false;
});

final StateProvider<String> hindiTermsProvider = StateProvider<String>((ref) {
  return "";
});
final StateProvider<bool> isHindiButtonClickedProvider = StateProvider<bool>((ref) {
  return false;
});
