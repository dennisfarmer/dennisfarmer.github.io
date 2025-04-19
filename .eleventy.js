module.exports = function(eleventyConfig) {
  eleventyConfig.addPassthroughCopy({ "public/style.css": "css/style.css" });
  eleventyConfig.addPassthroughCopy({ "public/images": "images" });
  eleventyConfig.addPassthroughCopy({ "public/audios": "audios" });
  eleventyConfig.addPassthroughCopy({ "public/scores": "scores" });
  eleventyConfig.addPassthroughCopy({ "public/resume.pdf": "resume.pdf" });
  eleventyConfig.addPassthroughCopy({ "public/favicon.ico": "favicon.ico" });
  eleventyConfig.addPassthroughCopy({ "public/robots.txt": "robots.txt" });
  eleventyConfig.addPassthroughCopy("CNAME");
  eleventyConfig.addCollection("blog", function(collectionApi) {
    return collectionApi.getFilteredByGlob("src/blog/*.md");
  });
  eleventyConfig.addCollection("projects", function(collectionApi) {
    return collectionApi.getFilteredByGlob("src/projects/*.md");
  });
  eleventyConfig.addCollection("music", function(collectionApi) {
    return collectionApi.getFilteredByGlob("src/music/*.md");
  });
  return {
    dir: {
      input: "src",
      includes: "_includes",
      output: "_site"
    },
    markdownTemplateEngine: "njk",
    htmlTemplateEngine: "njk",
    dataTemplateEngine: "njk"
  };
};
