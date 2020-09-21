import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotesbook/models/Quote.dart';
import 'package:quotesbook/models/QuoteTheme.dart';
import 'package:quotesbook/providers/saved_quotes.dart';
import 'package:quotesbook/widgets/bookmark.dart';
import 'package:quotesbook/widgets/quote_body.dart';
import 'package:share/share.dart';

class QuoteDetailsScreen extends StatelessWidget {
  Quote _quote;
  QuoteTheme _theme;

  static final routeName = "/quote";

  final _screenPadding = 22.0;

  Widget _onTextSharePressed() {
    Share.share(_quote.body);
  }


  Widget _onSharePressed(BuildContext ctx){
    showModalBottomSheet(context: ctx, builder: (_){
      return Container(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.textsms),
              title: Text("Text", ),
              onTap: (){
                _onTextSharePressed();
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: Icon(Icons.image),
              title: Text("Image", ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildQuoteBody() {
    return Padding(
      padding: EdgeInsets.all(_screenPadding),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            QuoteBody(
              quote: _quote,
            ),
            SizedBox(
              height: 120,
            ) // For center taking account the app bar
          ],
        ),
      ),
    );
  }

  Widget _buildSavedMarker(SavedQuotes quotesProvider) {
    return GestureDetector(
        child: Stack(
          children: <Widget>[
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: 50,
              curve: Curves.bounceOut,
              height: _quote.isFavorite ? 50 : 30,
              child: Bookmark(
                  _quote.isFavorite ? Colors.amber : _theme.secondaryColor),
            ),
            if (_quote.isFavorite)
              Container(
                child: Center(
                  child: Icon(
                    Icons.star,
                    color: Colors.white,
                  ),
                ),
                width: 50,
                height: 40,
              )
          ],
        ),
        onTap: () {
          if (_quote.isFavorite) {
            quotesProvider.removeQuote(_quote);
          } else {
            quotesProvider.saveQuote(_quote);
          }
        });
  }

  Widget _buildBottomMenu(BuildContext ctx, SavedQuotes quotesProvider) {
    return Container(
      height: 32,
      alignment: Alignment.centerRight,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), bottomLeft: Radius.circular(50))),
        height: 32,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FlatButton.icon(
                onPressed: () {
                  if (_quote.isFavorite) {
                    quotesProvider.removeQuote(_quote);
                  } else {
                    quotesProvider.saveQuote(_quote);
                  }
                },
                icon: _quote.isFavorite
                    ? Icon(
                        Icons.bookmark,
                        color: Colors.amber,
                      )
                    : Icon(
                        Icons.bookmark_border,
                        color: Colors.white,
                      ),
                label: Text("")),
            FlatButton.icon(
                onPressed: () {
                  _onSharePressed(ctx);
                },
                icon: Icon(
                  Icons.share,
                  color: Colors.white,
                ),
                label: Text("")),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var quotesProvider = Provider.of<SavedQuotes>(context);

    if (_quote == null) {
      var args =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      _quote = args['quote'];
      _theme = QuoteTheme.getThemeById(_quote.themeId);
    }

    return Stack(
      children: <Widget>[
        Scaffold(
            backgroundColor: _theme.backgroundColor,
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            body: Container(
              child: Column(
                children: <Widget>[
                  Flexible(
                    child: _buildQuoteBody(),
                  ),
                  _buildBottomMenu(context, quotesProvider),
                  SizedBox(
                    height: _screenPadding,
                  )
                ],
              ),
            )),
        SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: _screenPadding),
            alignment: Alignment.topRight,
            child: _buildSavedMarker(quotesProvider),
          ),
        ),
      ],
    );
  }
}
