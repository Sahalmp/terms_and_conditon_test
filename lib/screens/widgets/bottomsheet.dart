import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Provider/speechtextprovider.dart';
import '../../model/terms_and_condition/terms_and_condition.dart';
import '../terms_and_condition_page.dart';
import 'addeditwidget.dart';

Future<Widget?> showAddMoreBottomSheet(BuildContext context, WidgetRef ref,
    [TermsAndConditionsModel? term]) async {
  ref.read(isListeningProvider.notifier).state = false;
  ref.read(textEditingControllerProvider.notifier).state =
      TextEditingController();
  ref.read(hindiTermsProvider.notifier).state = "";
  ref.read(isHindiButtonClickedProvider.notifier).state = false;

  await showModalBottomSheet<Widget>(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AddEditWidget(
            term: term,
          ),
        ),
      );
    },
  );
  return null;
}
