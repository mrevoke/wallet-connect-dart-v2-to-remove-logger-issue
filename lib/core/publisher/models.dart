import 'package:walletconnect_v2/core/relayer/models.dart';

class PublisherParams {
  final String topic;
  final String message;
  final RelayerPublishOptions opts;

  PublisherParams({
    required this.topic,
    required this.message,
    required this.opts,
  });
}
