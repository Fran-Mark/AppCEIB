import 'package:ceib/helpers/helper_functions.dart';
import 'package:ceib/helpers/strings.dart';
import 'package:ceib/models/event.dart';
import 'package:ceib/providers/auth_service.dart';
import 'package:ceib/providers/events.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/checkbox_form_field.dart';

class EventBuilder extends StatefulWidget {
  const EventBuilder({
    Key? key,
    this.event,
  }) : super(key: key);
  static const routeName = '/edit-event';

  final DocumentSnapshot? event;
  @override
  _EventBuilderState createState() => _EventBuilderState();
}

class _EventBuilderState extends State<EventBuilder> {
  final _descriptionFocusNode = FocusNode();
  final _placeFocusNode = FocusNode();
  final _linkFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  //State vars
  bool _dateVisibility = false;
  bool _placeVisibility = false;
  bool _linkVisibility = false;
  DateTime? _dateValue;
  String? _placeValue;
  String? _linkValue;

  var _eventBuilder =
      Event(id: '', title: '', description: '', date: DateTime.now());

  @override
  void dispose() {
    _placeFocusNode.dispose();
    _linkFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    final _date = widget.event?['date'] as String?;
    if (_date != null) {
      _dateVisibility = true;
      _dateValue = DateTime.parse(_date);
    }
    super.initState();
  }

  Future<void> _newEntry(User? user) async {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _form.currentState?.save();
    if (user == null) return;
    final result = await Provider.of<Events>(context, listen: false)
        .addEvent(_eventBuilder, user);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context)
        .showSnackBar(buildSnackBar(context: context, text: result));
  }

  Future<void> _updateEntry(User? user) async {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _form.currentState?.save();
    if (user == null) return;
    final result = await Provider.of<Events>(context, listen: false)
        .updateEvent(user, _eventBuilder, widget.event!);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context)
        .showSnackBar(buildSnackBar(context: context, text: result));
  }

  void _toggleDateVisibility() {
    setState(() {
      _dateVisibility = !_dateVisibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AuthServices>(context).firebaseAuth.currentUser;
    String _title;
    if (widget.event != null)
      _title = "Editar Evento";
    else
      _title = "Nuevo Evento";
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.all(8),
          child: Form(
            key: _form,
            child: ListView(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: _toggleDateVisibility,
                      child: Text("Agregar Fecha")),
                  ElevatedButton(
                      onPressed: _toggleDateVisibility,
                      child: Text("Agregar Fecha")),
                ],
              ),
              TextFormField(
                  decoration: const InputDecoration(labelText: "Título"),
                  maxLines: null,
                  initialValue: widget.event != null
                      ? widget.event!['title'] as String
                      : '',
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  validator: (title) {
                    if (title!.isEmpty) {
                      return 'Ingresa un título';
                    }
                  },
                  onSaved: (title) {
                    _eventBuilder = Event(
                        id: _eventBuilder.id,
                        title: title!,
                        description: _eventBuilder.description,
                        date: _eventBuilder.date);
                  }),
              TextFormField(
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  initialValue: widget.event != null
                      ? widget.event!['description'] as String
                      : '',
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  validator: (description) {
                    if (description!.isEmpty) return 'Escribe una descripción';
                    if (description.length < 5)
                      return 'Dale, escribí más de 5 caracteres';
                  },
                  focusNode: _descriptionFocusNode,
                  onSaved: (description) {
                    _eventBuilder = Event(
                        id: _eventBuilder.id,
                        title: _eventBuilder.title,
                        description: description!,
                        date: _eventBuilder.date);
                  }),
              Visibility(
                visible: _dateVisibility,
                child: DateTimeFormField(
                  initialValue: _dateValue,
                  decoration: const InputDecoration(
                    labelText: 'Cuándo? (opcional)',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  validator: (fecha) {
                    if (_dateVisibility) {
                      if (fecha == null) {
                        return 'Ingresa una fecha';
                      }
                      if (fecha.isBefore(DateTime.now())) {
                        return 'No podés crear eventos en el pasado';
                      }
                    }
                  },
                  onSaved: (date) {
                    if (_dateVisibility) {
                      _eventBuilder = Event(
                          id: _eventBuilder.id,
                          title: _eventBuilder.title,
                          description: _eventBuilder.description,
                          date: date!);
                    } else {
                      _eventBuilder = Event(
                          id: _eventBuilder.id,
                          title: _eventBuilder.title,
                          description: _eventBuilder.description,
                          date: DateTime.parse(referenceDate));
                    }
                  },
                ),
              ),
              // TextFormField(
              //     decoration: const InputDecoration(
              //       labelText: 'Dónde? (opcional)',
              //     ),
              //     initialValue: widget.event != null
              //         ? widget.event!['place'] as String
              //         : '',
              //     textInputAction: TextInputAction.next,
              //     keyboardType: TextInputType.multiline,
              //     maxLines: null,
              //     validator: (place) {},
              //     focusNode: _placeFocusNode,
              //     onSaved: (place) {}),
              // TextFormField(
              //     decoration: const InputDecoration(
              //       labelText: 'Link (opcional)',
              //     ),
              //     initialValue: widget.event != null
              //         ? widget.event!['link'] as String
              //         : '',
              //     textInputAction: TextInputAction.done,
              //     keyboardType: TextInputType.multiline,
              //     maxLines: null,
              //     validator: (link) {},
              //     focusNode: _linkFocusNode,
              //     onSaved: (link) {}),
              CheckboxFormField(
                title: const Text("Es urgente?"),
                // ignore: avoid_bool_literals_in_conditional_expressions
                initialValue: widget.event != null
                    ? widget.event!['isUrgent'] as bool
                    : false,
                onSaved: (isUrgent) {
                  _eventBuilder = Event(
                      id: _eventBuilder.id,
                      title: _eventBuilder.title,
                      description: _eventBuilder.description,
                      date: _eventBuilder.date,
                      isUrgent: isUrgent!);
                },
              ),
              TextButton(
                onPressed: widget.event == null
                    ? () => _newEntry(_user)
                    : () => _updateEntry(_user),
                child: const Text("Guardar"),
              ),
            ]),
          )),
    );
  }
}
