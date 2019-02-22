require "k2-connect-ruby/k2_entity/k2_subscribe"
require "k2-connect-ruby/k2_entity/entities/k2_stk"
require "k2-connect-ruby/k2_entity/entities/k2_pay"
require "k2-connect-ruby/k2_entity/entities/k2_transfer"

class K2Entity
  attr_accessor :k2_access_token,
                :the_array

  # Initialize with access token from Subscriber Class
  def initialize(access_token)
    @k2_access_token = access_token
  end

  # Method for Validating the input itself
  def validate_input(the_input, the_array)
    @the_array = the_array
    if the_input.empty?
      raise K2EmptyInput.new
    else
      if the_input.is_a?(Hash)
        validate_hash the_input
      else
        validate_id the_input
      end
    end
    return true
  rescue K2EmptyInput => k2
    puts(k2.message)
    return false
  rescue TypeError => te
    puts(te.message)
    return false
  rescue K2InvalidHash => k3
    puts(k3.message)
    return false
  rescue IncorrectParams => k4
    puts(k4.message)
    return false
  end

  # Validate the Hash Input Parameters
  def validate_hash(the_input, empty_keys = {}, invalid_keys = {})
    nil_params(the_input, empty_keys) and return
    if empty_keys.empty?
      puts "No Nil or Empty Values in Hash."
      check_keys(the_input, invalid_keys)
      unless invalid_keys.empty?
        raise IncorrectParams.new(invalid_keys)
      end
    else
      raise K2InvalidHash.new(empty_keys)
    end
  end

  def check_keys(the_input, invalid_hash)
    the_input.each_key do |key|
      unless @the_array.include?(key.to_s)
        invalid_hash[:"#{key}"] = key
      end
    end
  end

  # Nil or Empty Values in Hash
  def nil_params(the_input, times= 0, nil_keys)
    while times < the_input.select{|_,v| v.nil? || v == ""}.keys.length
      the_input.select{|_,v| v.nil? || v == ""}.each_key do |a|
        nil_keys[:"item#{times}"] = a
        times += 1
      end
    end
  end

  # Validate the ID
  def validate_id(the_input) end

  # Process Payment Result
  def process_payment(the_request)
    raise K2NilRequest.new if the_request.nil?
    # The Response Body.
    hash_body = Yajl::Parser.parse(the_request.body.string.as_json)
    # The Response Header
    hash_header = Yajl::Parser.parse(the_request.headers.env.select{|k, _| k =~ /^HTTP_/}.to_json)
  rescue K2NilRequest => k2
    puts(k2.message)
  end

end