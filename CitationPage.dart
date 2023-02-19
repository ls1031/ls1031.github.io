import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:ui';
import 'dart:js' as js;
import 'package:tuple/tuple.dart';

// TODO: make styling standard instead of having magic numbers throughout code
// TODO: can return types be made more specific than Widget for greater type
// safety?

final ThemeData citationsPageThemeData = ThemeData (
  canvasColor: Colors.grey[50],
);

class CitationsPage extends StatefulWidget {
  final Future<List<Tuple2<String, String>>> citedCases;
  final List<String> caseCitations;
  void Function(String) metaMutator;

  CitationsPage({super.key, required this.citedCases,
    required this.caseCitations, required this.metaMutator});

  @override
  State<CitationsPage> createState() => CitationsPageState(
    citedCases: citedCases,
    caseCitations: caseCitations,
    metaMutator: metaMutator,
  );
}

class CitationsPageState extends State<CitationsPage> {
  final Future<List<Tuple2<String, String>>> citedCases;
  final List<String> caseCitations;
  void Function(String) metaMutator;

  CitationsPageState({required this.citedCases, required this.caseCitations,
    required this.metaMutator});
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Tuple2<String, String>>>(
      future: citedCases,
      builder: (BuildContext context, AsyncSnapshot<List<Tuple2<String, String>>> snapshot) {
        if (snapshot.hasData) {
          return getGeneratedWidget(snapshot.data ?? List.filled(0, Tuple2<String, String>('', '')),
            caseCitations, metaMutator);
        }
        else {
          return CircularProgressIndicator();
        }
      }
    );
  }
}

Widget getGeneratedWidget(List<Tuple2<String, String>> casesCited,
  List<String> caseCitations, void Function(String) metaMutator) {
  return Scaffold(
    body: Column(
      children: [
        Divider ( color: citationsPageThemeData.canvasColor ),
        Expanded ( child: getCitationElementTuple("Cites", casesCited,
          metaMutator)),
        Expanded ( child: getCitationElement("Cited by", caseCitations,
          metaMutator)),
      ]
    )
  );
}

Widget getHeaderText(String header) {
  return Text(
    '${header}',
    style: const TextStyle(
      color: Colors.black,
      decoration: TextDecoration.none,
      fontSize: 32,
      height: 1.1,
    ),
  );
}

Widget getCitationElementTuple(String name, List<Tuple2<String, String>>
  listElements, void Function(String) metaMutator) {
  return Column (
    children: [
      Container ( child: getHeaderText(name) ),
      Expanded ( child: getListViewTuple(listElements, metaMutator)),
    ]
  );
}

Widget getCitationElement(String name, List<String> listElements,
  void Function(String) metaMutator) {
  return Column (
    children: [
      Container ( child: getHeaderText(name)),
      Expanded ( child: getListView(listElements, metaMutator) ),
    ],
  );
}

class HoverBoldedListElement extends StatefulWidget {
  final String text;

  const HoverBoldedListElement({super.key, required this.text});

  @override
  State<HoverBoldedListElement> createState()
    => HoverBoldedListElementState(text);
}

class HoverBoldedListElementState extends State<HoverBoldedListElement> {
  final String text;
  bool isBold = false;

  HoverBoldedListElementState(this.text);

  void makeBold(PointerEvent details) {
    setState(() {
      isBold = true;
    });
  }
  
  void makeUnbold(PointerEvent details) {
    setState(() {
      isBold = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MouseRegion (
      onEnter: makeBold,
      onExit: makeUnbold,
      child: getTextContainer(text, isBold),
    );
  }
}

Widget getTextContainer(String text, bool isBold) {
  return Container (
    child: Text(
      '${text}',
      style: TextStyle(
        color: Colors.black,
        decoration: TextDecoration.none,
        fontSize: 20,
        height: 1.1,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      ),
    ),
    padding: const EdgeInsets.all(8.0),
  );
}

typedef void Callback();

class ClickableElement extends StatefulWidget {
  final Callback tapCallback;
  Widget child;
  
  ClickableElement({super.key, required this.tapCallback,
    required this.child});

  @override
  State<ClickableElement> createState() => ClickableElementState(
    tapCallback: tapCallback,
    child: child,
  );
}

class ClickableElementState extends State<ClickableElement> {
  final Callback tapCallback;
  Widget child;
  
  ClickableElementState({required this.tapCallback,
    required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector (
      onTap: tapCallback,
      child: child,
    );
  }
}

Widget getListElement(String name, void Function(String) metaMutator) {
  return Container (
    child: ClickableElement(
      tapCallback: () {
          //js.context.callMethod('open', url);
          metaMutator(name);
        },
      child: HoverBoldedListElement(text: name),
    ),
  );
}

Widget getListElementWithUrl(String name, String url,
  void Function(String) metaMutator) {
  return Container (
    child: ClickableElement(
      tapCallback: () {
          js.context.callMethod('open', List.filled(1, url));
          metaMutator(name);
        },
      child: HoverBoldedListElement(text: name),
    ),
  );
}

Widget getListViewTuple(List<Tuple2<String, String>> listElements, void Function(String) metaMutator) {
  return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: listElements.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 40,
          color: citationsPageThemeData.canvasColor,
          child: getListElementWithUrl(listElements[index].item1,
            listElements[index].item2, metaMutator),
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(
        color: citationsPageThemeData.canvasColor,
      ),
  );
}

Widget getListView(List<String> listElements, void Function(String) metaMutator) {
  return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: listElements.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 40,
          color: citationsPageThemeData.canvasColor,
          child: getListElement(listElements[index], metaMutator),
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(
        color: citationsPageThemeData.canvasColor,
      ),
  );
}
