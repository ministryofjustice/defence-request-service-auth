Rails.application.config.middleware.use OmniAuth::Builder do
  provider :ds_auth,
    Settings.authentication.application_id,
    Settings.authentication.application_secret
end
