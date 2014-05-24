Rails.application.routes.draw do
	root to: 'kevitz#index'

	get 'find_covers_by_artist', to: 'kevitz#find_covers_by_artist'
	
end
