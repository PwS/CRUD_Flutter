import 'package:flutter/material.dart';
import 'package:stock_app/models/items.dart';
import 'package:stock_app/ui/widget/widget.dart';

class ItemsList extends StatelessWidget {
  final List<Items> items;

  ItemsList({Key key, this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: items == null ? 0 : items.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailWidget(items[index])),
                );
              },
              child: ListTile(
                leading: items[index].itemsId != null
                    ? Icon(Icons.attach_money)
                    : Icon(Icons.money_off),
                title: Text(items[index].itemsName),
                subtitle: Text(items[index].itemsPrice.toString()),
              ),
            ),
          );
        });
  }
}
