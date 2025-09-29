class Produto {
  final String nome;
  final String descricao;
  final String categoria;
  final String dataValidade; // mantido como String para simplificar
  final String posicao;
  final int estoque;

  Produto({
    required this.nome,
    required this.descricao,
    required this.categoria,
    required this.dataValidade,
    required this.posicao,
    required this.estoque,
  });
}
