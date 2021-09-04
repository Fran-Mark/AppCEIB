import 'package:ceib/helpers/helper_functions.dart';
import 'package:ceib/providers/auth_service.dart';
import 'package:ceib/providers/event.dart';
import 'package:ceib/providers/events.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:provider/provider.dart';
import '../widgets/checkbox_form_field.dart';

class EventBuilder extends StatefulWidget {
  EventBuilder(
      {Key? key,
      this.title = '',
      this.description = '',
      this.date,
      this.isUrgent = false})
      : super(key: key);
  static const routeName = '/edit-event';
  final title;
  final description;
  final date;
  final isUrgent;
  @override
  _EventBuilderState createState() => _EventBuilderState();
}

class _EventBuilderState extends State<EventBuilder> {
  final _descriptionFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  // final _titleController = TextEditingController();
  // final _descriptionController = TextEditingController();
  // final _dateTimeController = TextEditingController();

  var _EventBuilder =
      Event(id: '', title: '', description: '', date: DateTime(1998));

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    // _titleController.dispose();
    // _descriptionController.dispose();
    // _dateTimeController.dispose();
    super.dispose();
  }

  // @override
  // void didChangeDependencies() {
  //   final routeArgs =
  //       ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
  //   if (routeArgs != null) {
  //     _titleController.text = routeArgs['title'];
  //     _descriptionController.text = routeArgs['description'];
  //     _dateTimeController.text = routeArgs['date'].toString();
  //   }
  //   super.didChangeDependencies();
  // }

  Future<void> _saveForm(User? user) async {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _form.currentState?.save();
    if (user == null) return;
    final result = await Provider.of<Events>(context, listen: false)
        .addEvent(_EventBuilder, user);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context)
        .showSnackBar(buildSnackBar(context: context, text: result));
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AuthServices>(context).firebaseAuth.currentUser;

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
                  //controller: _titleController,
                  initialValue: widget.title,
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
                    _EventBuilder = Event(
                        id: _EventBuilder.id,
                        title: title!,
                        description: _EventBuilder.description,
                        date: _EventBuilder.date);
                  }),
              TextFormField(
                  decoration: InputDecoration(labelText: 'Descripción'),
                  initialValue: widget.description,
                  //controller: _descriptionController,
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
                    _EventBuilder = Event(
                        id: _EventBuilder.id,
                        title: _EventBuilder.title,
                        description: description!,
                        date: _EventBuilder.date);
                  }),
              DateTimeFormField(
                //initialValue: DateTime.parse(_dateTimeController.text),
                initialValue: widget.date,
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
                  _EventBuilder = Event(
                      id: _EventBuilder.id,
                      title: _EventBuilder.title,
                      description: _EventBuilder.description,
                      date: date!);
                },
              ),
              CheckboxFormField(
                title: Text("Es urgente?"),
                initialValue: widget.isUrgent,
                onSaved: (isUrgent) {
                  _EventBuilder = Event(
                      id: _EventBuilder.id,
                      title: _EventBuilder.title,
                      description: _EventBuilder.description,
                      date: _EventBuilder.date,
                      isUrgent: isUrgent!);
                },
              ),
              TextButton(
                  onPressed: () => _saveForm(_user), child: Text("Guardar"))
            ]),
          )),
    );
  }
}
