import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//provider import
import '../Provider/termsprovider.dart';

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

  int _offset = 0;
  final int _limit = 10;

  @override
  void initState() {
    getdata();
    getmlkitdata();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 60) {
        _loadMoreData();
      }
    });
    super.initState();
  }

  getdata() {
    Future.delayed(Duration.zero, () {
      final data = getTermsFromStorage(_offset, _limit);
      ref.read(termsProvider.notifier).getTerms(data);
    });
  }

  getmlkitdata() async {
    final response = await mlkitService.setup();
    if (response.runtimeType == bool) {
      ref.read(isDownloadedProvider.notifier).state = response;
    }
  }

  @override
  Widget build(BuildContext context) {
    final termsList = ref.watch(termsProvider);
    final isDownloaded = ref.watch(isDownloadedProvider);

    final hindiSelectedList = ref.watch(hindiLanguageTermsProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Terms and Conditions"),
          bottom: isDownloaded
              ? null
              : PreferredSize(
                  preferredSize: const Size.fromHeight(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(2),
                            color: Colors.black,
                            child: const Text(
                              "Downloading hindi model. please wait !!!!, \nIt can take up to 2 min",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            )),
                      ),
                    ],
                  )),
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildListTermsandConditions(termsList, hindiSelectedList),
                const SizedBox(
                  height: 10,
                ),
                _buildAddMoreButton(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListView _buildListTermsandConditions(
      List<TermsAndConditionsModel> termsList, List<int> hindiSelectedList) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          if (termsList.isEmpty) {
            getTermsFromStorage(0, 10);
          }
          final item = termsList[index];
          return TermsAndConditionCard(
            item: item,
            hindiSelectedList: hindiSelectedList,
            termsList: termsList,
            mlkitService: mlkitService,
            index: index,
          );
        },
        itemCount: termsList.length);
  }

  Row _buildAddMoreButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
              onPressed: () async {
                await showAddMoreBottomSheet(context, ref);
              },
              child: const Text("Add More")),
        ),
      ],
    );
  }

  void _loadMoreData() {
    final termsList = ref.read(termsProvider);
    _offset += _limit;
    final List<TermsAndConditionsModel> moreTerms =
        getTermsFromStorage(_offset, _limit);
    if (moreTerms.isNotEmpty) {
      ref.read(termsProvider.notifier).addMoreTerms(termsList, moreTerms);
      _offset += _limit;
    }
  }
}
