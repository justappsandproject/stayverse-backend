class BrimPagination {
  int? page;
  int? limit;
  int? total;
  int? pages;

  BrimPagination({
    this.page = 1, // Default page to 1 if not provided
    this.limit = 10, // Default limit to 10 if not provided
    this.total,
    this.pages,
  });

  BrimPagination.fromJson(Map<String, dynamic> json) {
    page = json['page'] as int?;
    limit = json['limit'] as int?;
    total = json['total'] as int?;
    pages = json['pages'] as int?;
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'pages': pages,
    };
  }

  Map<String, dynamic> toQueryParams() {
    final Map<String, String> params = {};

    if (page != null) params['page'] = page.toString();
    if (limit != null) params['limit'] = limit.toString();
    if (total != null) params['total'] = total.toString();
    if (pages != null) params['pages'] = pages.toString();

    return params;
  }
}
