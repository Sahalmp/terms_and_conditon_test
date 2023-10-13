import 'package:google_ml_kit/google_ml_kit.dart';

class MlkitService {
  final onDeviceTranslator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.english,
      targetLanguage: TranslateLanguage.hindi);

  Future<String> translateText(text) async {
    return await onDeviceTranslator.translateText(text);
  }
}
