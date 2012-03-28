function singular(plural) {
  plural = plural.replace(/ies$/, 'y');
  plural = plural.replace(/s$/, '');
  return plural;
}
