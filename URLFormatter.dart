const String FindlawUrlStem = "https://caselaw.findlaw.com/";
const String FindlawScotusExtension = "us-supreme-court/"
String getFindlawUrl(String citation) {
  final List<String> splittedString = citation.split(' ');
  return FindlawUrlStem + FindlawScotusExtension + splittedString[0] + '/'
    + splittedString[2] + '.html';
}
