import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectDialogItem<V> {
  const SelectDialogItem(this.value, this.label);

  final V value;
  final String label;
}

class SelectDialog<V> extends StatefulWidget {
  const SelectDialog({
    Key? key,
    required this.items,
    this.initialSelectedValue,
    this.title,
    this.submitText,
    this.cancelText,
  }) : super(key: key);

  final List<SelectDialogItem<V>> items;
  final V? initialSelectedValue;
  final String? title;
  final String? submitText;
  final String? cancelText;

  @override
  State<SelectDialog<V>> createState() => _SelectDialogState<V>();
}

class _SelectDialogState<V> extends State<SelectDialog<V>> {
  V? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialSelectedValue;
  }

  void _onItemCheckedChange(V itemValue, bool checked) {
    setState(() {
      _selectedValue = checked ? itemValue : null;
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() {
    Navigator.pop(context, _selectedValue);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title ?? ""),
      contentPadding: const EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: const EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: ListBody(
            children: widget.items.map(_buildItem).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        MaterialButton(
          elevation: 0,
          child: Text(widget.cancelText ?? "Cancel"),
          onPressed: _onCancelTap,
        ),
        MaterialButton(
          elevation: 0,
          child: Text(widget.submitText ?? "OK"),
          onPressed: _onSubmitTap,
        ),
      ],
    );
  }

  Widget _buildItem(SelectDialogItem<V> item) {
    final bool checked = _selectedValue == item.value;
    return CheckboxListTile(
      value: checked,
      activeColor: Get.theme.colorScheme.secondary,
      title: Text(item.label, style: Theme.of(context).textTheme.bodyMedium),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (bool? isChecked) {
        if (isChecked != null) {
          _onItemCheckedChange(item.value, isChecked);
        }
      },
    );
  }
}
