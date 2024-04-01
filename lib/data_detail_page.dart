library devaloop_data_detail_page;

import 'package:devaloop_form_builder/form_builder.dart';
import 'package:flutter/material.dart';

class DataDetailPage extends StatefulWidget {
  final String title;
  final String subtitle;
  final dynamic id;
  final List<Input> inputFields;
  final dynamic Function(dynamic id, Map<String, InputValue> inputValues) save;
  final dynamic Function(dynamic id) delete;
  final Function(BuildContext context, Map<String, InputValue> inputValues)?
      onInitial;
  final dynamic Function(
      BuildContext context,
      Map<String, InputValue> inputValues,
      bool isValid,
      Map<String, String?> errorMessages)? onAfterValidation;
  final dynamic Function(
          BuildContext context, Map<String, InputValue> inputValues)?
      onBeforeValidation;
  final dynamic Function(
      BuildContext context,
      Input input,
      dynamic previousValue,
      dynamic currentValue,
      Map<String, InputValue> inputValues)? onValueChanged;
  final bool? isFormEditable;
  final List<AdditionalButton>? additionalButtons;

  const DataDetailPage(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.id,
      required this.inputFields,
      required this.delete,
      required this.save,
      this.onInitial,
      this.onAfterValidation,
      this.onBeforeValidation,
      this.onValueChanged,
      this.isFormEditable,
      this.additionalButtons});

  @override
  State<DataDetailPage> createState() => _DataDetailPageState();
}

class _DataDetailPageState extends State<DataDetailPage> {
  late bool? _isUpdatedOrRemoved;

  @override
  void initState() {
    _isUpdatedOrRemoved = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, _isUpdatedOrRemoved);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: ListTile(
          title: Text(
            widget.title,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            widget.subtitle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: FormBuilder(
            inputFields: widget.inputFields,
            onInitial: widget.onInitial,
            onAfterValidation: widget.onAfterValidation,
            onBeforeValidation: widget.onBeforeValidation,
            onValueChanged: widget.onValueChanged,
            isFormEditable: widget.isFormEditable,
            additionalButtons: [
                  AdditionalButton(
                    label: 'Delete',
                    icon: const Icon(Icons.delete),
                    onTap: (context, inputValues) async {
                      var result = await showDialog<String>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            icon: const Icon(Icons.warning),
                            title:
                                const Text('Are you sure to delete this item?'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('No'),
                                onPressed: () {
                                  Navigator.of(context).pop('No');
                                },
                              ),
                              TextButton(
                                child: const Text('Yes'),
                                onPressed: () {
                                  Navigator.of(context).pop('Yes');
                                },
                              ),
                            ],
                          );
                        },
                      );

                      if (result == 'Yes') {
                        await widget.delete.call(widget.id);

                        if (!context.mounted) return;

                        Navigator.pop(context, true);
                      }
                    },
                  ),
                ] +
                (widget.additionalButtons ?? []),
            onSubmit: (context, inputValues) async {
              await widget.save.call(widget.id, inputValues);

              if (!context.mounted) return;

              await showDialog<String>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    icon: const Icon(Icons.info),
                    title: const Text('Data successfully saved.'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Ok'),
                        onPressed: () {
                          Navigator.of(context).pop('Ok');
                        },
                      ),
                    ],
                  );
                },
              );

              setState(() {
                _isUpdatedOrRemoved = true;
              });
            },
            submitButtonSettings: const SubmitButtonSettings(
              label: 'Save',
              icon: Icon(Icons.save),
            ),
          ),
        ),
      ),
    );
  }
}
