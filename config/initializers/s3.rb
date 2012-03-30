if Rails.env.production?
  AWS::S3::Base.establish_connection!(
    :access_key_id     => 'AKIAIAWWYJYVTOX6NYQQ',
    :secret_access_key => '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'
  )
end