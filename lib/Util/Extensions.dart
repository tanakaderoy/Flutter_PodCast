extension ReplaceHtmlTags on String {
  String replaceHtmlTags() {
    RegExp exp = RegExp(
        r"<[^>]*>",
        multiLine: true,
        caseSensitive: true
    );
    RegExp exp2 = RegExp(
        r"\&nbsp;",
        multiLine: true,
        caseSensitive: true
    );

    RegExp exp4 = RegExp(
      r"\s\s+",
      multiLine: true,
      caseSensitive: true
    );

    RegExp exp3 = RegExp(
        r"\&rsquo;",
        multiLine: true,
        caseSensitive: true
    );
    var noHTMLTags = this.replaceAll(exp, " ");

    var noBreakSpace = noHTMLTags.replaceAll(exp2, " ");

    var noRsQuo = noBreakSpace.replaceAll(exp3, "'");

    var regularSpacing = noRsQuo.replaceAll(exp4, " ");

    return regularSpacing;
  }

}