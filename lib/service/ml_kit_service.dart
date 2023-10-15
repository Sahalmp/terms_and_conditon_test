import 'package:google_ml_kit/google_ml_kit.dart';

class MlkitService {
  final onDeviceTranslator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.english,
      targetLanguage: TranslateLanguage.hindi);

  setup() async {
    final modelManager = OnDeviceTranslatorModelManager();
    final bool response = await modelManager
        .downloadModel(TranslateLanguage.hindi.bcpCode, isWifiRequired: false);
    print("response: $response");
    return response;
  }

  Future<String> translateText(text) async {
    return await onDeviceTranslator.translateText(text);
  }
}
