# frozen_string_literal: true

# Globs for web archive files (WARC, WACZ)
class WebArchiveGlob
  def self.warcs(directory)
    Dir.glob("#{directory}/**/*.warc*")
  end

  def self.waczs(directory)
    Dir.glob("#{directory}/**/*.wacz")
  end

  def self.web_archives(directory)
    warcs(directory) + waczs(directory)
  end
end
