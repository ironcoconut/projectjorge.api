module Route
  class PJIndex < Sinatra::Base
    get '/*' do
      File.read(File.join(PJConfig.assets_path, 'index.html'))
    end
  end
end
