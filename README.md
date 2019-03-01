# Load Client for PAP Interval Schedule
SOAP client for the [PAP Interval Schedule](https://github.com/attiq/pap_Interval_schedule_service)

Uses the [Ruby](https://www.ruby-lang.org/en/)

If you have any issues, suggestions, improvements, etc. then please log them using GitHub issues.

## Requirements

* [ruby](https://www.ruby-lang.org/en/documentation/installation/) 
* [bundler](https://github.com/bundler/bundler) 

## Usage
Clone the [PAP Interval Schedule] (https://github.com/attiq/pap_Interval_schedule_service) Git repository and get it up and running

* Clone this Git repository
* Run the following commands:
```
gem update --system
bundle
```
* Place PAP interval schedule data csv file under "/docs" directory
* Set configurations inside "/config/config.yml":
  * wsdl = LeasePak API WSDL URL
  * path_to_file = Path to the PAP interval schedule data csv file
  * lease_terms = Number of payments to generate. Multiply lease term by 2, then subtract 2
  	* Lease Term: 24, set value to 46 ((24x2)-2)
  	* Lease Term: 36, set value to 70
  	* Lease Term: 48, set value to 94
  	* Lease Term: 60, set value to 118

* On your bash run command: ruby load.rb

## License
The PAP Interval Schedule Client in Ruby is released under the MIT license.

## Author
[Attiq Rao](https://github.com/attiq)