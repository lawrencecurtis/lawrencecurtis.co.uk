# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_lawrencecurtis.co.uk_session',
  :secret      => 'f0c526c48d96af7aee6fed676eef03c41535d5e4c595c78441bf7ed4924abf5c464859cbe3fa6289cf054434332620a7b1e7d406e5f85d81ed72c37cb279e2b2'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
