class Epi {
  final int id;
  final String nome;
  final String categoria;
  final String ca;
  final String validadeCa; 
  final String imagemUrl;
  final int quantidade;    
  final bool caVencido;    

  Epi({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.ca,
    required this.validadeCa,
    required this.imagemUrl,
    required this.quantidade,
    required this.caVencido,
  });

  factory Epi.fromJson(Map<String, dynamic> json) {
    return Epi(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      categoria: json['categoria'] ?? '',
      ca: json['ca'] ?? '',
      validadeCa: json['validadeCa'] ?? '',
      imagemUrl: json['imagemUrl'] ?? '',
      quantidade: json['quantidadeDisponivel'] ?? 0,
      caVencido: json['caVencido'] ?? false,
    );
  }
}
