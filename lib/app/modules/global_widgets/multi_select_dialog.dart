import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MultiSelectDialogItem<V> {
  const MultiSelectDialogItem(this.value, this.label);

  final V value;
  final String label;
}

class MultiSelectDialog<V> extends StatefulWidget {
  const MultiSelectDialog({
    super.key,
    required this.items,
    required this.initialSelectedValues,
    this.title,
    this.submitText,
    this.cancelText,
  });

  final List<MultiSelectDialogItem<V>>? items;
  final Set<V>? initialSelectedValues;
  final String? title;
  final String? submitText;
  final String? cancelText;

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState<V>();
}

class _MultiSelectDialogState<V> extends State<MultiSelectDialog<V>> {
  final Set<V> _selectedValues = {};

  @override
  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues!);
    }
  }

  void _onItemCheckedChange(V itemValue, bool? checked) {
    setState(() {
      if (checked == true) {
        _selectedValues.add(itemValue);
      } else {
        _selectedValues.remove(itemValue);
      }
    });
  }

  void _onCancelTap() => Navigator.pop(context);

  void _onSubmitTap() => Navigator.pop(context, _selectedValues);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title ?? ""),
      contentPadding: const EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: const EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: ListBody(
            children: widget.items?.map(_buildItem).toList() ?? [],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(widget.cancelText ?? "Cancel"),
          onPressed: _onCancelTap,
        ),
        TextButton(
          child: Text(widget.submitText ?? "OK"),
          onPressed: _onSubmitTap,
        ),
      ],
    );
  }

  Widget _buildItem(MultiSelectDialogItem<V> item) {
    final checked = _selectedValues.contains(item.value);
    return CheckboxListTile(
      value: checked,
      activeColor: Get.theme.colorScheme.secondary,
      title: Text(item.label, style: Theme.of(context).textTheme.bodyMedium),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (bool? checked) => _onItemCheckedChange(item.value, checked),
    );
  }
}
