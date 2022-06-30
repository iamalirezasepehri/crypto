class crypto {
  String id;
  int rank;
  String symbol;
  String name;
  double marketCapUsd;
  double priceUsd;
  double changePercent24Hr;

  crypto(this.id, this.rank, this.name, this.symbol, this.changePercent24Hr,
      this.marketCapUsd, this.priceUsd);

  factory crypto.frommap(Map<String, dynamic> fromobject) {
    return crypto(
        fromobject['id'],
        int.parse(fromobject['rank']),
        fromobject['name'],
        fromobject['symbol'],
        double.parse(fromobject['changePercent24Hr']),
        double.parse(fromobject['marketCapUsd']),
        double.parse(fromobject['priceUsd']));
  }
}
