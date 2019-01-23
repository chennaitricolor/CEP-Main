class PageModel {
  final String assetImagePath;
  final String text;
  PageModel({this.assetImagePath, this.text});
}

List<PageModel> pages = [
  PageModel(
    assetImagePath: 'assets/images/logo/nammachennai.png',
    text: 'Vanakkam to Namma Chennai!',
  ),
  PageModel(
    assetImagePath: 'assets/images/logo/corporationofchennai.png',
    text: 'An Initiative by Chennai Corporation',
  ),
  PageModel(
    assetImagePath: 'assets/images/logo/smartcities.png',
    text: 'In Collaboration with Smart Cities',
  ),
  PageModel(
      assetImagePath: 'assets/images/logo/techforcities.png',
      text: 'Powered by Tech for Cities'
  ),
];