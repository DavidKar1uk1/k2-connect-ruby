# Common Structure for Webhook Results
class K2Webhook < K2Result
  attr_reader :msisdn,
              :link_resource

  def components(the_body)
    super
    @link_resource = @links.dig('resource')
  end
end

# For The Customer Created Webhook
class CustomerCreated < K2Webhook
  def components(the_body)
    super
    # Resources
    @msisdn = @resource.dig('msisdn')
    @last_name = @resource.dig('last_name')
    @first_name = @resource.dig('first_name')
    @middle_name = @resource.dig('middle_name')
  end
end

# For The General Webhook except Customer Created Result
class GeneralWebhook < K2Webhook
  attr_reader :reference,
              :origination_time,
              :resource_status

  def components(the_body)
    super
    # Resources
    @amount = the_body.dig('resource', 'amount')
    @currency = the_body.dig('resource', 'currency')
    @reference = the_body.dig('resource', 'reference')
    @resource_status = the_body.dig('resource', 'status')
    @origination_time = the_body.dig('resource', 'origination_time')
  end
end

# For Settlement Transfer Webhook
class Settlement < GeneralWebhook
  attr_reader :destination,
              :destination_type,
              :transfer_time,
              :transfer_type,
              :destination_mm_system

  def components(the_body)
    super
    # Resources
    @transfer_time = @resource.dig('transfer_time')
    @transfer_type = @resource.dig('transfer_type')
    # Destination
    @destination = @resource.dig('destination')
    @msisdn = @destination.dig('msisdn')
    @destination_type = @destination.dig('type')
    @destination_mm_system = @destination.dig('mm_system')
  end
end

# For The Common Transaction Webhook
class K2FinancialTransaction < GeneralWebhook
  attr_reader :till_number,
              :system

  def components(the_body)
    super
    # Resources
    @system = the_body.dig('resource', 'system')
    @msisdn = the_body.dig('resource', 'sender_msisdn')
    @till_number = the_body.dig('resource', 'till_number')
    @last_name = the_body.dig('resource', 'sender_last_name')
    @first_name = the_body.dig('resource', 'sender_first_name')
    @middle_name = the_body.dig('resource', 'sender_middle_name')
  end
end

# For The BuyGoods Reversed Webhook
class Reversal < K2FinancialTransaction
  attr_reader :reversal_time
  def components(the_body)
    super
    # Resources
    @reversal_time = @resource.dig('reversal_time')
  end
end

# For The BuyGoods Received Webhook
class BuyGoods < K2FinancialTransaction
  def components(the_body)
    super
  end
end

# For The External Till to Till transaction
class B2B < K2FinancialTransaction
  attr_reader :sending_till
  def components(the_body)
    super
    # Resources
    @sending_till = @resource.dig('sending_till')
  end
end

# For The Merchant to Merchant Transaction Received
class MerchantTransaction < K2FinancialTransaction
  attr_reader :sending_merchant
  def components(the_body)
    super
    # Resources
    @sending_merchant = @resource.dig('sending_merchant')
  end
end
