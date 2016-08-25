require './scripts/load_lib.rb'

map("/api") { run Route::PJApi }
