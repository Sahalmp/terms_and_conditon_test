import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//provider import
import '../Provider/termsProvider.dart';

//model import
import '../model/terms_and_condition/terms_and_condition.dart';

//mlkit import
import '../service/ml_kit_service.dart';

//widget imports
import 'widgets/bottomsheet.dart';
import 'widgets/customcard.dart';

class TermsAndConditionPage extends ConsumerStatefulWidget {
  const TermsAndConditionPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TermsAndConditionPageState();
}

class _TermsAndConditionPageState extends ConsumerState<TermsAndConditionPage> {
  final MlkitService mlkitService = MlkitService();

  final ScrollController _scrollController = ScrollController();

  int _offset = 10; // Initial offset
  final int _limit = 10; // Number of items to load

  @override
  void initState() {
    _scrollController.addListener(() {
      print("scrolllistener");

      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 60) {
        print("scrollcontroller");
        _loadMoreData();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final termsList = ref.watch(termsProvider);

    final hindiSelectedList = ref.watch(hindiLanguageTermsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms and Conditions"),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = termsList[index];
                    return TermsAndConditionCard(
                      item: item,
                      hindiSelectedList: hindiSelectedList,
                      termsList: termsList,
                      mlkitService: mlkitService,
                      index: index,
                    );
                  },
                  itemCount: termsList.length),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          showAddMoreBottomSheet(context, ref);
                        },
                        child: const Text("Add More")),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _loadMoreData() {
    final termsList = ref.watch(termsProvider);

    final List<TermsAndConditionsModel> moreTerms =
        getTermsFromStorage(_offset, _limit);
    if (moreTerms.isNotEmpty) {
      ref.read(termsProvider.notifier).addMoreTerms(termsList, moreTerms);
      _offset += _limit;
      print(_offset);
    }
  }
}
