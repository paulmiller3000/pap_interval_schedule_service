Load Client for PAP Interval Schedule
==============
SOAP client for the [PAP Interval Schedule](https://github.com/attiq/pap_Interval_schedule_service)

Uses the [Ruby](https://www.ruby-lang.org/en/)

If you have any issues, suggestions, improvements, etc. then please log them using GitHub issues.

## Requirements

* [ruby](https://www.ruby-lang.org/en/documentation/installation/) 


Usage
-----
Clone the [PAP Interval Schedule](https://github.com/attiq/pap_Interval_schedule_service) Git repository and get it up and running

* Clone this Git repository
* Place PAP interavl schedule data csv file under "/docs" directory
* Set configurations insiide "/config/config.yml"
  * wsdl = LeasePak API WSDL URL
  * path_to_file = Path to the PAP interval schedule data csv file
  * lease_terms = Numebr of Lease terms for witch PAP interval schedule data file is generated   

* On your bash run command: ruby load.rb

License
-------
The PAP Interval Schedule Client in Ruby is released under the MIT license.

Author
------
[Attiq Rao](https://github.com/attiq)

