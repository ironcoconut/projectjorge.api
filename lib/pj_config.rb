class PJConfig
  YAML::load_file(File.join(__dir__, '../config/settings.yml')).each_pair do |key,value|
    define_singleton_method(key) do
      return value
    end
  end
end
