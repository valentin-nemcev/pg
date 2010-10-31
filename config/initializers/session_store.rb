# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_pg-test_session',
  :secret      => 'b4582f664975a6adc3e562b8193e476405288863e60b9e5e673d0ac9a6805f71f81f8d9e4307fc14b22663faee871eb941362e1fe129676435724549d68d157a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
