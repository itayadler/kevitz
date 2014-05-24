require 'awesome_print'
require 'hashie'
require 'itunes-search-api'

class CoverAPI
  MUSIC_MEDIA = 'music'
  COUNTRY = 'us'
  ENTITY = 'album'
  #Example usage:
  #ap CoverAPI.find_covers_by_artist('autechre quaristice')[0].large_cover
  #The largest cover field is `large_cover`
  def self.find_covers_by_artist(artist_name)
    results = ITunesSearchAPI.search(term: artist_name, country: COUNTRY, media: MUSIC_MEDIA, entity: ENTITY)
      .map { |r| Hashie::Mash.new(r) }
      .map { |r| r.large_cover = r.artworkUrl100.gsub('100x100', '600x600'); r }
    results
  end
end

