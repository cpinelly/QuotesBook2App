import 'dart:async';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotesbook/helpers/app_localizations.dart';
import 'package:quotesbook/screens/quote_details_screen.dart';

import '../providers/quotes.dart';
import '../widgets/quote_listitem.dart';

class QuotesListScreen extends StatefulWidget {
  var lang;
  QuotesListScreen({Key key, @required this.lang}) : super(key: key);

  @override
  _QuotesListScreenState createState() => _QuotesListScreenState();
}

class _QuotesListScreenState extends State<QuotesListScreen> {

  var _loadingQuotes = false;
  var _automaticReloadEnabled = false;
  var _elapsedErrors = 0;
  var _pageController = PageController(viewportFraction: 0.9);

  // Allows to know when to ask the next quotes page
  var _totalQuotes = 0;


  Future<void> _initialLoad;

  @override
  void initState() {
    super.initState();
    if (_initialLoad == null) {
      _initialLoad = _fetchQuotes();
    }
  }

  @override
  dispose() {
    super.dispose();
    _pageController.dispose();
  }

  Widget _buildList(context) {

    if (!_pageController.hasListeners){
      _pageController.addListener(() {
        if (_pageController.page > _totalQuotes - 5 && !_loadingQuotes ) {
          _fetchQuotes();
        }
      });
    }
    
    return Consumer<Quotes>(
      builder: (context, provider, _) {
        return PageView.builder(
        scrollDirection: Axis.vertical,
        controller: _pageController,
        itemBuilder: (ctx, position) {
          if (position == provider.quotes.length) {
            return Container(
              child: Center(
                  child: Theme(
                data: Theme.of(context).copyWith(accentColor: Colors.grey),
                child: CircularProgressIndicator(),
              )),
              height: 80,
            );
          } else {
            var quote = provider.quotes[position];
            var prevQuote = (position-1 >= 0) ? provider.quotes[position-1] : null;
            return QuoteListItem(
                quote: quote,
                previousQuote: prevQuote, // (position-1 >= 0) ? provider.quotes[position-1] : null,
                onTap: () {
                  Navigator.of(context).pushNamed(QuoteDetailsScreen.routeName, arguments: {'quote': quote});
                });


          }
        },
        itemCount: provider.quotes.length + 1,
      );
      },
    );
  }

  Future<void> _fetchQuotes() {

    _loadingQuotes = true;

    var promise = Provider.of<Quotes>(context, listen: false)
        .fetchQuotes(lang: widget.lang);

    promise.then((value) => _totalQuotes += value.length);

    promise.catchError((err) {
      if (_elapsedErrors == 0) {
        Scaffold.of(context).hideCurrentSnackBar();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Scaffold.of(context).showSnackBar(_automaticReloadEnabled
              ? SnackBar(
                  content:
                      Text(AppLocalizations.of(context).quotesLoadErrorMessage),
                  duration: Duration(seconds: 20),
                )
              : SnackBar(content: Text('Some error has ocurred.')));
        });
      }

      if (_automaticReloadEnabled) {
        Timer(Duration(seconds: 3), _fetchQuotes);
      }

      _elapsedErrors++;
    });

    promise.then((res) {
      Scaffold.of(context).hideCurrentSnackBar();
      _elapsedErrors = 0;
    });

    promise.whenComplete(() {
      _loadingQuotes = false;
    });

    return promise;
  }

  @override
  Widget build(BuildContext context) {
    var quotesProvider = Provider.of<Quotes>(context, listen: false);

    return (quotesProvider.quotes.length > 0)
        ? _buildList(context)
        : FutureBuilder(
            future: _initialLoad,
            builder: (context, snapshot) {
              if (snapshot.hasError &&
                  snapshot.connectionState == ConnectionState.done) {
                return Center(
                    child: Ink(
                  decoration: ShapeDecoration(
                    shape: CircleBorder(),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.replay),
                    onPressed: () {
                      setState(() {
                        _initialLoad = _fetchQuotes();
                      });
                    },
                  ),
                ));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                _automaticReloadEnabled = true;
                return _buildList(context);
              }
            },
          );
  }
}
