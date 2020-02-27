
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:quotesbook/helpers/db_helper.dart';
import 'package:quotesbook/models/Quote.dart';
import 'package:http/http.dart' as http;

class Quotes with ChangeNotifier {

  final List<Quote> _quotes = [];

  static const SERVER_HOST = "https://quotesbook.herokuapp.com/";

  get quotes {
    return _quotes;
  }

  final _authenticatedHeader = {
      'Authorization': 'Token 9598020bb81bf271c7105c9b057823b62463eae2'
    };

  Future<void> fetchQuotes() async  {
    
    final url = "${SERVER_HOST}api/v1/quotes/sample";    

    var response = await http.get(url, headers: _authenticatedHeader );    

    List<dynamic> quotesMap = json.decode(response.body);
    
    //print(quotesMap);

    _quotes.addAll( quotesMap.map( (map) => Quote.fromMap(map) ) );

    notifyListeners(); 
  }

  Future<void> saveQuote(Quote quote) async {
    quote.isFavorite = true;

    DBHelper.insertQuote(quote);

    notifyListeners();
  }

  Future<void> removeQuote(Quote quote) async {

    quote.isFavorite = false;

    notifyListeners();
  }
}