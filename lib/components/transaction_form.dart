// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double, DateTime, String) onSubmit;

  const TransactionForm(this.onSubmit, {super.key});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  final _expCategory = TextEditingController();
  DateTime? _selectedDate = DateTime.now();
  String? dropDownValue;
  final itens = [
    'home',
    'transport',
    'health',
    'education',
    'fun',
    'food',
    'clothing',
    'technology',
    'creditCard',
  ];

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        alignment: Alignment.centerLeft,
        child: Text(
          item,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,

          ),
        ),
      );

  _submitForm() {
    final title = _titleController.text;
    final value = double.tryParse(_valueController.text) ?? 0.0;
    if (title.isEmpty || value <= 0 || _selectedDate == null) {
      return;
    }
    final expCategory = _expCategory.text;
    widget.onSubmit(title, value, _selectedDate!, expCategory);
  }

  _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, 
          children: <Widget>[
          TextField(
            controller: _titleController,
            onSubmitted: (_) => _submitForm(),
            decoration: const InputDecoration(
              labelText: 'Title',
            ),
          ),
          Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              //border: Border.all(color: Colors.purple, width: 2),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint: const Text(
                  'Expenses category',
                  textAlign: TextAlign.center,
                ),
                value: dropDownValue,
                isExpanded: true,
                iconSize: 20,
                icon: const Icon(Icons.arrow_drop_down_circle,
                    color: Colors.purple),
                items: itens.map(buildMenuItem).toList(),
                onChanged: (value) => setState(() => dropDownValue = _expCategory.text = value.toString()),
              ),
            ),
          ),
          TextField(
            controller: _valueController,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            onSubmitted: (_) => _submitForm(),
            decoration: const InputDecoration(
              labelText: 'Value (R\$)',
            ),
          ),
          SizedBox(
            height: 70,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? 'No Date selected!'
                        : 'Selected date: ${DateFormat('dd/MM/y').format(_selectedDate!)}',
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: _showDatePicker,
                  child: const Text(
                    'Select the date',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                onPressed: _submitForm,
                child: const Text('New Transaction'),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
