

class ItunesSearchResultModel {
  int resultCount;
  List<iTunesSearchResults> results;

  ItunesSearchResultModel({this.resultCount, this.results});

  ItunesSearchResultModel.fromJson(Map<String, dynamic> json) {
    resultCount = json['resultCount'];
    if (json['results'] != null) {
      results = new List<iTunesSearchResults>();
      json['results'].forEach((v) {
        results.add(new iTunesSearchResults.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resultCount'] = this.resultCount;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'ItunesSearchResultModel{resultCount: $resultCount, results: $results}';
  }


}

class iTunesSearchResults {
  String wrapperType;
  String kind;
  int artistId;
  int collectionId;
  int trackId;
  String artistName;
  String collectionName;
  String trackName;
  String collectionCensoredName;
  String trackCensoredName;
  String artistViewUrl;
  String collectionViewUrl;
  String feedUrl;
  String trackViewUrl;
  String artworkUrl30;
  String artworkUrl60;
  String artworkUrl100;
  double collectionPrice;
  double trackPrice;
  double trackRentalPrice;
  double collectionHdPrice;
  double trackHdPrice;
  double trackHdRentalPrice;
  String releaseDate;
  String collectionExplicitness;
  String trackExplicitness;
  int trackCount;
  String country;
  String currency;
  String primaryGenreName;
  String contentAdvisoryRating;
  String artworkUrl600;
  List<String> genreIds;
  List<String> genres;
  bool isFavorited = false;

  iTunesSearchResults(
      {this.wrapperType,
      this.kind,
      this.artistId,
      this.collectionId,
      this.trackId,
      this.artistName,
      this.collectionName,
      this.trackName,
      this.collectionCensoredName,
      this.trackCensoredName,
      this.artistViewUrl,
      this.collectionViewUrl,
      this.feedUrl,
      this.trackViewUrl,
      this.artworkUrl30,
      this.artworkUrl60,
      this.artworkUrl100,
      this.collectionPrice,
      this.trackPrice,
      this.trackRentalPrice,
      this.collectionHdPrice,
      this.trackHdPrice,
      this.trackHdRentalPrice,
      this.releaseDate,
      this.collectionExplicitness,
      this.trackExplicitness,
      this.trackCount,
      this.country,
      this.currency,
      this.primaryGenreName,
      this.contentAdvisoryRating,
      this.artworkUrl600,
      this.genreIds,
      this.genres,
      this.isFavorited});

  iTunesSearchResults.fromJson(Map<String, dynamic> json) {
    wrapperType = json['wrapperType'];
    kind = json['kind'];
    artistId = json['artistId'];
    collectionId = json['collectionId'];
    trackId = json['trackId'];
    artistName = json['artistName'];
    collectionName = json['collectionName'];
    trackName = json['trackName'];
    collectionCensoredName = json['collectionCensoredName'];
    trackCensoredName = json['trackCensoredName'];
    artistViewUrl = json['artistViewUrl'];
    collectionViewUrl = json['collectionViewUrl'];
    feedUrl = json['feedUrl'];
    trackViewUrl = json['trackViewUrl'];
    artworkUrl30 = json['artworkUrl30'];
    artworkUrl60 = json['artworkUrl60'];
    artworkUrl100 = json['artworkUrl100'];
//    collectionPrice =  json['collectionPrice'] is int ? (json['collectionPrice'] as int).toDouble(): json['collectionPrice'];
//    trackPrice = json['trackPrice'];
//    trackRentalPrice = json['trackRentalPrice'];
//    collectionHdPrice = json['collectionHdPrice'];
//    trackHdPrice = json['trackHdPrice'];
//    trackHdRentalPrice = json['trackHdRentalPrice'];
    releaseDate = json['releaseDate'];
    collectionExplicitness = json['collectionExplicitness'];
    trackExplicitness = json['trackExplicitness'];
    trackCount = json['trackCount'];
    country = json['country'];
    currency = json['currency'];
    primaryGenreName = json['primaryGenreName'];
    contentAdvisoryRating = json['contentAdvisoryRating'];
    artworkUrl600 = json['artworkUrl600'];
    genreIds = json['genreIds'].cast<String>();
    genres = json['genres'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wrapperType'] = this.wrapperType;
    data['kind'] = this.kind;
    data['artistId'] = this.artistId;
    data['collectionId'] = this.collectionId;
    data['trackId'] = this.trackId;
    data['artistName'] = this.artistName;
    data['collectionName'] = this.collectionName;
    data['trackName'] = this.trackName;
    data['collectionCensoredName'] = this.collectionCensoredName;
    data['trackCensoredName'] = this.trackCensoredName;
    data['artistViewUrl'] = this.artistViewUrl;
    data['collectionViewUrl'] = this.collectionViewUrl;
    data['feedUrl'] = this.feedUrl;
    data['trackViewUrl'] = this.trackViewUrl;
    data['artworkUrl30'] = this.artworkUrl30;
    data['artworkUrl60'] = this.artworkUrl60;
    data['artworkUrl100'] = this.artworkUrl100;
    data['collectionPrice'] = this.collectionPrice;
    data['trackPrice'] = this.trackPrice;
    data['trackRentalPrice'] = this.trackRentalPrice;
    data['collectionHdPrice'] = this.collectionHdPrice;
    data['trackHdPrice'] = this.trackHdPrice;
    data['trackHdRentalPrice'] = this.trackHdRentalPrice;
    data['releaseDate'] = this.releaseDate;
    data['collectionExplicitness'] = this.collectionExplicitness;
    data['trackExplicitness'] = this.trackExplicitness;
    data['trackCount'] = this.trackCount;
    data['country'] = this.country;
    data['currency'] = this.currency;
    data['primaryGenreName'] = this.primaryGenreName;
    data['contentAdvisoryRating'] = this.contentAdvisoryRating;
    data['artworkUrl600'] = this.artworkUrl600;
    data['genreIds'] = this.genreIds;
    data['genres'] = this.genres;
    data['isFavorited'] = this.isFavorited;
    return data;
  }

  @override
  String toString() {
    return 'iTunesSearchResults{wrapperType: $wrapperType, kind: $kind, artistId: $artistId, collectionId: $collectionId, trackId: $trackId, artistName: $artistName, collectionName: $collectionName, trackName: $trackName, collectionCensoredName: $collectionCensoredName, trackCensoredName: $trackCensoredName, artistViewUrl: $artistViewUrl, collectionViewUrl: $collectionViewUrl, feedUrl: $feedUrl, trackViewUrl: $trackViewUrl, artworkUrl30: $artworkUrl30, artworkUrl60: $artworkUrl60, artworkUrl100: $artworkUrl100, collectionPrice: $collectionPrice, trackPrice: $trackPrice, trackRentalPrice: $trackRentalPrice, collectionHdPrice: $collectionHdPrice, trackHdPrice: $trackHdPrice, trackHdRentalPrice: $trackHdRentalPrice, releaseDate: $releaseDate, collectionExplicitness: $collectionExplicitness, trackExplicitness: $trackExplicitness, trackCount: $trackCount, country: $country, currency: $currency, primaryGenreName: $primaryGenreName, contentAdvisoryRating: $contentAdvisoryRating, artworkUrl600: $artworkUrl600, genreIds: $genreIds, genres: $genres}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is iTunesSearchResults &&
              runtimeType == other.runtimeType &&
              trackId == other.trackId &&
              artistName == other.artistName &&
              collectionName == other.collectionName &&
              trackName == other.trackName;

  @override
  int get hashCode =>
      trackId.hashCode ^
      artistName.hashCode ^
      collectionName.hashCode ^
      trackName.hashCode;



}
