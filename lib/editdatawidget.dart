import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:stock_app/database/dbconn.dart';

import 'package:stock_app/models/items.dart';

enum TransType { earning, expense }

class EditDataWidget extends StatefulWidget {
  EditDataWidget(this.items);

  final Items items;

  @override
  _EditDataWidgetState createState() => _EditDataWidgetState();
}

class _EditDataWidgetState extends State<EditDataWidget> {
  _EditDataWidgetState();

  DbConn dbconn = DbConn();
  final _addFormKey = GlobalKey<FormState>();
  int _itemsId = null;
  final format = DateFormat("dd-MM-yyyy");
  final _itemsDateController = TextEditingController();
  final _itemsNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void initState() {
    _itemsId = widget.items.itemsId;
    _itemsDateController.text = widget.items.itemsDate;
    _itemsNameController.text = widget.items.itemsName;
    _quantityController.text = widget.items.itemsQuantity.toString();
    _priceController.text = widget.items.itemsPrice.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Data'),
      ),
      body: Form(
        key: _addFormKey,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Card(
                child: Container(
                    padding: EdgeInsets.all(10.0),
                    width: 440,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Column(
                            children: <Widget>[
                              Text('Transaction Date'),
                              DateTimeField(
                                format: format,
                                controller: _itemsDateController,
                                onShowPicker: (context, currentValue) {
                                  return showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1900),
                                      initialDate:
                                          currentValue ?? DateTime.now(),
                                      lastDate: DateTime(2100));
                                },
                                onChanged: (value) {},
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Column(
                            children: <Widget>[
                              Text('Items Name'),
                              TextFormField(
                                controller: _itemsNameController,
                                decoration: const InputDecoration(
                                  hintText: 'Items Name',
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter items name';
                                  }
                                  return null;
                                },
                                onChanged: (value) {},
                              ),
                            ],
                          ),
                        ),
                        /*Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Column(
                            children: <Widget>[
                              Text('Transaction Type'),
                              ListTile(
                                title: const Text('Earning'),
                                leading: Radio(
                                  value: TransType.earning,
                                  groupValue: _transType,
                                  onChanged: (TransType value) {
                                    setState(() {
                                      _transType = value;
                                      transType = 'earning';
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                title: const Text('Expense'),
                                leading: Radio(
                                  value: TransType.expense,
                                  groupValue: _transType,
                                  onChanged: (TransType value) {
                                    setState(() {
                                      _transType = value;
                                      transType = 'expense';
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),*/
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Column(
                            children: <Widget>[
                              Text('Amount'),
                              TextFormField(
                                controller: _priceController,
                                decoration: const InputDecoration(
                                  hintText: 'Amount',
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter amount';
                                  }
                                  return null;
                                },
                                onChanged: (value) {},
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Column(
                            children: <Widget>[
                              Text('Amount'),
                              TextFormField(
                                controller: _priceController,
                                decoration: const InputDecoration(
                                  hintText: 'Amount',
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter amount';
                                  }
                                  return null;
                                },
                                onChanged: (value) {},
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Column(
                            children: <Widget>[
                              RaisedButton(
                                splashColor: Colors.red,
                                onPressed: () {
                                  if (_addFormKey.currentState.validate()) {
                                    _addFormKey.currentState.save();
                                    final initDB = dbconn.initDB();
                                    initDB.then((db) async {
                                      await dbconn.updateItems(Items(
                                          itemsId: _itemsId,
                                          itemsDate: _itemsDateController.text,
                                          itemsName: _itemsNameController.text,
                                          itemsQuantity: int.parse(
                                              _quantityController.text),
                                          itemsPrice: int.parse(
                                              _priceController.text)));
                                    });

                                    Navigator.popUntil(
                                        context,
                                        ModalRoute.withName(
                                            Navigator.defaultRouteName));
                                  }
                                },
                                child: Text('Update',
                                    style: TextStyle(color: Colors.white)),
                                color: Colors.blue,
                              )
                            ],
                          ),
                        ),
                      ],
                    ))),
          ),
        ),
      ),
    );
  }
}
