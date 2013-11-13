require 'songs'

Song.load_from_hash_array(SONGS) if Song.respond_to?(:load_from_hash_array) && Rails.env.development?
