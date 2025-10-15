class Meta {
  final int page;
  final int count;
  final int perPage;
  final bool hasMore;
  final int lastPage;
  final int from;
  final int to;

  const Meta({
    required this.page,
    required this.count,
    required this.perPage,
    required this.hasMore,
    required this.lastPage,
    required this.from,
    required this.to,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      page: json['page'],
      count: json['count'],
      perPage: json['perPage'],
      hasMore: json['hasMore'],
      lastPage: json['lastPage'],
      from: json['from'],
      to: json['to'],
    );
  }
}

class ResponseApi<TData> {
  final List<TData> data;
  final Meta meta;

  const ResponseApi({required this.data, required this.meta});

  factory ResponseApi.fromJson(
    Map<String, dynamic> json,
    TData Function(Map<String, dynamic>) fromJson,
  ) {
    return ResponseApi(
      data: (json['data'] as List).map((e) => fromJson(e)).toList(),
      meta: Meta.fromJson(json['meta']),
    );
  }
}
