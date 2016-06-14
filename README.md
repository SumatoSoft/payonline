## Payonline

[![Gem Version](https://badge.fury.io/rb/payonline.svg)](http://badge.fury.io/rb/payonline) [![Code Climate](https://codeclimate.com/github/yuri-zubov/payonline/badges/gpa.svg)](https://codeclimate.com/github/yuri-zubov/payonline)

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

Create an initializer: `config/initializers/payonline.rb`

```ruby
Payonline.config do |config|
  config.merchant_id = '12345'
  config.private_security_key = 'your-private-security-ke'
  config.return_url = 'https://example.com/payments/success'
  config.fail_url = 'https://example.com/payments/fail'
end
```

## Usage

Get payment URL

```ruby
Payonline::PaymentGateway.new(order_id: 1, amount: 2.0, currency: 'RUB').payment_url
```

Check callback

```ruby
@response = Payonline::PaymentResponse.new(params)

if response.valid_payment?
  Order.find(@response.order_id).set_paid!
end
```

## Contributing

1. Fork it
2. Clone it `git clone https://github.com/yuri-zubov/payonline`
3. Create your feature branch `git checkout -b my-new-feature`
4. Commit your changes `git commit -am 'Add some feature`
5. Push to the branch `git push origin my-new-feature`
6. Create new pull request through Github
