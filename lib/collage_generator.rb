require 'opencv'
require 'tempfile'
require 'httparty'

class CollageGenerator
  include OpenCV
  ROW_SIZE = 8
  #Expecting an array of 64 covers.
  #[
  # 'http://a1.mzstatic.com/us/r30/Music/9a/fa/3a/mzi.xvwzoplt.600x600-75.jpg'
  #]
  #
  #Example usage:
  #covers = 64.times.map { 'http://a1.mzstatic.com/us/r30/Music/9a/fa/3a/mzi.xvwzoplt.600x600-75.jpg' }
  #CollageGenerator.generate(covers)
  def self.generate(covers)
    #1: Download the covers
    covers_images = download_covers(covers)
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
        cover_image.copy(collage_image)
        collage_image.reset_roi
        image_idx += 1
      end
    end
    #3: cleanup cover images
    covers_images.each do |cover_img|
      File.unlink(cover_img)
    end
    #4: Save and return local uri
    path = save_collage(collage_image)
    path
  end

  def self.save_collage(collage_image)
    temp_file = Tempfile.new(['cover', '.jpg'], encoding: 'ascii-8bit')
    path = temp_file.path
    temp_file.unlink
    collage_image.save(path)
    path
  end

  def self.download_covers(covers)
    covers.map do |cover_url|
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
    image = IplImage.load(image_path)
    [image.width, image.height]
  end
end

#require_relative './test'
#CollageGenerator.generate(SHAKUR)
