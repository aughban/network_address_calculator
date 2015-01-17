Don't use this.. it really needs to be written properly...

#usage

```ruby
NetworkAddressCalculator.next_free_subnets(supernet, [array,of,subnets], number_of_subnets, cidr_size_in_slash_notation_without_slash)
```

or 

```ruby
NetworkAddressCalculator.next_free_subnets('10.0.0.0/8', ['10.0.0.0/24', '10.0.1.0/24', '10.0.2.0/24'],2,24)

#=> ["10.0.3.0/24", "10.0.4.0/24"] 
```
