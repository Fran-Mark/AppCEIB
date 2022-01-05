import 'package:ceib/helpers/helper_functions.dart';
import 'package:ceib/models/event.dart';
import 'package:ceib/providers/auth_service.dart';
import 'package:ceib/providers/events.dart';
import 'package:ceib/widgets/animated_icon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  //Form values
  String _idValue = '';
  String _titleValue = '';
  String _descriptionValue = '';
  DateTime? _dateValue;
  String? _placeValue;
  String? _linkValue;
  bool _isUrgentValue = false;

  //State vars
  bool _dateVisibility = false;
  bool _placeVisibility = false;
  bool _linkVisibility = false;
  String _dateVisibilityText = "Agregar Fecha";
  String _placeVisibilityText = "Agregar Lugar";
  String _linkVisibilityText = "Agregar Link";
  Color _dateColor = Colors.red;
  Color _placeColor = Colors.red;
  Color _linkColor = Colors.red;

  @override
  void dispose() {
    _placeFocusNode.dispose();
    _linkFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    final _id = widget.event?.id;
    final _title = widget.event?.get('title') as String?;
    final _description = widget.event?['description'] as String?;
    final _isUrgent = widget.event?['isUrgent'] as bool?;
    String? _date;
    String? _place;
    String? _link;
    try {
      _date = widget.event?['date'] as String?;
    } on Exception {
      _date = null;
    }
    try {
      _place = widget.event?['place'] as String?;
    } on Exception {
      _place = null;
    }
    try {
      _link = widget.event?['link'] as String?;
    } on Exception {
      _link = null;
    }

    if (_id != null) {
      _idValue = _id;
    }
    if (_title != null) {
      _titleValue = _title;
    }
    if (_description != null) {
      _descriptionValue = _description;
    }
    if (_date != null && _date != 'null') {
      _toggleDateVisibility();
      _dateValue = DateTime.tryParse(_date);
    }
    if (_place != null) {
      _togglePlaceVisibility();
      _placeValue = _place;
    }
    if (_link != null) {
      _toggleLinkVisibility();
      _linkValue = _link;
    }
    if (_isUrgent != null) {
      _isUrgentValue = _isUrgent;
    }

    super.initState();
  }

  void _updateInvisibleValues() {
    //Es necesario porque onSaved es llamada cuando algo no es visible
    if (!_dateVisibility) _dateValue = null;
    if (!_placeVisibility) _placeValue = null;
    if (!_linkVisibility) _linkValue = null;
  }

  Future<void> _newEntry(User? user) async {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _form.currentState?.save();
    _updateInvisibleValues();
    if (user == null) return;
    final _eventBuilder = Event(
        id: _idValue,
        title: _titleValue,
        description: _descriptionValue,
        date: _dateValue,
        place: _placeValue,
        link: _linkValue,
        isUrgent: _isUrgentValue);
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
    _updateInvisibleValues();
    if (user == null) return;
    final _eventBuilder = Event(
        id: _idValue,
        title: _titleValue,
        description: _descriptionValue,
        date: _dateValue,
        place: _placeValue,
        link: _linkValue,
        isUrgent: _isUrgentValue);
    final result = await Provider.of<Events>(context, listen: false)
        .updateEvent(user, _eventBuilder, widget.event!);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context)
        .showSnackBar(buildSnackBar(context: context, text: result));
  }

  void _toggleDateVisibility() {
    setState(() {
      _dateVisibility = !_dateVisibility;
      if (_dateVisibility) {
        _dateVisibilityText = 'Quitar fecha';
        _dateColor = Colors.grey;
      } else {
        _dateVisibilityText = 'Agregar fecha';
        _dateColor = Colors.red;
      }
    });
  }

  void _togglePlaceVisibility() {
    setState(() {
      _placeVisibility = !_placeVisibility;
      if (_placeVisibility) {
        _placeVisibilityText = 'Quitar lugar';
        _placeColor = Colors.grey;
      } else {
        _placeVisibilityText = 'Agregar lugar';
        _placeColor = Colors.red;
      }
    });
  }

  void _toggleLinkVisibility() {
    setState(() {
      _linkVisibility = !_linkVisibility;
      if (_linkVisibility) {
        _linkVisibilityText = 'Quitar link';
        _linkColor = Colors.grey;
      } else {
        _linkVisibilityText = 'Agregar link';
        _linkColor = Colors.red;
      }
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
              TextFormField(
                  decoration: const InputDecoration(labelText: "Título"),
                  maxLines: null,
                  initialValue: _titleValue,
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
                    _titleValue = title!;
                  }),
              TextFormField(
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  initialValue: _descriptionValue,
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
                    _descriptionValue = description!;
                  }),
              Visibility(
                visible: _dateVisibility,
                child: DateTimeFormField(
                  initialValue: _dateValue,
                  decoration: const InputDecoration(
                    labelText: 'Cuándo?',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  validator: (date) {
                    if (_dateVisibility) {
                      if (date == null) {
                        return 'Ingresa una fecha';
                      }
                      if (date.isBefore(DateTime.now())) {
                        return 'No podés crear eventos en el pasado';
                      }
                    }
                  },
                  onSaved: (date) {
                    //Este chequeo es al pedo porque onSaved no se llama cuando el objeto no es visible. Pero
                    //lo dejo por posibles cambios
                    if (_dateVisibility)
                      _dateValue = date;
                    else
                      _dateValue = null;
                  },
                ),
              ),
              Visibility(
                visible: _placeVisibility,
                child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Dónde?',
                    ),
                    initialValue: _placeValue,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    validator: (place) {},
                    focusNode: _placeFocusNode,
                    onSaved: (place) {
                      if (_placeVisibility) {
                        _placeValue = place;
                      } else
                        _placeValue = null;
                    }),
              ),
              Visibility(
                visible: _linkVisibility,
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Link:',
                  ),
                  initialValue: _linkValue,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  validator: (link) {
                    if (link!.isEmpty) {
                      return 'Agrega un link válido';
                    }
                  },
                  focusNode: _linkFocusNode,
                  onSaved: (link) {
                    if (_linkVisibility) {
                      _linkValue = link;
                    } else {
                      _linkValue = null;
                    }
                  },
                ),
              ),
              CheckboxFormField(
                title: const Text("Es urgente?"),
                // ignore: avoid_bool_literals_in_conditional_expressions
                initialValue: _isUrgentValue,
                onSaved: (isUrgent) {
                  _isUrgentValue = isUrgent!;
                },
              ),
              Wrap(
                alignment: WrapAlignment.spaceAround,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      child: Text(
                        _dateVisibilityText,
                        style: TextStyle(color: _dateColor),
                      ),
                      onPressed: () {
                        _toggleDateVisibility();
                      },
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      child: Text(
                        _placeVisibilityText,
                        style: TextStyle(color: _placeColor),
                      ),
                      onPressed: () {
                        _togglePlaceVisibility();
                      },
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      child: Text(
                        _linkVisibilityText,
                        style: TextStyle(color: _linkColor),
                      ),
                      onPressed: () {
                        _toggleLinkVisibility();
                      },
                    ),
                  ),
                ],
              ),
              ElevatedButton(
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
