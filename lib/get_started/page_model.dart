class PageModel {
  final String assetImagePath;
  final String text;
  PageModel({this.assetImagePath, this.text});
}

List<PageModel> pages = [
  PageModel(
    assetImagePath: 'assets/images/tfclogo.png',
    text: 'Welcome to Namma Chennai!',
  ),
  PageModel(
    assetImagePath: 'assets/images/csklogo.png',
    text: 'Together Lets Bring a Change',
  ),
  PageModel(
      assetImagePath: 'assets/images/csklogo.png',
      text: 'Build Apps and Publish'),
  PageModel(
      assetImagePath: 'assets/images/csklogo.png',
      text: 'Let get started'),
];