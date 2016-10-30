require './scripts/load_lib.rb'

map("/api") { run Route::PJApi }

if ("development" == ENV["RACK_ENV"])
  map("/assets") { run Route::PJAssets }
  map("/") { run Route::PJIndex }
end