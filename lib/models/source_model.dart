class SourceModel {
  final int id;
  final String name, description;

  SourceModel({
    required this.id,
    required this.name,
    this.description = '',
  });
}
