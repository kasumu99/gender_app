class UserReportModel{
  String _reportName = "";
  String _reportDescription = "";
  bool _isAnonymously = true;
  List<String> _imageUrl = [];

  String get reportName => _reportName;

  set reportName(String value) {
    _reportName = value;
  }

  String get reportDescription => _reportDescription;

  List<String> get imageUrl => _imageUrl;

  set imageUrl(List<String> value) {
    _imageUrl = value;
  }

  bool get isAnonymously => _isAnonymously;

  set isAnonymously(bool value) {
    _isAnonymously = value;
  }

  set reportDescription(String value) {
    _reportDescription = value;
  }
}