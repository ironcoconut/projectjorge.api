login = { 
  email: "bob@stern.org",
  password: "muffins"
}

data = {
  charities: "all",
  charity: "st-mary"
}

class Post < ActiveRecord::Base
  scope :verified, -> { select("users.verified AS user_verified").
                        join("LEFT JOIN users ON users.id = posts.user_id AND 
                                                 user_verified IS TRUE") 
  }
  scope :pros,     -> { select("up.verified_pro AS user_pro").
                        join("LEFT JOIN user_profiles AS up ON up.id = posts.user_id AND
                                                               user_pro IS TRUE")
  }
  scope :load,     -> { [ :user_verified,
                          :user_pro ].reduce(self.to_h) { |a,i| a[i] = self[i] }
  }

end
