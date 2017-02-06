require 'yaml'

module Settings
  # singleton
  extend self

  @_settings = {}
  attr_reader :_settings

  # load file
  def load!(filename)
    newsets = YAML::load_file(filename)
    newsets = Application.symbolize_keys(newsets)
    deep_merge!(@_settings, newsets)
  end

  # Deep merging of hashes
  def deep_merge!(target, data)
    merger = proc{|key, v1, v2|
      Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
    target.merge! data, &merger
  end
end
