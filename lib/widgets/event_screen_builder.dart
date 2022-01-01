import 'package:ceib/helpers/helper_functions.dart';
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
  final _form = GlobalKey<FormState>();

  var _eventBuilder =
      Event(id: '', title: '', description: '', date: DateTime.now());

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AuthServices>(context).firebaseAuth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Nuevo Evento"),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.all(8),
          child: Form(
            key: _form,
            child: ListView(children: [
              TextFormField(
                  decoration: const InputDecoration(labelText: "Título"),
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
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
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
              DateTimeFormField(
                initialValue: widget.event != null
                    ? DateTime.parse(widget.event!['date'] as String)
                    : DateTime.now(),
                decoration: const InputDecoration(
                  labelText: 'Fecha y hora',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                validator: (fecha) {
                  if (fecha == null) {
                    return 'Ingresa una fecha';
                  }
                  if (fecha.isBefore(DateTime.now())) {
                    return 'No podés crear eventos en el pasado';
                  }
                },
                onSaved: (date) {
                  _eventBuilder = Event(
                      id: _eventBuilder.id,
                      title: _eventBuilder.title,
                      description: _eventBuilder.description,
                      date: date!);
                },
              ),
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
              )
            ]),
          )),
    );
  }
}
