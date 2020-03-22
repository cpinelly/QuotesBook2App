import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/Quote.dart';
import '../providers/saved_quotes.dart';
import 'package:google_fonts/google_fonts.dart';

class QuoteListItem extends StatelessWidget {
  Quote quote;

  QuoteListItem(this.quote);
  static final quoteFontSize = 27.0;
  static final authorFontSize = quoteFontSize * 0.57;
  static final authorDescriptionFontSize = quoteFontSize * 0.40;

  @override
  Widget build(BuildContext context) {

    var quotesProvider = Provider.of<SavedQuotes>(context, listen: false);

    return Container(
      padding: EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 0),
      width: double.infinity,
      child: Card(
        color: Colors.orange,
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                width: double.infinity,
                child: Text(
                  quote.body,
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(fontSize: quoteFontSize, fontWeight: FontWeight.bold)
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                color: Colors.black,
                height: 3.0,
                width: 30,
              ),
              SizedBox(
                height: 5,
              ),
              Container(                
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      '${quote.author.firstName} ${quote.author.lastName},',
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(fontSize: authorFontSize)
                      ),
                      textAlign: TextAlign.right,                      
                    ),
                    Text(
                      quote.author.shortDescription + ".",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          fontSize: authorDescriptionFontSize
                        )
                      ),
                      textAlign: TextAlign.right,                    
                    ),
                    /*
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(
                              Icons.star,
                              color:
                                  quote.isFavorite ? Colors.amber : Colors.grey,
                            ),
                            onPressed: () {
                              if (quote.isFavorite){
                                quotesProvider.removeQuote(quote);
                              }else {
                                quotesProvider.saveQuote(quote);
                              }
                              
                            })
                      ],
                    )
                    */
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
