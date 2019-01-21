require 'bundler'
Bundler.setup
require 'savon'
require "yaml"
require "csv"
require 'nokogiri'

class Load

  def initialize()
    # Initialize SOAP client using the WSDL
    @config = YAML.load(File.open('config/config.yml').read)
    @client = Savon.client(:wsdl => @config["wsdl"], log: false, ssl_verify_mode: :none)
  end

  # Call Load on the PAPSchedule Service
  def load_request()
    errors = []
    infos = []

    # Read CSV file to load the data to LeasePak API
    CSV.foreach(@config["path_to_file"], :headers => true, :col_sep => ',') do |row|
      # Post XML data to LeasePak API to save the PAP Schedule data
      response = @client.call(:add_schedule, message: {inputXmlStream: generate_xml(row)})

      # Store the response from LeasePak API in log file
      res = Nokogiri.XML(response.hash[:envelope][:body][:add_schedule_response][:return])

      if res.search('TYPE').text.eql?("ERROR")
        errors << [errors.size + 1, res.search('KEY').text, res.search('FIELD').text, res.search('MSGCODE').text, res.search('MSGTEXT').text]
      else
        infos << [infos.size + 1, res.search('KEY').text, res.search('FIELD').text, res.search('MSGCODE').text, res.search('MSGTEXT').text]
      end
    end

    # # Store the response from LeasePak API in log file
    CSV.open("log/responses_#{Time.now}.csv", "wb") do |csv|
      csv << ["No", "AppNumber", "Field", "Code", "Response"]
      infos.each {|info| csv << info}
    end unless infos.empty?

    CSV.open("log/errors_#{Time.now}.csv", "wb") do |csv|
      csv << ["No", "AppNumber", "Field", "Code", "Error"]
      errors.each {|error| csv << error}
    end unless errors.empty?

  rescue Savon::Error => exception
    # Store message in log if client failes to connect with LeasePak API
    File.open('log/connection_error.log', 'a') do |line|
      line.puts "\r" + "An error occurred while calling the LeasePak: #{exception.message}"
    end
  end

  private

  # generate XML data from the data read from xsls file
  def generate_xml(row)
    xml = Builder::XmlMarkup.new
    xml.PAP_INTVSCH_RECORD do |d|
      d.appLseNumber(row["appNumber"])
      d.enabled("Y")
      (0..@config["lease_terms"].to_i).each do |i|

        duedate = row["dueDate_#{i}"].nil? ? '' : row["dueDate_#{i}"]
        amount = row["amount_#{i}"].nil? ? '' : row["amount_#{i}"]

        d.__send__("dueDate_#{i}") do
          d << duedate
        end
        d.__send__("amount_#{i}") do
          d << amount
        end
      end
    end
  end
end

if __FILE__ == $0
  # Initialize the PAPSchedule Service client and call operations
  load = Load.new
  load.load_request()
end
