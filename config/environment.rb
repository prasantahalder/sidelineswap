# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Sidelineswap::Application.initialize!

IPN_LOG = File.expand_path('../../logs/ipn.log', __FILE__)