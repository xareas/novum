import 'dart:convert';
import '../models/symbol_model.dart';
import '../models/chart_model.dart';
import 'package:http/http.dart';

class IexApiProvider {

  final String urlPrefix = 'https://api.iextrading.com/1.0';
  final client = Client();

  Future<List<SymbolModel>> symbols() async {
    final response = await client.get(urlPrefix + '/stock/market/batch?symbols=aapl,fb,goog&types=quote');
    final Map<String, dynamic> parsedJson = _handleResponse(response);
    List<SymbolModel> symbolList = [];
    for (Map<String, dynamic> value in parsedJson.values) {
      symbolList.add(SymbolModel.fromJson(value['quote']));
    }
    return symbolList;
  }

  Future<ChartModel> chart(SymbolModel symbol) async {
    final response = await client.get(urlPrefix + '/stock/${symbol.symbol}/chart/1d');
    List<dynamic> parsedJson = json.decode(response.body);
    return ChartModel.fromJson(symbol, parsedJson);
  }

  Map<String, dynamic> _handleResponse(Response response) {
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data.');
    }
  }

}