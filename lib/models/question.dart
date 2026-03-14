class Question {
  final int id;
  final String ifade;
  final bool cevap;
  final String aciklama;
  final String kategori;

  Question({
    required this.id,
    required this.ifade,
    required this.cevap,
    required this.aciklama,
    required this.kategori,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      ifade: json['ifade'],
      cevap: json['cevap'],
      aciklama: json['aciklama'],
      kategori: json['kategori'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ifade': ifade,
      'cevap': cevap,
      'aciklama': aciklama,
      'kategori': kategori,
    };
  }
}
