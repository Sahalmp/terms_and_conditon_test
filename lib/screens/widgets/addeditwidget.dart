import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../Provider/speechtextprovider.dart';
import '../../Provider/termsprovider.dart';
import '../../model/terms_and_condition/terms_and_condition.dart';
import '../../service/ml_kit_service.dart';
import 'micanimation.dart';
import 'rightalignedbutton.dart';

final _formKey = GlobalKey<FormState>();

// ignore: must_be_immutable
class AddEditWidget extends ConsumerWidget {
  final TermsAndConditionsModel? term;

  final MlkitService mlkitService = MlkitService();

  AddEditWidget({this.term, super.key});
  late TextEditingController textEditingController;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    textEditingController = ref.watch(textEditingControllerProvider);

    final TermsNotifier termsNotifier = ref.watch(termsProvider.notifier);
    bool isListening = ref.watch(isListeningProvider);

    String hindiText = ref.watch(hindiTermsProvider);
    bool isHindiButtonClicked = ref.watch(isHindiButtonClickedProvider);
    if (term != null) {
      textEditingController.text = term!.value;
    }

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAddEditHeading(context),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        autofocus: true,
                        controller: textEditingController,
                        minLines: 2,
                        onChanged: (value) {
                          if (isHindiButtonClicked) {
                            gethindiText(ref, textEditingController);
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Terms and conditions cannot be empty';
                          }
                          return null;
                        },
                        maxLines: 8,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: isListening ? "....listening" : "Type here",
                          hintTextDirection: isListening
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          suffixIcon: IconButton(
                            icon: isListening
                                ? const MicAnimation()
                                : const Icon(Icons.mic),
                            onPressed: () async {
                              stt.SpeechToText speech = stt.SpeechToText();
                              ref.read(isListeningProvider.notifier).state =
                                  true;
                              if (!isListening) {
                                isListening = true;
                                await startListening(
                                    textEditingController, speech, ref);
                              } else {
                                ref.read(isListeningProvider.notifier).state =
                                    false;
                                await speech.stop();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 3,
                ),
                !isHindiButtonClicked
                    ? RightAlignedTextButton(
                        onPressed: () =>
                            gethindiText(ref, textEditingController),
                        title: "View in Hindi",
                      )
                    : Row(
                        children: [
                          Flexible(child: Text(hindiText)),
                        ],
                      ),
              ],
            ),
          ),
          _buildConfirmButton(isListening, termsNotifier, context),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  Padding _buildConfirmButton(
      bool isListening, TermsNotifier termsNotifier, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 45,
              child: ElevatedButton(
                onPressed: isListening
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          TermsAndConditionsModel? updatedTerm;

                          if (term != null) {
                            updatedTerm = TermsAndConditionsModel(
                              id: term!.id,
                              value: textEditingController.text,
                              createdAt: term!.createdAt,
                            );
                          }

                          final newTerm = TermsAndConditionsModel(
                            value: textEditingController.text,
                          );
                          termsNotifier.addUpdateTerms(updatedTerm ?? newTerm);

                          Navigator.pop(context);
                        }
                      },
                child: const Text("Confirm"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ListTile _buildAddEditHeading(BuildContext context) {
    return ListTile(
        minLeadingWidth: 0,
        title: Text(
          "${term == null ? "Add" : "Edit"} Terms and Conditions",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ));
  }

  Future<void> startListening(
      TextEditingController controller, stt.SpeechToText speech, ref) async {
    bool available = await speech.initialize(
      onStatus: (status) {
        if (status == "notListening") {
          ref.read(isListeningProvider.notifier).state = false;
        }
      },
    );
    if (available) {
      speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            TextSelection cursorPosition = controller.selection;
            int cursorOffset = cursorPosition.baseOffset;

            if (cursorOffset > 0) {
              controller.text += " ${result.recognizedWords}";
            } else {
              controller.text = result.recognizedWords;
            }
          }
        },
      );
    }
  }

  void gethindiText(
      WidgetRef ref, TextEditingController textEditingController) async {
    if (_formKey.currentState!.validate()) {
      ref.read(isHindiButtonClickedProvider.notifier).state = true;

      final hindiTranslation =
          await mlkitService.translateText(textEditingController.text);
      ref.read(hindiTermsProvider.notifier).state = hindiTranslation;
    }
  }
}
