class Inventory <ActiveRecord::Base
	validates :name, presence: true
	validates :phone_number, presence: true
	validates :time, presence: true

	after_create :reminder

	# Notify our appointment attendee X minutes before the appointment time

	def reminder
		@twilio_number = '+12028757342'
    	account_sid = 'AC358a60437a112c5c59d3b52da1f0dcc7' #ENV['TWILIO_ACCOUNT_SID'] 
    	auth_token = 'e7ae1b711f733bae6c2647bd62154b77' #ENV['TWILIO_AUTH_TOKEN'] 
    	@client = Twilio::REST::Client.new account_sid, auth_token
    	time_str = ((self.time).localtime).strftime("%I:%M%p on %b. %d, %Y")
    	reminder = "Hi, Just a reminder that you have an appointment coming up at #{time_str}."
    	message = @client.api.account(account_sid).messages.create(
    		:from => @twilio_number,
      		:to => '+16505647814',
      		:body => reminder,
    	)
  	end
  	def when_to_run
    	minutes_before_appointment = 1.minutes
    	time - minutes_before_appointment
  	end

  	handle_asynchronously :reminder, :run_at => Proc.new { |i| i.when_to_run }
end
