require 'facter'
Facter.add(:keystone_user) do
  confine :kernel=> :linux
    setcode do
         %x{grep keystone /etc/passwd |cut -f1 -d:}.chomp

end
end

