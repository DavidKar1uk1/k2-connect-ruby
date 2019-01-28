module K2ConnectRuby
  class K2Authorize
    # Compares HMAC signature with the key. Later call it K2Authenticator
    def authenticate(body, api_secret_key, signature)
      digest = OpenSSL::Digest.new('sha256')
      hmac = OpenSSL::HMAC.hexdigest(digest, api_secret_key, body)
      # @truth = secure_compare(hmac, signature)
      # @truth = hmac.to_s.eql?(signature)
      # return secure_compare(hmac, signature)
      # puts("\n\nThe HMAC:\t#{hmac}\nThe Signature:\t#{signature}")
      puts("\n\nThe Secure Compare:\t#{secure_compare(hmac, signature)}\nThe To Eql:\t#{hmac.to_s.eql?(signature)}")
    end
  end
end