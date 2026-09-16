/// Sizing reference used by the product size selector and the size guide.
/// Static reference data; a tenant override can arrive with C10.
library;

class RingSizeRow {
  const RingSizeRow(this.us, this.uk, this.diameterMm, this.circumferenceMm);
  final String us;
  final String uk;
  final double diameterMm;
  final double circumferenceMm;
}

const ringSizes = [
  RingSizeRow('4', 'H', 14.9, 46.8),
  RingSizeRow('5', 'J½', 15.7, 49.3),
  RingSizeRow('6', 'L½', 16.5, 51.9),
  RingSizeRow('7', 'N½', 17.3, 54.4),
  RingSizeRow('8', 'P½', 18.1, 57.0),
  RingSizeRow('9', 'R½', 19.0, 59.5),
  RingSizeRow('10', 'T½', 19.8, 62.1),
  RingSizeRow('11', 'V½', 20.6, 64.6),
  RingSizeRow('12', 'X½', 21.4, 67.2),
];

class BangleSizeRow {
  const BangleSizeRow(this.size, this.diameterIn, this.circumferenceMm, this.fitsKey);
  final String size;
  final String diameterIn;
  final int circumferenceMm;

  /// `xs` / `s` / `m` / `l` / `xl`, localised by the screen.
  final String fitsKey;
}

const bangleSizes = [
  BangleSizeRow('2.2', '2 2/16"', 168, 'xs'),
  BangleSizeRow('2.4', '2 4/16"', 181, 's'),
  BangleSizeRow('2.6', '2 6/16"', 194, 'm'),
  BangleSizeRow('2.8', '2 8/16"', 207, 'l'),
  BangleSizeRow('2.10', '2 10/16"', 220, 'xl'),
];

class LengthSizeRow {
  const LengthSizeRow(this.size, this.cm, this.sitsKey);
  final String size;
  final int cm;

  /// `choker` / `princess` / `matinee` / `matineeLow` / `opera`.
  final String sitsKey;
}

const lengthSizes = [
  LengthSizeRow('16"', 40, 'choker'),
  LengthSizeRow('18"', 45, 'princess'),
  LengthSizeRow('20"', 50, 'matinee'),
  LengthSizeRow('22"', 55, 'matineeLow'),
  LengthSizeRow('24"', 60, 'opera'),
];
