require 'network_address_calculator/version'
require 'ip'
require 'netaddr'

module NetworkAddressCalculator

	def self.next_free_subnets(supernet, subnets, no_of_subnets=1, slash=24)

		if IP.new(supernet).size < get_host_count_from_slash(slash)
			raise ArgumentError, "Requested range is bigger than supernet"
		end

		if slash >= 30 
			raise ArgumentError, "The requested range is too small"
		end

		found_subnets = []

		no_of_subnets.times do 
			found_subnets << next_free_subnet(supernet, subnets, slash).to_s
			subnets.concat(found_subnets)
		end

		return found_subnets
	end

	private

	def self.get_free_ranges(supernet, subnets = [])
		used_subnets = []
		supernet = NetAddr::CIDR.create(supernet.to_s)

		subnets.each do |x|
			used_subnets << NetAddr::CIDR.create(x)
		end

		free_addresses = NetAddr.cidr_fill_in(supernet, used_subnets) - used_subnets
		return free_addresses
	end

	def self.get_host_count_from_slash(slash)
		network_classes = {
			0 => 4294967296,
			1 => 2147483648,
			2 => 1073741824,
			3 => 536870912,
			4 => 268435456,
			5 => 134217728,
			6 => 67108864,
			7 => 33554432,
			8 => 16777216,
			9 => 8388608,
			10 => 4194304,
			11 => 2097152,
			12 => 1048576,
			13 => 524288,
			14 => 262144,
			15 => 131072,
			16 => 65536,
			17 => 32768,
			18 => 16384,
			19 => 8192,
			20 => 4096,
			21 => 2048,
			22 => 1024,
			23 => 512,
			24 => 256,
			25 => 128,
			26 => 64,
			27 => 32,
			28 => 16,
			29 => 8,
			30 => 4,
			31 => 2,
			32 => 1,
		}
		if network_classes.include?(slash)
			return network_classes[slash]
		else
			return 1
		end
	end

	def self.next_free_subnet(supernet, subnets, slash=24)
		free_addrs = get_free_ranges(supernet, subnets)
		number_of_hosts = get_host_count_from_slash(slash)
		return_range = nil
		while return_range == nil
			free_addrs.each do |addr|
				addr_ip = IP.new(addr.to_s)
				if addr_ip.size >= number_of_hosts
					return_range = addr_ip.divide_by_hosts(number_of_hosts-2).first
					break
				end
			end
		end
		return return_range
	end

end
