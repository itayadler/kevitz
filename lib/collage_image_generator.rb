require 'benchmark'
require 'opencv'
require 'tempfile'
require 'httparty'
require 'parallel'

class CollageImageGenerator
  include OpenCV

  #Expecting an array of 64 covers.
  #[
  # 'http://a1.mzstatic.com/us/r30/Music/9a/fa/3a/mzi.xvwzoplt.600x600-75.jpg'
  #]
  #
  def initialize(covers_urls, image_width=600, row_size=8, column_size=8, canvas_size=24.0, margin_size=1.5)
    @covers_urls = covers_urls
    @image_width = image_width
    @row_size = row_size
    @column_size = column_size
    @bleed_ratio = margin_size/canvas_size
    @canvas_size = canvas_size
    @margin_size = margin_size
    @collage_width_no_margins = image_width * row_size
    @collage_height_no_margins = image_width * column_size
    @collage_width = @collage_width_no_margins + (@bleed_ratio * @collage_width_no_margins * 2)
    @collage_height = @collage_height_no_margins + (@bleed_ratio * @collage_height_no_margins * 2)
  end

  def self.create(covers_urls, &block)
    self.new(covers_urls).create(&block)
  end

  #Example usage:
  #covers = 64.times.map { 'http://a1.mzstatic.com/us/r30/Music/9a/fa/3a/mzi.xvwzoplt.600x600-75.jpg' }
  #CollageImageGenerator.generate(covers)
  def create(&block)
    #1: Download the covers
    time = Benchmark.realtime do 
      download_covers()
    end
    puts "Download covers took #{time} seconds"
    #2: Stich 'em up
    stitch_images()
    save_collage()
    yield(@collage_image_path)
    cleanup()
  end

  def stitch_images
    image_idx = 0
    @collage_image = IplImage.new(@collage_width, @collage_height, CV_8U, 3)
    image_margin_size = @bleed_ratio * @collage_width_no_margins
    @row_size.times do |i|
      @column_size.times do |j|
        origin_x = (j * @image_width) + image_margin_size
        origin_y = (i * @image_width) + image_margin_size
        roi = CvRect.new(origin_x, origin_y, @image_width, @image_width)
        @collage_image.set_roi(roi)
        cover_image_path = @covers_images[image_idx]
        cover_image = IplImage.load(cover_image_path)
        cover_image = cover_image.resize(CvSize.new(@image_width, @image_width))
        cover_image.copy(@collage_image)
        @collage_image.reset_roi
        image_idx += 1
      end
    end
  end

  def save_collage
    temp_file = Tempfile.new(['cover', '.jpg'], encoding: 'ascii-8bit')
    path = temp_file.path
    temp_file.unlink
    @collage_image.save(path)
    @collage_image_path = path
  end

  def cleanup
    @covers_images.each do |cover_img|
      File.unlink(cover_img)
    end
    File.unlink(@collage_image_path)
  end

  def download_covers
    @covers_images = Parallel.map(@covers_urls, in_threads: 4) do |cover_url|
      cover_img = HTTParty.get(cover_url).parsed_response
      temp_cover_img = Tempfile.new(['cover', '.jpg'], encoding: 'ascii-8bit')
      temp_cover_local_path = temp_cover_img.path
      temp_cover_img.unlink
      File.open(temp_cover_local_path, 'wb') do |file|
        file.write(cover_img)
      end
      temp_cover_local_path
    end
  end
end

#require_relative './test'
#CollageImageGenerator.generate(SHAKUR)
