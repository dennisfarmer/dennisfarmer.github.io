module.exports = function(eleventyConfig) {
  eleventyConfig.addPassthroughCopy({ "src/style.css": "css/style.css" });
  eleventyConfig.addPassthroughCopy({ "src/favicon.ico": "favicon.ico" });
  eleventyConfig.addPassthroughCopy({ "src/robots.txt": "robots.txt" });
  eleventyConfig.addPassthroughCopy({ "public/images": "images" });
  eleventyConfig.addPassthroughCopy({ "public/audios": "audios" });
  eleventyConfig.addPassthroughCopy({ "public/scores": "scores" });
  eleventyConfig.addPassthroughCopy({ "public/presentations": "presentations" });
  eleventyConfig.addPassthroughCopy({ "public/resume.pdf": "resume.pdf" });
  eleventyConfig.addPassthroughCopy("CNAME");
  eleventyConfig.addCollection("posts", function(collectionApi) {
    return collectionApi.getFilteredByGlob("src/posts/*.md");
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
