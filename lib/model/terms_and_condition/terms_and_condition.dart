class TermsAndConditionsModel {
  static int _lastId = 0;

  int id;
  final String value;
  String createdAt;
  String updatedAt;
  String translatedHindiText;

  TermsAndConditionsModel({
    int? id,
    required this.value,
    String? createdAt,
    String? updatedAt,
    String? translatedHindiText,
  })  : createdAt = createdAt ?? DateTime.now().toString(),
        updatedAt = updatedAt ?? DateTime.now().toString() ,
        translatedHindiText = translatedHindiText ?? '',
        id = id ?? ++_lastId{
    if (id != null && id > _lastId) {
      _lastId = id;
    }
  }

  factory TermsAndConditionsModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] ?? (_lastId + 1);

    return TermsAndConditionsModel(
      id: json['id'] ?? id,
      value: json['value'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      translatedHindiText: json['translatedHindiText'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'translatedHindiText': translatedHindiText,
    };
  }
}
