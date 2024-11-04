import 'dart:math';

class MemesService {
  List<String> _memesUrl = [
    "https://memeprod.sgp1.digitaloceanspaces.com/user-wtf/1718002368189.jpg",
    "https://memeprod.sgp1.digitaloceanspaces.com/user-wtf/1718956905380.jpg",
    "https://memeprod.sgp1.digitaloceanspaces.com/user-wtf/1718945611062.jpg",
  ];
  
  String getMemes() {
    final random = Random();
    int randomIndex = random.nextInt(_memesUrl.length);
    return _memesUrl[randomIndex];
  }
}