# Processes Results
module K2ProcessResult
  def self.process(payload)
    raise ArgumentError, 'Empty/Nil Request Body Argument!' if payload.blank?
    K2ProcessResult.check_topic(payload)
  end

  # Check the Event Type.
  def self.check_topic(payload)
    result_type = payload.dig('data', 'type')
    case result_type
      # Incoming Payments
    when 'incoming_payment'
      incoming_payments = IncomingPayments.new
      incoming_payments.components(payload)
      return incoming_payments
      # Outgoing Payments
    when 'payment'
      outgoing_payments = OutgoingPayments.new
      outgoing_payments.components(payload)
      return outgoing_payments
    else
      raise ArgumentError, 'No Other Specified Payment Type!'
    end
  end

  # Returns a Hash Object
  def self.return_obj_hash(instance_hash = HashWithIndifferentAccess.new, obj)
    obj.instance_variables.each do |value|
      instance_hash[:"#{value.to_s.tr('@', '')}"] = obj.instance_variable_get(value)
    end
    instance_hash.each(&:freeze).freeze
  end

  # Returns an Array Object
  def self.return_obj_array(instance_array = [], obj)
    obj.instance_variables.each do |value|
      instance_array << obj.instance_variable_get(value)
    end
    instance_array.each(&:freeze).freeze
  end
end