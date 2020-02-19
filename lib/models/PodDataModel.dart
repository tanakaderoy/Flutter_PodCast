class PodDataModel {
  String version;
  String encoding;
  Rss rss;

  PodDataModel({this.version, this.encoding, this.rss});

  PodDataModel.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    encoding = json['encoding'];
    rss = json['rss'] != null ? new Rss.fromJson(json['rss']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['encoding'] = this.encoding;
    if (this.rss != null) {
      data['rss'] = this.rss.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'PodDataModel{version: $version, encoding: $encoding, rss: $rss}';
  }

}

class Rss {
  String version;
  String xmlnsAtom;
  String xmlnsItunes;
  String xmlnsMedia;
  String xmlnsAcast;
  String xmlnsPodaccess;
  String xmlnsPingback;
  Channel channel;

  Rss({this.version, this.xmlnsAtom, this.xmlnsItunes, this.xmlnsMedia, this.xmlnsAcast, this.xmlnsPodaccess, this.xmlnsPingback, this.channel});

  Rss.fromJson(Map<String, dynamic> json) {
    version = json['version'];

    xmlnsAtom = json['xmlns\$atom'];
    xmlnsItunes = json['xmlns\$itunes'];
    xmlnsMedia = json['xmlns\$media'];
    xmlnsAcast = json['xmlns\$acast'];
    xmlnsPodaccess = json['xmlns\$podaccess'];
    xmlnsPingback = json['xmlns\$pingback'];
    channel = json['channel'] != null ? new Channel.fromJson(json['channel']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;

    data['xmlns\$atom'] = this.xmlnsAtom;
    data['xmlns\$itunes'] = this.xmlnsItunes;
    data['xmlns\$media'] = this.xmlnsMedia;
    data['xmlns\$acast'] = this.xmlnsAcast;
    data['xmlns\$podaccess'] = this.xmlnsPodaccess;
    data['xmlns\$pingback'] = this.xmlnsPingback;
    if (this.channel != null) {
      data['channel'] = this.channel.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'Rss{version: $version, xmlnsAtom: $xmlnsAtom, xmlnsItunes: $xmlnsItunes, xmlnsMedia: $xmlnsMedia, xmlnsAcast: $xmlnsAcast, xmlnsPodaccess: $xmlnsPodaccess, xmlnsPingback: $xmlnsPingback, channel: $channel}';
  }

}



class Channel {
  Title title;
  Description description;
  Title acastShowId;
  Title acastShowUrl;
  Title link;
//  AtomLink atomLink;
  Title pingbackReceiver;
  Title lastBuildDate;
  Title pubDate;
  Title ttl;
  Title language;
  Description copyright;
  Title docs;
  AcastSignature acastSignature;
  AcastNetwork acastNetwork;
  Description acastSettings;
  PodDataImage image;
  ItunesPodDataImage itunesPodDataImage;
  Title itunesSubtitle;
  Title itunesType;
  Title itunesAuthor;
  Description itunesSummary;
  ItunesOwner itunesOwner;
  Title itunesExplicit;
//  ItunesCategory itunesCategory;
  MediaCredit mediaCredit;
  MediaDescription mediaDescription;
  List<Item> item;

  Channel({this.title, this.description, this.acastShowId, this.acastShowUrl, this.link, this.pingbackReceiver, this.lastBuildDate, this.pubDate, this.ttl, this.language, this.copyright, this.docs, this.acastSignature, this.acastNetwork, this.acastSettings, this.image, this.itunesPodDataImage, this.itunesSubtitle, this.itunesType, this.itunesAuthor, this.itunesSummary, this.itunesOwner, this.itunesExplicit, this.mediaCredit, this.mediaDescription, this.item});

  Channel.fromJson(Map<String, dynamic> json) {
    title = json['title'] != null ? new Title.fromJson(json['title']) : null;
    description = json['description'] != null ? new Description.fromJson(json['description']) : null;
    acastShowId = json['acast\$showId'] != null ? new Title.fromJson(json['acast\$showId']) : null;
    acastShowUrl = json['acast\$showUrl'] != null ? new Title.fromJson(json['acast\$showUrl']) : null;
    link = json['link'] != null ? new Title.fromJson(json['link']) : null;
//    atomLink = json['atom\$link'] != null ? new AtomLink.fromJson(json['atom\$link']) : null;
    pingbackReceiver = json['pingback\$receiver'] != null ? new Title.fromJson(json['pingback\$receiver']) : null;
    lastBuildDate = json['lastBuildDate'] != null ? new Title.fromJson(json['lastBuildDate']) : null;
    pubDate = json['pubDate'] != null ? new Title.fromJson(json['pubDate']) : null;
    ttl = json['ttl'] != null ? new Title.fromJson(json['ttl']) : null;
    language = json['language'] != null ? new Title.fromJson(json['language']) : null;
    copyright = json['copyright'] != null ? new Description.fromJson(json['copyright']) : null;
    docs = json['docs'] != null ? new Title.fromJson(json['docs']) : null;
    acastSignature = json['acast\$signature'] != null ? new AcastSignature.fromJson(json['acast\$signature']) : null;
    acastNetwork = json['acast\$network'] != null ? new AcastNetwork.fromJson(json['acast\$network']) : null;
    acastSettings = json['acast\$settings'] != null ? new Description.fromJson(json['acast\$settings']) : null;
    image = json['image'] != null ? new PodDataImage.fromJson(json['image']) : null;
    itunesPodDataImage = json['itunes\$image'] != null ? new ItunesPodDataImage.fromJson(json['itunes\$image']) : null;
    itunesSubtitle = json['itunes\$subtitle'] != null ? new Title.fromJson(json['itunes\$subtitle']) : null;
    itunesType = json['itunes\$type'] != null ? new Title.fromJson(json['itunes\$type']) : null;
    itunesAuthor = json['itunes\$author'] != null ? new Title.fromJson(json['itunes\$author']) : null;
    itunesSummary = json['itunes\$summary'] != null ? new Description.fromJson(json['itunes\$summary']) : null;
    itunesOwner = json['itunes\$owner'] != null ? new ItunesOwner.fromJson(json['itunes\$owner']) : null;
    itunesExplicit = json['itunes\$explicit'] != null ? new Title.fromJson(json['itunes\$explicit']) : null;
//    itunesCategory = json['itunes\$category'] != null ? new ItunesCategory.fromJson(json['itunes\$category']) : null;
    mediaCredit = json['media\$credit'] != null ? new MediaCredit.fromJson(json['media\$credit']) : null;
    mediaDescription = json['media\$description'] != null ? new MediaDescription.fromJson(json['media\$description']) : null;
    if (json['item'] != null) {
      item = new List<Item>();
      json['item'].forEach((v) { item.add(new Item.fromJson(v)); });
    }
  }

  @override
  String toString() {
    return 'Channel{title: $title, description: $description, acastShowId: $acastShowId, acastShowUrl: $acastShowUrl, link: $link, pingbackReceiver: $pingbackReceiver, lastBuildDate: $lastBuildDate, pubDate: $pubDate, ttl: $ttl, language: $language, copyright: $copyright, docs: $docs, acastSignature: $acastSignature, acastNetwork: $acastNetwork, acastSettings: $acastSettings, image: $image, itunesPodDataImage: $itunesPodDataImage, itunesSubtitle: $itunesSubtitle, itunesType: $itunesType, itunesAuthor: $itunesAuthor, itunesSummary: $itunesSummary, itunesOwner: $itunesOwner, itunesExplicit: $itunesExplicit , mediaCredit: $mediaCredit, mediaDescription: $mediaDescription, item: $item}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.title != null) {
      data['title'] = this.title.toJson();
    }
    if (this.description != null) {
      data['description'] = this.description.toJson();
    }
    if (this.acastShowId != null) {
      data['acast\$showId'] = this.acastShowId.toJson();
    }
    if (this.acastShowUrl != null) {
      data['acast\$showUrl'] = this.acastShowUrl.toJson();
    }
    if (this.link != null) {
      data['link'] = this.link.toJson();
    }

    if (this.pingbackReceiver != null) {
      data['pingback\$receiver'] = this.pingbackReceiver.toJson();
    }
    if (this.lastBuildDate != null) {
      data['lastBuildDate'] = this.lastBuildDate.toJson();
    }
    if (this.pubDate != null) {
      data['pubDate'] = this.pubDate.toJson();
    }
    if (this.ttl != null) {
      data['ttl'] = this.ttl.toJson();
    }
    if (this.language != null) {
      data['language'] = this.language.toJson();
    }
    if (this.copyright != null) {
      data['copyright'] = this.copyright.toJson();
    }
    if (this.docs != null) {
      data['docs'] = this.docs.toJson();
    }
    if (this.acastSignature != null) {
      data['acast\$signature'] = this.acastSignature.toJson();
    }
    if (this.acastNetwork != null) {
      data['acast\$network'] = this.acastNetwork.toJson();
    }
    if (this.acastSettings != null) {
      data['acast\$settings'] = this.acastSettings.toJson();
    }
    if (this.image != null) {
      data['image'] = this.image.toJson();
    }
    if (this.itunesPodDataImage != null) {
      data['itunes\$image'] = this.itunesPodDataImage.toJson();
    }
    if (this.itunesSubtitle != null) {
      data['itunes\$subtitle'] = this.itunesSubtitle.toJson();
    }
    if (this.itunesType != null) {
      data['itunes\$type'] = this.itunesType.toJson();
    }
    if (this.itunesAuthor != null) {
      data['itunes\$author'] = this.itunesAuthor.toJson();
    }
    if (this.itunesSummary != null) {
      data['itunes\$summary'] = this.itunesSummary.toJson();
    }
    if (this.itunesOwner != null) {
      data['itunes\$owner'] = this.itunesOwner.toJson();
    }
    if (this.itunesExplicit != null) {
      data['itunes\$explicit'] = this.itunesExplicit.toJson();
    }
//    if (this.itunesCategory != null) {
//      data['itunes\$category'] = this.itunesCategory.toJson();
//    }
    if (this.mediaCredit != null) {
      data['media\$credit'] = this.mediaCredit.toJson();
    }
    if (this.mediaDescription != null) {
      data['media\$description'] = this.mediaDescription.toJson();
    }
    if (this.item != null) {
      data['item'] = this.item.map((v) => v.toJson()).toList();
    }
    return data;
  }

}

class Title {
  String t;

  @override
  String toString() {
    return t;
  }

  Title({this.t});

  Title.fromJson(Map<String, dynamic> json) {
    t = json['\$t'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['\$t'] = this.t;
    return data;
  }

}

class Description {
  String sCdata;

  Description({this.sCdata});

  Description.fromJson(Map<String, dynamic> json) {
    sCdata = json['__cdata'];
  }


  @override
  String toString() {
    RegExp exp = RegExp(
        r"<[^>]*>|/\u00a0/",
        multiLine: true,
        caseSensitive: true
    );

    RegExp exp2 = RegExp(
     r"/\u00a0/",
      multiLine: true,
      caseSensitive: true
    );
    var noHTMLTags = sCdata.replaceAll(exp, "");

    var noBreakSpace = noHTMLTags.replaceAll(exp2, " ");
    return  noBreakSpace;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__cdata'] = this.sCdata;
    return data;
  }

}

//class AtomLink {
//  String rel;
//  String type;
//  String href;
//
//  AtomLink({this.rel, this.type, this.href});
//
//  AtomLink.fromJson(Map<String, dynamic> json) {
//    rel = json['rel'];
//    type = json['type'];
//    href = json['href'];
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['rel'] = this.rel;
//    data['type'] = this.type;
//    data['href'] = this.href;
//    return data;
//  }
//
//  @override
//  String toString() {
//    return 'AtomLink{rel: $rel, type: $type, href: $href}';
//  }
//
//}

class AcastSignature {
  String key;
  String algorithm;
  String sCdata;

  AcastSignature({this.key, this.algorithm, this.sCdata});

  AcastSignature.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    algorithm = json['algorithm'];
    sCdata = json['__cdata'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['algorithm'] = this.algorithm;
    data['__cdata'] = this.sCdata;
    return data;
  }

  @override
  String toString() {
    return 'AcastSignature{key: $key, algorithm: $algorithm, sCdata: $sCdata}';
  }

}

class AcastNetwork {
  String id;
  String sCdata;

  AcastNetwork({this.id, this.sCdata});

  AcastNetwork.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sCdata = json['__cdata'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['__cdata'] = this.sCdata;
    return data;
  }

  @override
  String toString() {
    return 'AcastNetwork{id: $id, sCdata: $sCdata}';
  }

}

class PodDataImage {
  Title url;
  Title title;
  Title link;

  PodDataImage({this.url, this.title, this.link});

  PodDataImage.fromJson(Map<String, dynamic> json) {
    url = json['url'] != null ? new Title.fromJson(json['url']) : null;
    title = json['title'] != null ? new Title.fromJson(json['title']) : null;
    link = json['link'] != null ? new Title.fromJson(json['link']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.url != null) {
      data['url'] = this.url.toJson();
    }
    if (this.title != null) {
      data['title'] = this.title.toJson();
    }
    if (this.link != null) {
      data['link'] = this.link.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'PodDataImage{url: $url, title: $title, link: $link}';
  }

}

class ItunesPodDataImage {
  String href;

  ItunesPodDataImage({this.href});

  ItunesPodDataImage.fromJson(Map<String, dynamic> json) {
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    return data;
  }

  @override
  String toString() {
    return 'ItunesPodDataImage{href: $href}';
  }


}

class ItunesOwner {
  Description itunesName;
  Title itunesEmail;

  ItunesOwner({this.itunesName, this.itunesEmail});

  ItunesOwner.fromJson(Map<String, dynamic> json) {
    itunesName = json['itunes\$name'] != null ? new Description.fromJson(json['itunes\$name']) : null;
    itunesEmail = json['itunes\$email'] != null ? new Title.fromJson(json['itunes\$email']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.itunesName != null) {
      data['itunes\$name'] = this.itunesName.toJson();
    }
    if (this.itunesEmail != null) {
      data['itunes\$email'] = this.itunesEmail.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'ItunesOwner{itunesName: $itunesName, itunesEmail: $itunesEmail}';
  }

}

//class ItunesCategory {
//  String text;
//
//  ItunesCategory({this.text});
//
//  ItunesCategory.fromJson(Map<String, dynamic> json) {
//    text = json['text'];
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['text'] = this.text;
//    return data;
//  }
//}

class MediaCredit {
  String role;
  String t;

  MediaCredit({this.role, this.t});

  MediaCredit.fromJson(Map<String, dynamic> json) {
    role = json['role'];
    t = json['\$t'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role'] = this.role;
    data['\$t'] = this.t;
    return data;
  }

  @override
  String toString() {
    return 'MediaCredit{role: $role, t: $t}';
  }

}

class MediaDescription {
  String type;
  String sCdata;

  MediaDescription({this.type, this.sCdata});

  MediaDescription.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    sCdata = json['__cdata'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['__cdata'] = this.sCdata;
    return data;
  }

  @override
  String toString() {
    return 'MediaDescription{type: $type, sCdata: $sCdata}';
  }

}

class Item {
  Title title;
  Title acastEpisodeId;
  Title acastEpisodeUrl;
  Title itunesSubtitle;
  Description itunesSummary;
  Guid guid;
  Title pubDate;
  Title itunesDuration;
  Title itunesExplicit;
  Title itunesEpisodeType;
  ItunesPodDataImage itunesPodDataImage;
  Description description;
  Description acastSettings;
  Title link;
  Enclosure enclosure;

  Item({this.title, this.acastEpisodeId, this.acastEpisodeUrl, this.itunesSubtitle, this.itunesSummary, this.guid, this.pubDate, this.itunesDuration, this.itunesExplicit, this.itunesEpisodeType, this.itunesPodDataImage, this.description, this.acastSettings, this.link, this.enclosure});

  Item.fromJson(Map<String, dynamic> json) {
    title = json['title'] != null ? new Title.fromJson(json['title']) : null;
    acastEpisodeId = json['acast\$episodeId'] != null ? new Title.fromJson(json['acast\$episodeId']) : null;
    acastEpisodeUrl = json['acast\$episodeUrl'] != null ? new Title.fromJson(json['acast\$episodeUrl']) : null;
    itunesSubtitle = json['itunes\$subtitle'] != null ? new Title.fromJson(json['itunes\$subtitle']) : null;
    itunesSummary = json['itunes\$summary'] != null ? new Description.fromJson(json['itunes\$summary']) : null;
    guid = json['guid'] != null ? new Guid.fromJson(json['guid']) : null;
    pubDate = json['pubDate'] != null ? new Title.fromJson(json['pubDate']) : null;
    itunesDuration = json['itunes\$duration'] != null ? new Title.fromJson(json['itunes\$duration']) : null;
    itunesExplicit = json['itunes\$explicit'] != null ? new Title.fromJson(json['itunes\$explicit']) : null;
    itunesEpisodeType = json['itunes\$episodeType'] != null ? new Title.fromJson(json['itunes\$episodeType']) : null;
    itunesPodDataImage = json['itunes\$image'] != null ? new ItunesPodDataImage.fromJson(json['itunes\$image']) : null;
    description = json['description'] != null ? new Description.fromJson(json['description']) : null;
    acastSettings = json['acast\$settings'] != null ? new Description.fromJson(json['acast\$settings']) : null;
    link = json['link'] != null ? new Title.fromJson(json['link']) : null;
    enclosure = json['enclosure'] != null ? new Enclosure.fromJson(json['enclosure']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.title != null) {
      data['title'] = this.title.toJson();
    }
    if (this.acastEpisodeId != null) {
      data['acast\$episodeId'] = this.acastEpisodeId.toJson();
    }
    if (this.acastEpisodeUrl != null) {
      data['acast\$episodeUrl'] = this.acastEpisodeUrl.toJson();
    }
    if (this.itunesSubtitle != null) {
      data['itunes\$subtitle'] = this.itunesSubtitle.toJson();
    }
    if (this.itunesSummary != null) {
      data['itunes\$summary'] = this.itunesSummary.toJson();
    }
    if (this.guid != null) {
      data['guid'] = this.guid.toJson();
    }
    if (this.pubDate != null) {
      data['pubDate'] = this.pubDate.toJson();
    }
    if (this.itunesDuration != null) {
      data['itunes\$duration'] = this.itunesDuration.toJson();
    }
    if (this.itunesExplicit != null) {
      data['itunes\$explicit'] = this.itunesExplicit.toJson();
    }
    if (this.itunesEpisodeType != null) {
      data['itunes\$episodeType'] = this.itunesEpisodeType.toJson();
    }
    if (this.itunesPodDataImage != null) {
      data['itunes\$image'] = this.itunesPodDataImage.toJson();
    }
    if (this.description != null) {
      data['description'] = this.description.toJson();
    }
    if (this.acastSettings != null) {
      data['acast\$settings'] = this.acastSettings.toJson();
    }
    if (this.link != null) {
      data['link'] = this.link.toJson();
    }
    if (this.enclosure != null) {
      data['enclosure'] = this.enclosure.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'Item{title: $title, acastEpisodeId: $acastEpisodeId, acastEpisodeUrl: $acastEpisodeUrl, itunesSubtitle: $itunesSubtitle, itunesSummary: $itunesSummary, guid: $guid, pubDate: $pubDate, itunesDuration: $itunesDuration, itunesExplicit: $itunesExplicit, itunesEpisodeType: $itunesEpisodeType, itunesPodDataImage: $itunesPodDataImage, description: $description, acastSettings: $acastSettings, link: $link, enclosure: $enclosure}';
  }

}

class Guid {
  String isPermaLink;
  String sCdata;

  Guid({this.isPermaLink, this.sCdata});

  Guid.fromJson(Map<String, dynamic> json) {
    isPermaLink = json['isPermaLink'];
    sCdata = json['__cdata'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isPermaLink'] = this.isPermaLink;
    data['__cdata'] = this.sCdata;
    return data;
  }

  @override
  String toString() {
    return 'Guid{isPermaLink: $isPermaLink, sCdata: $sCdata}';
  }

}

class Enclosure {
  String url;
  String length;
  String type;

  Enclosure({this.url, this.length, this.type});

  Enclosure.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    length = json['length'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['length'] = this.length;
    data['type'] = this.type;
    return data;
  }

  @override
  String toString() {
    return 'Enclosure{url: $url, length: $length, type: $type}';
  }

}



