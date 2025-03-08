import 'parents/model.dart';

class Global extends Model {
  String? mockBaseUrl;
  String? laravelBaseUrl;
  String? apiPath;
  int? received;
  int? accepted;
  int? onTheWay;
  int? ready;
  int? inProgress;
  int? done;
  int? failed;

  Global({
    this.mockBaseUrl,
    this.laravelBaseUrl,
    this.apiPath,
    this.received,
    this.accepted,
    this.onTheWay,
    this.ready,
    this.inProgress,
    this.done,
    this.failed,
  });

  Global.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    mockBaseUrl = json['mock_base_url']?.toString();
    laravelBaseUrl = json['laravel_base_url']?.toString();
    apiPath = json['api_path']?.toString();
    received = intFromJson(json, 'received');
    accepted = intFromJson(json, 'accepted');
    onTheWay = intFromJson(json, 'on_the_way');
    ready = intFromJson(json, 'ready');
    inProgress = intFromJson(json, 'in_progress');
    done = intFromJson(json, 'done');
    failed = intFromJson(json, 'failed');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (mockBaseUrl != null) data['mock_base_url'] = mockBaseUrl;
    if (laravelBaseUrl != null) data['laravel_base_url'] = laravelBaseUrl;
    if (apiPath != null) data['api_path'] = apiPath;
    if (received != null) data['received'] = received;
    if (accepted != null) data['accepted'] = accepted;
    if (onTheWay != null) data['on_the_way'] = onTheWay;
    if (ready != null) data['ready'] = ready;
    if (inProgress != null) data['in_progress'] = inProgress;
    if (done != null) data['done'] = done;
    if (failed != null) data['failed'] = failed;
    return data;
  }
}
