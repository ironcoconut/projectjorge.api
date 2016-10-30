module Route
  class PJAssets < Sinatra::Base
    set :public_folder, PJConfig.assets_path
  end
end
