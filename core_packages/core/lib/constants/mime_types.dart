/// List of common file types. Taken from:
/// https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types
///
/// To see IANA's official registry of MIME types, check out:
/// https://www.iana.org/assignments/media-types/media-types.xhtml
enum ContentType {
  audio,
  video,
  image,
  text,
  application,
  font,
  unknown,
}

enum FileType {
  aac(
    extension: 'aac',
    mimeType: 'audio/aac',
    contentType: ContentType.audio,
  ),
  abw(
    extension: 'abw',
    mimeType: 'application/x-abiword',
    contentType: ContentType.application,
  ),
  arc(
    extension: 'arc',
    mimeType: 'application/x-freearc',
    contentType: ContentType.application,
  ),
  avif(
    extension: 'avif',
    mimeType: 'image/avif',
    contentType: ContentType.image,
  ),
  avi(
    extension: 'avi',
    mimeType: 'video/x-msvideo',
    contentType: ContentType.video,
  ),
  azw(
    extension: 'azw',
    mimeType: 'application/vnd.amazon.ebook',
    contentType: ContentType.application,
  ),
  bin(
    extension: 'bin',
    mimeType: 'application/octet-stream',
    contentType: ContentType.application,
  ),
  bmp(
    extension: 'bmp',
    mimeType: 'image/bmp',
    contentType: ContentType.image,
  ),
  bz(
    extension: 'bz',
    mimeType: 'application/x-bzip',
    contentType: ContentType.application,
  ),
  bz2(
    extension: 'bz2',
    mimeType: 'application/x-bzip2',
    contentType: ContentType.application,
  ),
  cda(
    extension: 'cda',
    mimeType: 'application/x-cdf',
    contentType: ContentType.application,
  ),
  csh(
    extension: 'csh',
    mimeType: 'application/x-csh',
    contentType: ContentType.application,
  ),
  css(
    extension: 'css',
    mimeType: 'text/css',
    contentType: ContentType.text,
  ),
  csv(
    extension: 'csv',
    mimeType: 'text/csv',
    contentType: ContentType.text,
  ),
  doc(
    extension: 'doc',
    mimeType: 'application/msword',
    contentType: ContentType.application,
  ),
  docx(
    extension: 'docx',
    mimeType:
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    contentType: ContentType.application,
  ),
  eot(
    extension: 'eot',
    mimeType: 'application/vnd.ms-fontobject',
    contentType: ContentType.application,
  ),
  epub(
    extension: 'epub',
    mimeType: 'application/epub+zip',
    contentType: ContentType.application,
  ),
  flac(
    extension: 'flac',
    mimeType: 'audio/flac',
    contentType: ContentType.audio,
  ),
  gz(
    extension: 'gz',
    mimeType: 'application/gzip',
    contentType: ContentType.application,
  ),
  gif(
    extension: 'gif',
    mimeType: 'image/gif',
    contentType: ContentType.image,
  ),
  html(
    extension: 'html',
    mimeType: 'text/html',
    contentType: ContentType.text,
  ),
  ico(
    extension: 'ico',
    mimeType: 'image/vnd.microsoft.icon',
    contentType: ContentType.image,
  ),
  ics(
    extension: 'ics',
    mimeType: 'text/calendar',
    contentType: ContentType.text,
  ),
  jar(
    extension: 'jar',
    mimeType: 'application/java-archive',
    contentType: ContentType.application,
  ),
  jpeg(
    extension: 'jpeg',
    mimeType: 'image/jpeg',
    contentType: ContentType.image,
  ),
  js(
    extension: 'js',
    mimeType: 'text/javascript',
    contentType: ContentType.text,
  ),
  json(
    extension: 'json',
    mimeType: 'application/json',
    contentType: ContentType.application,
  ),
  jsonld(
    extension: 'jsonld',
    mimeType: 'application/ld+json',
    contentType: ContentType.application,
  ),
  mid(
    extension: 'mid',
    mimeType: 'audio/midi',
    contentType: ContentType.audio,
  ),
  midi(
    extension: 'midi',
    mimeType: 'audio/x-midi',
    contentType: ContentType.audio,
  ),
  mp3(
    extension: 'mp3',
    mimeType: 'audio/mpeg',
    contentType: ContentType.audio,
  ),
  mp4(
    extension: 'mp4',
    mimeType: 'video/mp4',
    contentType: ContentType.video,
  ),
  mpeg(
    extension: 'mpeg',
    mimeType: 'video/mpeg',
    contentType: ContentType.video,
  ),
  mpkg(
    extension: 'mpkg',
    mimeType: 'application/vnd.apple.installer+xml',
    contentType: ContentType.application,
  ),
  odp(
    extension: 'odp',
    mimeType: 'application/vnd.oasis.opendocument.presentation',
    contentType: ContentType.application,
  ),
  ods(
    extension: 'ods',
    mimeType: 'application/vnd.oasis.opendocument.spreadsheet',
    contentType: ContentType.application,
  ),
  odt(
    extension: 'odt',
    mimeType: 'application/vnd.oasis.opendocument.text',
    contentType: ContentType.application,
  ),
  oga(
    extension: 'oga',
    mimeType: 'audio/ogg',
    contentType: ContentType.audio,
  ),
  ogg(
    extension: 'ogg',
    mimeType: 'video/ogg',
    contentType: ContentType.video,
  ),
  ogx(
    extension: 'ogx',
    mimeType: 'application/ogg',
    contentType: ContentType.application,
  ),
  opus(
    extension: 'opus',
    mimeType: 'audio/opus',
    contentType: ContentType.audio,
  ),
  otf(
    extension: 'otf',
    mimeType: 'font/otf',
    contentType: ContentType.font,
  ),
  pdf(
    extension: 'pdf',
    mimeType: 'application/pdf',
    contentType: ContentType.application,
  ),
  php(
    extension: 'php',
    mimeType: 'application/x-httpd-php',
    contentType: ContentType.application,
  ),
  ppt(
    extension: 'ppt',
    mimeType: 'application/vnd.ms-powerpoint',
    contentType: ContentType.application,
  ),
  pptx(
    extension: 'pptx',
    mimeType:
        'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    contentType: ContentType.application,
  ),
  rar(
    extension: 'rar',
    mimeType: 'application/vnd.rar',
    contentType: ContentType.application,
  ),
  rtf(
    extension: 'rtf',
    mimeType: 'application/rtf',
    contentType: ContentType.application,
  ),
  sh(
    extension: 'sh',
    mimeType: 'application/x-sh',
    contentType: ContentType.application,
  ),
  svg(
    extension: 'svg',
    mimeType: 'image/svg+xml',
    contentType: ContentType.image,
  ),
  tar(
    extension: 'tar',
    mimeType: 'application/x-tar',
    contentType: ContentType.application,
  ),
  tif(
    extension: 'tif',
    mimeType: 'image/tiff',
    contentType: ContentType.image,
  ),
  tiff(
    extension: 'tiff',
    mimeType: 'image/tiff',
    contentType: ContentType.image,
  ),
  ts(
    extension: 'ts',
    mimeType: 'video/mp2t',
    contentType: ContentType.video,
  ),
  ttf(
    extension: 'ttf',
    mimeType: 'font/ttf',
    contentType: ContentType.font,
  ),
  txt(
    extension: 'txt',
    mimeType: 'text/plain',
    contentType: ContentType.text,
  ),
  vsd(
    extension: 'vsd',
    mimeType: 'application/vnd.visio',
    contentType: ContentType.application,
  ),
  wav(
    extension: 'wav',
    mimeType: 'audio/wav',
    contentType: ContentType.audio,
  ),
  weba(
    extension: 'weba',
    mimeType: 'audio/webm',
    contentType: ContentType.audio,
  ),
  webm(
    extension: 'webm',
    mimeType: 'video/webm',
    contentType: ContentType.video,
  ),
  webp(
    extension: 'webp',
    mimeType: 'image/webp',
    contentType: ContentType.image,
  ),
  woff(
    extension: 'woff',
    mimeType: 'font/woff',
    contentType: ContentType.font,
  ),
  woff2(
    extension: 'woff2',
    mimeType: 'font/woff2',
    contentType: ContentType.font,
  ),
  xhtml(
    extension: 'xhtml',
    mimeType: 'application/xhtml+xml',
    contentType: ContentType.application,
  ),
  xls(
    extension: 'xls',
    mimeType: 'application/vnd.ms-excel',
    contentType: ContentType.application,
  ),
  xlsx(
    extension: 'xlsx',
    mimeType:
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    contentType: ContentType.application,
  ),
  xml(
    extension: 'xml',
    mimeType: 'application/xml',
    contentType: ContentType.application,
  ),
  xul(
    extension: 'xul',
    mimeType: 'application/vnd.mozilla.xul+xml',
    contentType: ContentType.application,
  ),
  zip(
    extension: 'zip',
    mimeType: 'application/zip',
    contentType: ContentType.application,
  ),
  t3gp(
    extension: '3gp',
    mimeType: 'video/3gpp',
    contentType: ContentType.video,
  ),
  t3g2(
    extension: '3g2',
    mimeType: 'video/3gpp2',
    contentType: ContentType.video,
  ),
  t7z(
    extension: '7z',
    mimeType: 'application/x-7z-compressed',
    contentType: ContentType.application,
  ),
  unknown(
    extension: '',
    mimeType: '',
    contentType: ContentType.unknown,
  );

