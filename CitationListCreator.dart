import 'queryFunc.dart';
import 'package:tuple/tuple.dart';

Future<List<Tuple2<String, String>>> getListOfCitations(Future<Map<String, dynamic>> apiJsonResponse) async {
  final tmp = (await apiJsonResponse)["results"];
  List<Tuple2<String, String>> result = [];
  for (int i = 0; i < tmp.length; ++i)
    result.add(Tuple2<String, String>(tmp[i]["name_abbreviation"]
      + " (${tmp[i]['decision_date'].substring(0, 4)})",
      tmp[i]['frontend_pdf_url']));
  return result;
}
