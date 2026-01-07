enum DetailsSortColumn {
  name,
  dateModified,
  kind,
}

enum SortDirection {
  ascending,
  descending,
}

extension SortDirectionExtension on SortDirection {
  SortDirection toggle() {
    return switch (this) {
      SortDirection.ascending => SortDirection.descending,
      SortDirection.descending => SortDirection.ascending,
    };
  }
}
