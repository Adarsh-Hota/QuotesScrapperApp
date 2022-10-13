import 'package:flutter/material.dart';
import 'package:quotes_app/utils.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class QuotesPage extends StatefulWidget {
  final String category;

  const QuotesPage({Key? key, required this.category}) : super(key: key);

  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  List<String> quotes = [];
  List<String> authors = [];
  bool isDataThere = false;

  @override
  void initState() {
    super.initState();
    getQuotes();
  }

  Future<void> getQuotes() async {
    String url = 'https://quotes.toscrape.com/tag/${widget.category}/';
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
        body: isDataThere == false
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(slivers: [
                SliverToBoxAdapter(
                    child: Column(children: [
                  Container(
                    margin: const EdgeInsets.only(top: 40, bottom: 20),
                    child: Text(
                      '${widget.category} quotes'.toUpperCase(),
                      style: textStyle(25, Colors.black, FontWeight.w700),
                    ),
                  ),
                ])),
                SliverList(
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
                              style: textStyle(
                                  18, Colors.blueGrey, FontWeight.w700),
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
