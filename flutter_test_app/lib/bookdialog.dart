import "package:flutter/material.dart";
import 'dart:async';
import "package:http/http.dart";
import "dart:convert";
import "globals.dart" as globals;
import "timer.dart";

class SelectBookDialog extends StatefulWidget {
  List<Widget> results = [];
  final Function() updateParent;

  SelectBookDialog({Key key, @required this.updateParent}) : super(key: key);


  @override
  _SelectBookDialogState createState() => _SelectBookDialogState();
}

class _SelectBookDialogState extends State<SelectBookDialog> {

  String searchText;
  int customNumberOfPages;

  void getSearchResult(text) async {
    Response response = await get("https://www.googleapis.com/books/v1/volumes?q=$text");
    Map data = jsonDecode(response.body);


   // print(data);
    widget.results.clear();

   // print("items: ${data["totalItems"]}");
   //  print("Thumb: ${data["items"][0]["volumeInfo"]["imageLinks"]["smallThumbnail"]}");
    int count = (data["totalItems"] < 10) ? data["itemCount"] : 10;

    for (int i = 0; i < count; i++){
     // print(data["items"][i]["volumeInfo"]["title"]);
     // print("$i: ${data["items"][i]}");
      if (data["items"][i] != null) {
        Map book = data["items"][i];
        widget.results.add(SelectBook(book, widget.updateParent));
      }
    }


    //print(data);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3),
      ),

      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height / 2,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: const Offset(0, 10)
            ),
          ],
        ),

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[

              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Search for book/author"
                ),

                onChanged: (text){
                  searchText = text;

                  getSearchResult(text);

                  print(text);
                },

              ),

              SizedBox(height: 4,),

              Flexible(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1
                    ),
                  borderRadius: BorderRadius.circular(3),
                  ),

                  child:  ListView.builder(
                    addAutomaticKeepAlives: false,
                    cacheExtent: 1000,

                    itemCount: widget.results.length,
                    itemBuilder: (BuildContext context, int index){
                      return widget.results[index];
                    },
                  ),
                ),
              ),


              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    onPressed: (){
                      Navigator.of(context).pop(); // Close dialog
                    },
                    child: Text("Cancel")
                  ),

                  FlatButton(
                    onPressed: (){
                      if (searchText != "" && searchText != null) {
                        customNumberOfPages = 0;
                        showDialog(
                          context: (context),
                          builder: (BuildContext buildcontext) => Dialog(
                            child: Container(
                              height: 130,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 10,
                                      offset: const Offset(0, 10)
                                  ),
                                ],
                              ),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: "Number of pages"
                                      ),

                                      keyboardType: TextInputType.number,

                                      onChanged: (text){
                                        customNumberOfPages = int.parse(text);
                                      },

                                    ),
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      FlatButton(
                                        child: Text("Back"),
                                        onPressed: (){
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      FlatButton(
                                        child: Text("Confirm"),
                                        onPressed: (){
                                          if (customNumberOfPages != null) {
                                            globals.timers.add(BookTimer(searchText, "assets/placeholderbook.jpg", customNumberOfPages, widget.updateParent));
                                            widget.updateParent();
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          }
                                        },
                                      ),
                                    ],
                                  )

                                ],
                              ),
                            ),
                          )
                        );
                      }
                    },
                    child: Text("Add Custom"),
                  )
                ],
              )
            ],
          ),
        )
      ),
    );
  }
}








class SelectBook extends StatefulWidget {
  String name = "Book";
  String thumbnailURL = "assets/placeholderbook.jpg";

  int pages = 0;

  Function() updateParent;

  SelectBook(Map book, Function() updateParent){

    this.name = book["volumeInfo"]["title"];
    //print("The book's name: ${this.name}");
    try {
      this.thumbnailURL = book["volumeInfo"]["imageLinks"]["smallThumbnail"];
     // print("The book's thumb: ${this.thumbnailURL}");
    } on NoSuchMethodError{
      print("Couldn't get book thumbnail");
    }
    this.updateParent = updateParent;

    this.pages = book["volumeInfo"]["pageCount"];

    //print("The name of this book is ${this.name}");
  }

  @override
  _SelectBookState createState() => _SelectBookState();
}

class _SelectBookState extends State<SelectBook> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

        globals.timers.add(BookTimer(widget.name, widget.thumbnailURL, widget.pages, widget.updateParent));

        widget.updateParent();

        Navigator.of(context).pop();
      },

      child: Card(
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: FadeInImage.assetNetwork(
                  placeholder: "assets/placeholderbook.jpg",
                  image: widget.thumbnailURL,
                  width:  MediaQuery.of(context).size.height / 15
              ),
            ),
            SizedBox(width: 10),
            Flexible(
                flex: 4,
                child: Text(widget.name)
            )
          ],
        ),
      ),
    );
  }
}

