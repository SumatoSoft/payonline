## Payonline  [![Gem Version](https://badge.fury.io/rb/payonline.svg)](http://badge.fury.io/rb/payonline) [![Code Climate](https://codeclimate.com/github/I0Result/payonline/badges/gpa.svg)](https://codeclimate.com/github/I0Result/payonline) 

This is a thin wrapper library that makes using PayOnline API a bit easier.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'payonline'
```

And then execute:

```sh
$ bundle
```

## Configuring

Create initialize file. This file is usually located at /config/initializers/payonline.rb
```ruby
Payonline.config do |c|
  c.merchant_id = '12345'
  c.private_security_key = '3844908d-4c2a-42e1-9be0-91bb5d068d22'
  c.return_url = 'http://you_domain/payments/success'
  c.fail_url = 'http://you_domain/payments/failed'
end
```

## Usage

Get payment link

```ruby
Payonline::PaymentGateway.new(order_id: 56789, amount: 9.99 , currency: 'USD').get_payment_url
```

Check Call-back
```ruby
 @paymant_response = Payonline::PaymentResponse.new(prms)
 if paymant_response.valid_payment?
  Order.find(@paymant_response.order_id).pay
 end
```

## Contributing

1. Fork it
2. Clone it `git clone http://github.com/path/to/your/fork`
3. Create your feature branch `git checkout -b my-new-feature`
4. Commit your changes `git commit -am 'Add some feature`
5. Push to the branch `git push origin my-new-feature`
6. Create new pull request through Github
