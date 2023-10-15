import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pidilite_assignment/content/terms.dart';
import '../model/terms_and_condition/terms_and_condition.dart';

GetStorage box = GetStorage();

List<TermsAndConditionsModel> getTermsFromStorage(int offset, int limit) {
  box.read<List<dynamic>>("terms");
  final List<dynamic>? storedData = box.read<List<dynamic>>("terms");
  if (storedData != null) {
    final List<TermsAndConditionsModel> storedTermsData =
        storedData.map((item) {
      return TermsAndConditionsModel.fromJson(item);
    }).toList();
    return storedTermsData.skip(offset).take(limit).toList();
  } else {
    return termsData.skip(offset).take(limit).toList();
  }
}
final StateProvider<bool> isDownloadedProvider = StateProvider<bool>((ref) {
  return false;
});

final termsProvider =
    StateNotifierProvider<TermsNotifier, List<TermsAndConditionsModel>>((ref) {
  return TermsNotifier([]);
});

class TermsNotifier extends StateNotifier<List<TermsAndConditionsModel>> {
  TermsNotifier(List<TermsAndConditionsModel> state) : super(state);

  void addUpdateTerms(TermsAndConditionsModel terms) {
    final existingList = state;
    final existingTerm = existingList.any((term) => term.id == terms.id);
    if (existingTerm) {
      state = [
        ...state.map((term) => term.id == terms.id ? terms : term).toList(),
      ];
    } else {
      state = [...state, terms];
    }
    List<dynamic> termsData = state;
    box.write("terms", termsData);
  }

  void getTerms(List<TermsAndConditionsModel> termsList) {
    state = termsList;
  }

  void addMoreTerms(List<TermsAndConditionsModel> termsList,
      List<TermsAndConditionsModel> moreTerms) {
    state = [...termsList, ...moreTerms];
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
