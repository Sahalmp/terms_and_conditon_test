import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Provider/termsprovider.dart';
import '../../model/terms_and_condition/terms_and_condition.dart';
import '../../service/ml_kit_service.dart';
import 'bottomsheet.dart';
import 'buttonanimation.dart';
import 'rightalignedbutton.dart';

class TermsAndConditionCard extends ConsumerWidget {
  const TermsAndConditionCard(
      {super.key,
      required this.item,
      required this.hindiSelectedList,
      required this.termsList,
      required this.mlkitService,
      required this.index});

  final TermsAndConditionsModel item;
  final int index;
  final List<int> hindiSelectedList;
  final List<TermsAndConditionsModel> termsList;
  final MlkitService mlkitService;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ButtonAnimation(
      onpress: () => showAddMoreBottomSheet(context, ref, item),
      animationWidget: Card(
          color: const Color.fromARGB(255, 229, 231, 246),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.value,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    hindiSelectedList.contains(item.id)
                        ? Text(
                            termsList[index].translatedHindiText,
                            style: const TextStyle(color: Colors.indigo),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
              hindiSelectedList.contains(item.id)
                  ? const SizedBox()
                  : RightAlignedTextButton(
                      title: "Read in Hindi",
                      onPressed: () async {
                        final data =
                            await mlkitService.translateText(item.value);
                        ref
                            .read(termsProvider.notifier)
                            .addHindiTerms(data, item.id);
                        ref
                            .read(hindiLanguageTermsProvider.notifier)
                            .addHindiTermsid(item.id);
                      },
                    )
            ],
          )),
    );
  }
}
