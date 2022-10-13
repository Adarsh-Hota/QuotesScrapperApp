import 'package:flutter/material.dart';
import 'package:quotes_app/quotes_page/quotes_screen.dart';
import 'package:quotes_app/utils.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> quotes = [];
  List<String> authors = [];
  bool isDataThere = false;

  @override
  void initState() {
    super.initState();
    getQuotes();
  }

  Future<void> getQuotes() async {
    String url = 'https://quotes.toscrape.com/';
    Uri uri = Uri.parse(url);
    http.Response response = await http.get(uri);
    dom.Document document = parser.parse(response.body);
    final quotesClass = document.getElementsByClassName('quote');
    quotes = quotesClass
        .map((ele) => ele.getElementsByClassName('text')[0].innerHtml)
        .toList();
    authors = quotesClass
        .map((ele) => ele.getElementsByClassName('author')[0].innerHtml)
        .toList();
    setState(() {
      isDataThere = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(slivers: [
      SliverToBoxAdapter(
          child: Column(children: [
        Container(
          margin: const EdgeInsets.only(top: 40, bottom: 20),
          child: Text(
            'Quotes App',
            style: textStyle(25, Colors.black, FontWeight.w700),
          ),
        ),
      ])),
      SliverGrid.count(
          crossAxisCount: 2,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          children: categories.map((category) {
            return InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuotesPage(category: category))),
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: Text(
                      category.toUpperCase(),
                      style: textStyle(18, Colors.white, FontWeight.bold),
                    ),
                  ),
                ),
              ),
            );
          }).toList()),
      isDataThere == false
          ? const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()))
          : SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
              return Container(
                margin: const EdgeInsets.all(8),
                child: Card(
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          quotes[index],
                          style: textStyle(
                            18,
                            Colors.grey[600]!,
                            FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          authors[index],
                          style:
                              textStyle(18, Colors.blueGrey, FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }, childCount: quotes.length))
    ]));
  }
}
