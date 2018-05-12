module ApplicationHelper
  def load_webpack_files(files)
    files.map do |file|
      File.read Rails.root.to_s + '/public' + file
    end.join("\n").html_safe
  end

  def env_variables(*names)
    names.map { |name| [name, ENV[name.upcase] ]}.to_h.to_json.html_safe
  end
end
