class ActivityModel {
  final String name;
  final String assetName;

  const ActivityModel({
    required this.name,
    required this.assetName,
  });

  static final List<ActivityModel> dummyList = [
    ActivityModel(
      name: '徒步',
      assetName: 'activity_1.jpeg',
    ),
    ActivityModel(
      name: '空中观光',
      assetName: 'activity_2.png',
    ),
    ActivityModel(
      name: '划船',
      assetName: 'activity_3.jpeg',
    ),
    ActivityModel(
      name: '露营',
      assetName: 'activity_4.jpeg',
    ),
    ActivityModel(
      name: '滑翔伞',
      assetName: 'activity_5.jpeg',
    ),
    ActivityModel(
      name: '滑雪',
      assetName: 'activity_6.jpeg',
    ),
    ActivityModel(
      name: '篝火',
      assetName: 'activity_7.jpeg',
    ),
  ];
}
