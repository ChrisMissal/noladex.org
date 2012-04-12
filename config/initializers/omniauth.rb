Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'XqWB4EcB8nzQZd73Ht94rw', '6RKtIRbaFfeBObfOeaxeFEOatOZ2nCX6EyDPv3GYfY'
  provider :facebook, ENV['356531637732909'], ENV['b322fa62f438f0bf39979916c071369d']
  provider :linkedin, "12x3sy540w1b", "Z6uLUoGwYpyu7U5K"
end