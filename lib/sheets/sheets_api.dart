import 'package:gsheets/gsheets.dart';
import './sheets_credentials.dart';

class SheetsAPI {
  static final _gSheets = GSheets(credentials);
  static Worksheet? _sociosSheet;
  static Future init() async {
    final spreadsheet = await _gSheets.spreadsheet(spreadsheetId);
    _sociosSheet = spreadsheet.worksheetByTitle('Socios');
    //_sociosSheet!.values.insertRow(1, ["Yhibo", "es", "disca"]);
  }

  static Future<String> getDebt(String email) async {
    final rowJson =
        await _sociosSheet!.values.map.rowByKey(email, fromColumn: 1);
    if (rowJson == null) return "No estás asociado al CEIB (o paso algo)";
    final debt = int.parse(rowJson['Deuda']!) * -1;
    return debt.toString();
  }
}
