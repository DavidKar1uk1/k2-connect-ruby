class WebhookTransaction < K2Result
  # Can also implement Customer Created from Here
  attr_accessor :msisdn,
                :first_name,
                :middle_name,
                :last_name

  class CommonWebhook < WebhookTransaction
    attr_accessor :reference,
                  :origination_time,
                  :status

    # For The General Webhook
    def components(the_body)
      super components(the_body)
      @amount = the_body.dig("event", "resource", "amount")
      @currency = the_body.dig("event", "resource", "currency")
      @reference = the_body.dig("event", "resource", "reference")
      @origination_time = the_body.dig("event", "resource", "origination_time")
      @status = the_body.dig("event", "resource", "status")
    end

  end

  class Customer_Created < WebhookTransaction
    # For The Customer Created Webhook
    def components(the_body)
      super components(the_body)
      @msisdn = the_body.dig("event", "resource", "msisdn")
      @first_name = the_body.dig("event", "resource", "first_name")
      @middle_name = the_body.dig("event", "resource", "middle_name")
      @last_name = the_body.dig("event", "resource", "last_name")
    end
  end

  class BuyGoods < CommonWebhook
    attr_accessor :reference,
                  :origination_time,
                  :till_number,
                  :system,
                  :status

    # For The BuyGoods Received Webhook
    def components(the_body)
      super components(the_body)
      @msisdn = the_body.dig("event", "resource", "msisdn")
      @till_number = the_body.dig("event", "resource", "till_number")
      @system = the_body.dig("event", "resource", "system")
      @first_name = the_body.dig("event", "resource", "sender_first_name")
      @middle_name = the_body.dig("event", "resource", "sender_middle_name")
      @last_name = the_body.dig("event", "resource", "sender_last_name")
    end

    class Reversal < BuyGoods
      attr_accessor :reversal_time
      # For The BuyGoods Reversed Webhook
      def components(the_body)
        super components(the_body)
        @reversal_time = the_body.dig("event", "resource", "reversal_time")
      end

    end

  end

  class Settlement < CommonWebhook
    attr_accessor :destination,
                  :destination_type,
                  :transfer_time,
                  :transfer_type,
                  :destination_mm_system
    # For The Settlement Transfer Webhook
    def components(the_body)
      super components(the_body)
      @transfer_time = the_body.dig("event", "resource", "transfer_time")
      @transfer_type = the_body.dig("event", "resource", "transfer_type")
      @destination = the_body.dig("event", "resource", "destination")
      @destination_type = the_body.dig("event", "resource", "destination", "type")
      @msisdn = the_body.dig("event", "resource", "destination", "msisdn")
      @destination_mm_system = the_body.dig("event", "resource", "destination", "mm_system")
    end

  end

end