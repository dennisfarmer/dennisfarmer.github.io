module.exports = {
  // `hidden: true` in a page's front matter keeps it out of every collection,
  // so it disappears from the card grids and the featured sections on the home
  // page. The page itself is still built, so a direct link keeps working.
  eleventyExcludeFromCollections: (data) =>
    data.hidden === true ? true : data.eleventyExcludeFromCollections,
};
