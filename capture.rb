require 'rubygems'
require 'capybara-webkit'
require 'headless'
require 'yaml'
require 'Rmagick'
require 'base64'

class Capture

  def initialize(config)
    @driver    = Capybara::Webkit::Driver.new('web_capture').browser
    @prefix    = config['name']['prefix']
    @original  = config['dir']['original']
    @cropped   = config['dir']['cropped']
    @extension = config['extension']
    @height    = config['size']['height']
    @width     = config['size']['width']
  end

  def get(request)
    uri = request['uri']
    original_filename = request['name'] + '-' + generate_filename(uri) + @extension 

    if request['auth']
      username = request['auth']['user']
      password = request['auth']['pass']
      encoded = Base64.encode64(username + ':' + password) 
      @driver.header('Authorization', 'Basic ' + encoded.chomp)
    end

    @driver.visit uri.to_s
    @driver.render(@original + original_filename, @height, @width)
    resize(original_filename)
  end

  private

  def generate_filename(uri)
    element = uri.split('/')
    unless @prefix
      element[2].gsub('.', '_')
    else
      @prefix + element[2].gsub('.', '_')
    end
  end

  def resize(original_image)
    original = Magick::Image.read(@original + original_image).first
    filename = @cropped + original_image
    image = original.crop(0, 0, @height, @width)
    image.write(filename)
  end

end

config = YAML.load_file('config.yml')
capture = Capture.new(config['image'])

config['requests'].each do |r|
  capture.get(r['request'])
end