  final String extension;
  final String mimeType;
  final ContentType contentType;

  const FileType({
    required this.extension,
    required this.mimeType,
    this.contentType = ContentType.unknown,
  });
}

const Map<String, FileType> kMimeTypes = {
  'audio/aac': FileType.aac,
  'application/x-abiword': FileType.abw,
  'application/x-freearc': FileType.arc,
  'image/avif': FileType.avif,
  'video/x-msvideo': FileType.avi,
  'application/vnd.amazon.ebook': FileType.azw,
  'application/octet-stream': FileType.bin,
  'image/bmp': FileType.bmp,
  'application/x-bzip': FileType.bz,
  'application/x-bzip2': FileType.bz2,
  'application/x-cdf': FileType.cda,
  'application/x-csh': FileType.csh,
  'text/css': FileType.css,
  'text/csv': FileType.csv,
  'application/msword': FileType.doc,
  'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
      FileType.docx,
  'application/vnd.ms-fontobject': FileType.eot,
  'application/epub+zip': FileType.epub,
  'audio/flac': FileType.flac,
  'application/gzip': FileType.gz,
  'image/gif': FileType.gif,
  'text/html': FileType.html,
  'image/vnd.microsoft.icon': FileType.ico,
  'text/calendar': FileType.ics,
  'application/java-archive': FileType.jar,
  'image/jpeg': FileType.jpeg,
  'text/javascript': FileType.js,
  'application/json': FileType.json,
  'application/ld+json': FileType.jsonld,
  'audio/midi': FileType.mid,
  'audio/x-midi': FileType.midi,
  'audio/mpeg': FileType.mp3,
  'video/mp4': FileType.mp4,
  'video/mpeg': FileType.mpeg,
  'application/vnd.apple.installer+xml': FileType.mpkg,
  'application/vnd.oasis.opendocument.presentation': FileType.odp,
  'application/vnd.oasis.opendocument.spreadsheet': FileType.ods,
  'application/vnd.oasis.opendocument.text': FileType.odt,
  'audio/ogg': FileType.oga,
  'video/ogg': FileType.ogg,
  'application/ogg': FileType.ogx,
  'audio/opus': FileType.opus,
  'font/otf': FileType.otf,
  'application/pdf': FileType.pdf,
  'application/x-httpd-php': FileType.php,
  'application/vnd.ms-powerpoint': FileType.ppt,
  'application/vnd.openxmlformats-officedocument.presentationml.presentation':
      FileType.pptx,
  'application/vnd.rar': FileType.rar,
  'application/rtf': FileType.rtf,
  'application/x-sh': FileType.sh,
  'image/svg+xml': FileType.svg,
  'application/x-tar': FileType.tar,
  'image/tiff': FileType.tiff,
  'video/mp2t': FileType.ts,
  'font/ttf': FileType.ttf,
  'text/plain': FileType.txt,
  'application/vnd.visio': FileType.vsd,
  'audio/wav': FileType.wav,
  'audio/webm': FileType.weba,
  'video/webm': FileType.webm,
  'image/webp': FileType.webp,
  'font/woff': FileType.woff,
  'font/woff2': FileType.woff2,
  'application/xhtml+xml': FileType.xhtml,
  'application/vnd.ms-excel': FileType.xls,
  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet':
      FileType.xlsx,
  'application/xml': FileType.xml,
  'application/vnd.mozilla.xul+xml': FileType.xul,
  'application/zip': FileType.zip,
  'video/3gpp': FileType.t3gp,
  'video/3gpp2': FileType.t3g2,
  'application/x-7z-compressed': FileType.t7z,
};
