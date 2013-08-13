require 'rubygems'
require 'pp'
require 'yaml'

require File.dirname(__FILE__) + '/../lib/xero_gateway.rb'

XERO_KEYS = YAML.load_file(File.dirname(__FILE__) + '/xero_keys.yml')

gateway = XeroGateway::Gateway.new(XERO_KEYS["xero_consumer_key"], XERO_KEYS["xero_consumer_secret"])

# authorize in browser specific to payroll-API
%x(open #{gateway.request_token.authorize_url}"&scope=payroll.employees,payroll.payitems, payroll.leaveapplications, payroll.payslip, payroll.payrollcalendars, payroll.payruns")

puts "Enter the verification code from Xero?"
oauth_verifier = gets.chomp

gateway.authorize_from_request(gateway.request_token.token, gateway.request_token.secret, :oauth_verifier => oauth_verifier)

pp "**** Get Payroll PayRuns"
# Example payslip-API calls
payroll_pay_runs = gateway.get_payroll_pay_runs.response_item
pp payroll_pay_runs

pp "**** Get Payroll PayRuns By ID"
payroll_pay_run = gateway.get_payroll_pay_run_by_id(payroll_pay_runs.first.pay_run_id).response_item
pp payroll_pay_run
