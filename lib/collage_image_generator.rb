require 'benchmark'
require 'opencv'
require 'tempfile'
require 'httparty'
require 'parallel'

class CollageImageGenerator
  include OpenCV
  ROW_SIZE = 8
  IMAGE_WIDTH = 600
  MARGIN_SIZE = 1.5
  CANVAS_SIZE = 24.0
  #Expecting an array of 64 covers.
  #[
  # 'http://a1.mzstatic.com/us/r30/Music/9a/fa/3a/mzi.xvwzoplt.600x600-75.jpg'
  #]
  #
  #Example usage:
  #covers = 64.times.map { 'http://a1.mzstatic.com/us/r30/Music/9a/fa/3a/mzi.xvwzoplt.600x600-75.jpg' }
  #CollageImageGenerator.generate(covers)
  def self.generate(covers, &block)
    #1: Download the covers
    covers_images = nil
    time = Benchmark.realtime do 
      covers_images = download_covers(covers)
    end
    puts "Download covers took #{time} seconds"
    #require 'byebug'; byebug
    #2: Stich 'em up
    image_size = image_size(covers_images[0])
    collage_size = collage_size(image_size)
    collage_image = IplImage.new(collage_size[0], collage_size[1], CV_8U, 3)
    image_idx = 0
    ROW_SIZE.times do |i|
      ROW_SIZE.times do |j|
        origin_x = j * image_size[0]
        origin_y = i * image_size[1]
        width = image_size[0]
        height = image_size[1]
        roi = CvRect.new(origin_x, origin_y, width, height)
        collage_image.set_roi(roi)
        cover_image_path = covers_images[image_idx]
        cover_image = IplImage.load(cover_image_path)
        cover_image = cover_image.resize(CvSize.new(image_size[0], image_size[1]))
        cover_image.copy(collage_image)
        collage_image.reset_roi
        image_idx += 1
      end
    end
    final_collage_size = final_collage_size(collage_size)
    origin_x = margin_to_canvas_ratio * collage_size[0]
    origin_y = margin_to_canvas_ratio * collage_size[1]
    final_image = IplImage.new(final_collage_size[0], final_collage_size[1], CV_8U, 3)
    final_image.set_roi(CvRect.new(origin_x, origin_y, collage_size[0], collage_size[1]))
    collage_image.copy(final_image)
    final_image.reset_roi
    #3: cleanup cover images
    covers_images.each do |cover_img|
      File.unlink(cover_img)
    end
    #4: Save and return local uri
    path = save_collage(final_image)
    path
  end

  def self.final_collage_size(collage_size)
    width = collage_size[0] + (margin_to_canvas_ratio*collage_size[0]*2)
    height = collage_size[1] + (margin_to_canvas_ratio*collage_size[1]*2)
    [width, height]
  end

  def self.margin_to_canvas_ratio
    MARGIN_SIZE/CANVAS_SIZE
  end

  def self.save_collage(collage_image)
    temp_file = Tempfile.new(['cover', '.jpg'], encoding: 'ascii-8bit')
    path = temp_file.path
    temp_file.unlink
    collage_image.save(path)
    path
  end

  def self.download_covers(covers)
    Parallel.map(covers, in_threads: 4) do |cover_url|
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

  def self.collage_size(image_size)
    [image_size[0]*ROW_SIZE, image_size[1]*ROW_SIZE]
  end

  def self.image_size(image_path)
    [IMAGE_WIDTH, IMAGE_WIDTH]
  end
end

#require_relative './test'
#CollageImageGenerator.generate(SHAKUR)
