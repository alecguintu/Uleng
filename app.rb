require 'rubygems'
require 'ramaze'

Ramaze.options.roots = [__DIR__]
Ramaze.options.views = "/"

Ramaze.setup :verbose => true do
  gem 'erubis'
  gem 'json'
end

class MainController < Ramaze::Controller
  def self.init_data
    @@output = []
  end

  def self.set_data(data)
    @@output << data
  end

  def entry(index)
    entry = @@output.at(index.to_i)
    if entry.nil?
      ""
    else
      "<div class=\"entry\" id=\"entry_#{index}\"><span onclick=\"$(this).parent().css('max-height', 'none');\">[+]</span><a href=\"#\">#{entry}</a></div>"
    end
  end
end

f = File.open '/Users/Lec/Sites/luxtrendz/log/development.log', 'r+'
f.read
MainController::init_data
Thread.new {
  loop do
    begin
      s = f.read_nonblock 65565
    rescue Exception
    end
    MainController.set_data(s) unless s.nil? || s.empty?
    sleep 1
  end
}

Ramaze.start(:adapter => :thin, :port => 7000)