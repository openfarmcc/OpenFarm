# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
  fake = '58f4e3cc1646c5eebbedc3dce699f76a527de45b5451a582e2b334e008a4c2cc8b70'\
         '999230257f61c9522ad56dc3a66654d29b227aa6e6bf5b4f2df49dd617be'
  real = ENV['SECRET_KEY_BASE']
OpenFarm::Application.config.secret_key_base = real || fake
