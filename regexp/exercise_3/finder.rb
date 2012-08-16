require 'yaml'
require 'awesome_print'

class Finder
  def haml_files
    @files ||= Dir.glob("**/*.haml").entries + Dir.glob("**/*.html.erb").entries
  end

  def get_translation_hash
    @translation_file ||= YAML.load_file("data/en.yml")
  end

  def get_translation_hash_for_lang(lang)
    get_translation_hash[lang]
  end

  def find
    results = []
    haml_files.each do |file|
      paths = combine_paths(file)
      hash = in_translation?(paths)
      results << hash unless hash.empty?
    end
    ap results.inspect
  end

  def get_file_path_elements(file)
    path_elements = file.gsub(/(\.haml|\.html\.erb)/, '').gsub('/_','/').split('/')
    if idx = path_elements.index('views')
      path_elements = path_elements[idx+1..-1] if idx = path_elements.index('views')
    end
  end

  def combine_paths(file)
    paths = []
    file_path_elements = get_file_path_elements(file)
    trans_path_elements = get_translation_path_elements_from_file(file)
    
    trans_path_elements.each do |elements|
      if elements.first.empty?
        paths << file_path_elements + elements[1..-1]
      else
        paths << elements
      end
    end
    paths
  end

  def get_translation_path_elements_from_file(file)
    keys = []
    File.open(file).each do |line|
      matches = line.scan(/t\(\s*\'([\w*\.*]+)\'\)/)
      keys = (keys | matches.flatten) if matches
    end
    keys.collect{ |k| k.split('.') }
  end

  def in_translation?(paths)
    results = Hash.new()

    paths.each do |path|
      translation = find_translation(path)
      results[path.join(".")] = translation if translation
    end
    results
  end


  def find_translation(path)
    translation_hash = get_translation_hash_for_lang("en").merge({"test" => get_translation_hash_for_lang("test")})
    path.each do |key|
      translation_hash = translation_hash.send(:[], key) if translation_hash
    end
    translation_hash
    # raise "#{path} #{translation_hash.inspect}"
  end

end

Finder.new.find()