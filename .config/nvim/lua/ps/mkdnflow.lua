require('mkdnflow').setup {
  modules = {
    conceal = false,
  },
  perspective = {
    priority = "root",
    fallback = "current",
    root_tell = "index.md",
  },
  links = {
    transform_explicit = function(text)
      text = text:gsub(" ", "-")
      text = text:lower()
      return text
    end
  },
  mappings = {
    MkdnIncreaseHeading = false,
    MkdnDecreaseHeading = false,
  }
}
