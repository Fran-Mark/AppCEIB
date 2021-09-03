import 'package:ceib/providers/event.dart';
import 'package:ceib/providers/events.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:provider/provider.dart';
import '../widgets/checkbox_form_field.dart';

class NewEvent extends StatefulWidget {
  const NewEvent({Key? key}) : super(key: key);
  static const routeName = '/new-event';
  @override
  _NewEventState createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {
  //Definimos focos y formulario
  final _descriptionFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();

  var _newEvent =
      Event(id: '', title: '', description: '', date: DateTime(1998));

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _form.currentState?.save();
    await Provider.of<Events>(context, listen: false).addEvent(_newEvent);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nuevo Evento"),
        centerTitle: true,
      ),
      body: Padding(
          padding: EdgeInsets.all(8),
          child: Form(
            key: _form,
            child: ListView(children: [
              TextFormField(
                  decoration: InputDecoration(labelText: "Título"),
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
                    _newEvent = Event(
                        id: _newEvent.id,
                        title: title!,
                        description: _newEvent.description,
                        date: _newEvent.date);
                  }),
              TextFormField(
                  decoration: InputDecoration(labelText: 'Descripción'),
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
                    _newEvent = Event(
                        id: _newEvent.id,
                        title: _newEvent.title,
                        description: description!,
                        date: _newEvent.date);
                  }),
              DateTimeFormField(
                decoration: InputDecoration(
                    labelText: 'Fecha y hora',
                    suffixIcon: Icon(Icons.calendar_today)),
                validator: (fecha) {
                  if (fecha == null) {
                    return 'Ingresa una fecha';
                  }
                  if (fecha.isBefore(DateTime.now()))
                    return 'No podés crear eventos en el pasado';
                },
                onSaved: (date) {
                  _newEvent = Event(
                      id: _newEvent.id,
                      title: _newEvent.title,
                      description: _newEvent.description,
                      date: date!);
                },
              ),
              CheckboxFormField(
                title: Text("Es urgente?"),
                onSaved: (isUrgent) {
                  _newEvent = Event(
                      id: _newEvent.id,
                      title: _newEvent.title,
                      description: _newEvent.description,
                      date: _newEvent.date,
                      isUrgent: isUrgent!);
                },
              ),
              TextButton(onPressed: _saveForm, child: Text("Guardar"))
            ]),
          )),
    );
  }
}
