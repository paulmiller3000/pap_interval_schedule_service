require 'bundler'
Bundler.setup
require 'savon'
require "yaml"
require "csv"

class Load

  def initialize()
    # Initialize SOAP client using the WSDL
    @config = YAML.load(File.open('config/config.yml').read)
    @client = Savon.client(:wsdl => @config["wsdl"], log: false, ssl_verify_mode: :none)
  end

  # Call Load on the PAPSchedule Service
  def load_request()
    # Read CSV file to load the data to LeasePak API
    CSV.foreach(@config["path_to_file"], :headers => true, :col_sep => ',') do |row|
      # Post XML data to LeasePak API to save the PAP Schedule data
      response = @client.call(:add_schedule, message: {inputXmlStream: generate_xml(row)})

      # Store the response from LeasePak API in log file
      File.open('log/responses.log', 'a') do |line|
        line.puts "\r" + "Response for #{row['appNumber']} from LeasePak: #{response}"
      end
    end
  rescue Savon::Error => exception
    # Store message in log if client failes to connect with LeasePak API
    File.open('log/errors.log', 'a') do |line|
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
