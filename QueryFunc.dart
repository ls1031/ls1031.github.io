import 'dart:convert' as convert;
import 'dart:async';
// For this function to work, you need to add the http
// dependency to pubspec.yaml
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

// class FutureKiller extends StatefulWidget {
//   final String searchValue;
//   final String endParameter;
// 
//   const FutureKiller({super.key, required this.searchValue,
//     required this.endParameter});
// 
//   @override
//   State<FutureKiller> createState() => FutureKillerState(
//     searchValue: searchValue,
//     endParameter: endParameter
//   );
// }
// 
// class FutureKillerState extends State<FutureKiller> {
//   final String searchValue;
//   final String endParameter;
//   Map<String, dynamic> result = Map<String, dynamic>();
//   final Future<Map<String, dynamic>> promise;
// 
//   const FutureKillerState({super.key, required this.searchValue,
//     required this.endParameter})
//     : promise = querySearch(searchValue, endParameter).then((queryResult) {
//       setState(() => result = queryResult);
//     });
// }
// 
//Map<String, dynamic> forceSync(String searchValue, String endParameter) {
//  Map<String, dynamic> result = Map<String, dynamic>();
//  querySearch(searchValue, endParameter).then((queryResult) {
//    print("FUCK FUCK FUCK");
//    // print(queryResult);
//    result = queryResult;
//    assert(!result.isEmpty);
//  });
//  assert(!result.isEmpty);
//  return result;
//}

Future<Map<String, dynamic>> querySearch(String searchValue, String endParameter) async {
  var url =
  Uri.https('api.case.law', '/v1/cases/', {endParameter: searchValue});

  // Await the http get response, then decode the json-formatted response.
  final response = await http.get(
      url
    // Send authorization headers to the backend.
    // headers: {
    //   HttpHeaders.authorizationHeader: 'token',
    // },
  );
  if (response.statusCode == 200) {
    var searchRes =
    convert.jsonDecode(response.body) as Map<String, dynamic>;
    // Prints API Call results to console
    return searchRes;
  } else {
    print('Request failed with status: ${response.statusCode}.');
    throw http.ClientException;
  }
}

Future<Tuple2<List<String>, Map<String, dynamic>>> fetchSuggestions(String searchValue, String endParameter) async {
  final searchRes = await querySearch(searchValue, endParameter);
  List<String> _suggestions = [];
  for(int i = 0; i < searchRes["results"].length; i++) {
    _suggestions.add("$i " + searchRes["results"][i]["name"]);
  }
  return Tuple2<List<String>, Map<String, dynamic>>(_suggestions, searchRes);
}
