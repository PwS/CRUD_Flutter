class Items {
  final int itemsId;
  final String itemsDate;
  final String itemsName;
  final int itemsQuantity;
  final int itemsPrice;

  Items(
      {this.itemsId, this.itemsDate, this.itemsName, this.itemsQuantity, this.itemsPrice});

  Map<String,dynamic> toMap() {
    return {
      'id': itemsId,
      'date': itemsDate,
      'name': itemsName,
      'quantity': itemsQuantity,
      'price': itemsPrice
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'Items{id: $itemsId,itemsName: $itemsName, itemsQuantity: $itemsQuantity, itemsPrice: $itemsPrice}';
  }
}
