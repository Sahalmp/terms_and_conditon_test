import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pidilite_assignment/content/terms.dart';
import '../model/terms_and_condition/terms_and_condition.dart';

getTermsFromStorage(int offset, int limit) {
  GetStorage box = GetStorage();
  final List<dynamic>? storedData = box.read<List<dynamic>>("terms");
  if (storedData != null) {
    final List<TermsAndConditionsModel> storedTermsData = storedData
        .map((dynamic item) => TermsAndConditionsModel.fromJson(item))
        .toList();
    return storedTermsData.skip(offset).take(limit).toList();
  } else {
    return termsData;
  }
}

final termsProvider =
    StateNotifierProvider<TermsNotifier, List<TermsAndConditionsModel>>((ref) {
  return TermsNotifier(getTermsFromStorage(0, 10) ?? termsData);
});

class TermsNotifier extends StateNotifier<List<TermsAndConditionsModel>> {
  TermsNotifier(super.state);

  void addUpdateTerms(TermsAndConditionsModel terms) {
    print(terms.toJson());
    final existingTermIndex = state.any((term) => term.id == terms.id);

    if (existingTermIndex) {
      state = [
        ...state.map((term) => term.id == terms.id ? terms : term).toList(),
      ];
    } else {
      state = [...state, terms];
    }

    GetStorage box = GetStorage();
    List<TermsAndConditionsModel> termsData = state;
    box.write("terms", termsData);
  }

  void addMoreTerms(List<TermsAndConditionsModel> termsList,
      List<TermsAndConditionsModel> moreTerms) {
    state = [...termsList, ...moreTerms];
    GetStorage box = GetStorage();
    List<TermsAndConditionsModel> termsData = state;
    box.write("terms", termsData);
  }

  void addHindiTerms(String text, int id) {
    state = state.map((item) {
      if (item.id == id) {
        item.translatedHindiText = text;
      }
      return item;
    }).toList();
  }
}

final hindiLanguageTermsProvider =
    StateNotifierProvider<LanguageTermsNotifier, List<int>>((ref) {
  return LanguageTermsNotifier();
});

class LanguageTermsNotifier extends StateNotifier<List<int>> {
  LanguageTermsNotifier() : super([]);

  void addHindiTermsid(int id) {
    state = [...state, id];
  }
}
